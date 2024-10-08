<h3> 1.	Vai trò của project Neutron </h3>
<p>- OpenStack Networking cho phép bạn tạo và quản lí các network objects ví dụ như networks, subnets, và ports cho các services khác của OpenStack sử dụng. Với kiến trúc plugable, các plug-in có thể được sử dụng để triển khai các thiết bị và phần mềm khác nhau, nó khiến OpenStack có tính linh hoạt trong kiến trúc và triển khai. </p>
<p>- Dịch vụ Networking trong OpenStack (neutron) cũng cấp API cho phép bạn định nghĩa các kết nối mạng và gán địa chỉ ở trong môi trường cloud. Nó cũng cho phép các nhà khai thác vận hành các công nghệ networking khác nhau cho phù hợp với mô hình điện toán đám mây của riêng họ. Neutron cũng cung cấp một API cho việc cấu hình cũng như quản lí các dịch vụ networking khác nhau từ L3 forwarding, NAT cho tới load balancing, perimeter firewalls, và virtual private networks.</p>
<h3> 2.	Các thành phần </h3>
<p>-<strong> API server</strong>: OpenStack Networking API hỗ trợ Layer2 networking và IP address management (IPAM - quản lý địa chỉ IP), cũng như một extension để xây dựng router Layer 3 cho phép định tuyến giữa các networks Layer 2 và các gateway để ra mạng bên ngoài. OpenStack Networking cung cấp một danh sách các plug-ins (đang ngày càng tăng lên) cho phép tương tác với nhiều công nghệ mạng mã nguồn mở và cả thương mại, bao gồm các routers, switches, switch ảo và SDN controller. </p>
<p>-<strong> OpenStack Networking plug-in and agents</strong>: Các plugin và các agent này cho phép gắn và gỡ các ports, tạo ra network hay subnet, và đánh địa chỉ IP. Lựa chọn plugin và agents nào là tùy thuộc vào nhà cung cấp và công nghệ sử dụng trong hệ thống cloud nhất định. Điều quan trọng là tại một thời điểm chỉ sử dụng được một plug-in.</p>
<p>-<strong> Messaging queue</strong> : Tiếp nhận và định tuyến các RPC requests giữa các agents để hoàn thành quá trình vận hành API. Các Message queue được sử dụng trong ML2 plugin để thực hiện truyền thông RPC giữa neutron server và các neutron agents chạy trên mỗi hypervisor, cụ thể là các ML2 driver cho Open vSwitch và Linux bridge.</p>
<h3> 3. Các khái niệm.</h3>
<p><strong> Provider networks </strong> : Provider networks cung cấp kết nối layer 2 cho các máy ảo với các tùy chọn hỗ trợ cho dịch vụ DHCP và metadata. Các kết nối này thường sử dụng VLAN (802.1q) để nhận diện và tách biệt nhau. Provider networks cũng cấp sự đơn giản, hiệu quả và sự minh bạch, linh hoạt trong chi phí. Mặc định chỉ có duy nhất người quản trị mới có thể tạo hoặc cập nhật provider networks bởi nó yêu cầu phải cấu hình thiết bị vật lí. </p>
<p>Các nhà khai thác đã quen thuộc với kiến trúc mạng ảo dựa trên nền tảng mạng vật lí cho layer 2, layer 3 và các dịch vụ khác có thể dễ dàng triển khai OpenStack Networking service. Provider networks cũng khiến các nhà khai thác muốn chuyển từ Compute networking service (nova-network) sang OpenStack Networking service.Vì các thành phần chịu trách nhiệm cho việc vận hành kết nối layer 3 sẽ ảnh hưởng tới hiệu năng và tính tin cậy nên provider networks chuyển các kết nối này xuống tầng vật lí.</p>
<img src="https://docs.openstack.org/install-guide/_images/network1-services.png">
<p>-<strong>Routed provider networks</strong>: Routed provider networks cung cấp kết nối ở layer 3 cho các máy ảo. Các network này map với những networks layer 3 đã tồn tại. Cụ thể hơn, các layer-2 segments của provider network sẽ được gán các router gateway giúp chúng có thể được định tuyến ra bên ngoài chứ thực chất Networking service không cung cấp khả năng định tuyến. Routed provider networks tất nhiên sẽ có hiệu suất thấp hơn so với provider networks.</p>
<p>-<strong>Self-service networks</strong>:  Self-service networks được ưu tiên ở các projects thông thường để quản lí networks mà không cần quản trị viên (quản lí network trong project). Các networks này là ảo và nó yêu cầu các routers ảo để giao tiếp với provider và external networks. Self-service networks cũng đồng thời cung cấp dịch vụ DHCP và metadata cho máy ảo.</p>
Trong hầu hết các trường hợp, self-service networks sử dụng các giao thức như VXLAN hoặc GRE bởi chúng hỗ trợ nhiều hơn là VLAN tagging (802.1q). Bên cạnh đó, Vlans cũng thường yêu cầu phải cấu hình thêm ở tầng vật lí.
<p>Với IPv4, self-service networks thường sử dụng dải mạng riêng và tương tác với provider networks thông qua cơ chế NAT trên router ảo. Floating IP sẽ cho phép kết nối tới máy ảo thông qua địa chỉ NAT trên router ảo. Trong khi đó, IPv6 self-service networks thì lại sử dụng dải IP public và tương tác với provider networks bằng giao thức định tuyến tĩnh qua router ảo. </p>
<img src="https://docs.openstack.org/install-guide/_images/network2-services.png">
<p>Trái ngược lại với provider networks, self-service networks buộc phải đi qua layer-3 agent. Vì thế việc gặp sự cố ở một node có thể ảnh hưởng tới rất nhiều các máy ảo sử dụng chúng.</p>
<p>Các user có thể tạo các project networks cho các kết nối bên trong project. Mặc định thì các kết nối này là riêng biệt và không được chia sẻ giữa các project. OpenStack Networking hỗ trợ các công nghệ dưới đây cho project network:</p>
<p><strong>Flat </strong> : Tất cả các instances nằm trong cùng một mạng, và có thể chia sẻ với hosts. Không hề sử dụng VLAN tagging hay hình thức tách biệt về network khác. </p>
<p><strong>VLAN</strong>: Kiểu này cho phép các users tạo nhiều provider hoặc project network sử dụng VLAN IDs(chuẩn 802.1Q tagged) tương ứng với VLANs trong mạng vật lý. Điều này cho phép các instances giao tiếp với nhau trong môi trường cloud. Chúng có thể giao tiếp với servers, firewalls, load balancers vật lý và các hạ tầng network khác trên cùng một VLAN layer 2.</p>
<p><strong>GRE</strong> and<strong> VXLAN</strong>: VXLAN và GRE là các giao thức đóng gói tạo nên overlay networks để kích hoạt và kiểm soát việc truyền thông giữa các máy ảo (instances). Một router được yêu cầu để cho phép lưu lượng đi ra luồng bên ngoài tenant network GRE hoặc VXLAN. Router cũng có thể yêu cầu để kết nối một tenant network với mạng bên ngoài (ví dụ Internet). Router cung cấp khả năng kết nối tới instances trực tiếp từ mạng bên ngoài sử dụng các địa chỉ floating IP. </p>
<p><strong>Subnets </strong> : Là một khối tập hợp các địa chỉ IP và đã được cấu hình. Quản lý các địa chỉ IP của subnet do IPAM driver thực hiện. Subnet được dùng để cấp phát các địa chỉ IP khi ports mới được tạo trên network.
<p><strong>Subnet pools</strong> : Người dùng cuối thông thường có thể tạo các subnet với bất kì địa chỉ IP hợp lệ nào mà không bị hạn chế. Tuy nhiên, trong một vài trường hợp, sẽ là ổn hơn nếu như admin hoặc tenant định nghĩa trước một pool các địa chỉ để từ đó tạo ra các subnets được cấp phát tự động. Sử dụng subnet pools sẽ ràng buộc những địa chỉ nào có thể được sử dụng bằng cách định nghĩa rằng mỗi subnet phải nằm trong một pool được định nghĩa trước. Điều đó ngăn chặn việc tái sử dụng địa chỉ hoặc bị chồng lấn hai subnets trong cùng một pool. </p>
<p><strong>Ports </strong> : Là điểm kết nối để attach một thiết bị như card mạng của máy ảo tới mạng ảo. Port cũng được cấu hình các thông tin như địa chỉ MAC, địa chỉ IP để sử dụng port đó.
Router : Cung cấp các dịch vụ layer 3 ví dụ như định tuyến, NAT giữa các self service và provider network hoặc giữa các self service với nhau trong cùng một project.</p>
<p><strong>Extensions </strong> : OpenStack Networking service có khả năng mở rộng. Có hai mục đích chính cho việc này: cho phép thực thi các tính năng mới trên API mà không cần phải đợi đến khi ra bản tiếp theo và cho phép các nhà phân phối bổ sung những chức năng phù hợp. Các ứng dụng có lấy danh sách các extensions có sẵn sử dụng phương thức GET trên /extensions URI. Chú ý đây là một request phụ thuộc vào phiên bản OpenStack, một extension trong một API ở phiên bản này có thể không sử dụng được cho phiên bản khác.</p>
<p><strong>DHCP </strong> : Dịch vụ tùy chọn DHCP quản lí địa chỉ IP trên provider và self-service networks. Networking service triển khai DHCP service sử dụng agent quản lí qdhcp namespaces và dnsmasq service.</p>
<p><strong> Metadata </strong>: Dịch vụ tùy chọn cung cấp API cho máy ảo để lấy metadata ví dụ như SSH keys.</p>
<strong> Open vSwitch </strong>
<p>OpenvSwitch (OVS) là công nghệ switch ảo hỗ trợ SDN (Software-Defined Network), thay thế Linux bridge. OVS cung cấp chuyển mạch trong mạng ảo hỗ trợ các tiêu chuẩn Netflow, OpenFlow, sFlow. OpenvSwitch cũng được tích hợp với các switch vật lý sử dụng các tính năng lớp 2 như STP, LACP, 802.1Q VLAN tagging. OVS tunneling cũng được hỗ trợ để triển khai các mô hình network overlay như VXLAN, GRE.</p>
<strong> L3 Agent </strong>
<p>L3 agent là một phần của package openstack-neutron. Nó được xem như router layer3 chuyển hướng lưu lượng và cung cấp dịch vụ gateway cho network lớp 2. Các nodes chạy L3 agent không được cấu hình IP trực tiếp trên một card mạng mà được kết nối với mạng ngoài. Thay vì thế, sẽ có một dải địa chỉ IP từ mạng ngoài được sử dụng cho OpenStack networking. Các địa chỉ này được gán cho các routers mà cung cấp liên kết giữa mạng trong và mạng ngoài. Miền địa chỉ được lựa chọn phải đủ lớn để cung cấp địa chỉ IP duy nhất cho mỗi router khi triển khai cũng như mỗi floating IP gán cho các máy ảo. </p>
<p><li>DHCP Agent: OpenStack Networking DHCP agent chịu trách nhiệm cấp phát các địa chỉ IP cho các máy ảo chạy trên network. Nếu agent được kích hoạt và đang hoạt động khi một subnet được tạo, subnet đó mặc định sẽ được kích hoạt DHCP.</li></p>
<p><li>Plugin Agent: Nhiều networking plug-ins được sử dụng cho agent của chúng, bao gồm OVS và Linux bridge. Các plug-in chỉ định agent chạy trên các node đang quản lý lưu lượng mạng, bao gồm các compute node, cũng như các nodes chạy các agent</li></p>
<h3> 4.  Các cấu trúc thành phần dịch vụ.</h3>
<p>- Server : Cung cấp API, quản lí database,... </p>
<p>- Plug-ins : Quản lí agents </p>
<p>- Agents : Cung cấp kết nối layer 2/3 tới máy ảo,xử lý truyền thông giữa mạng ảo và mạng vật lý. xử lý metadata ... </p>
<strong> Layer 2 (Ethernet and Switching) </strong>
<p><li> Linux Bridge </li></p>
<p><li> OVS </li></p>
<strong> Layer 3 (IP and Routing) </strong>
<p><li>L3  </li></p>
<p><li>DHCP  </li></p>
<p><strong> Khác : metadata.</strong></p>
<p><strong> Services : Các dịch vụ Routing </p></strong> 
<p><li>VPNaaS: Virtual Private Network-as-a-Service (VPNaaS), extension của neutron cho VPN </li></p>
<p><li>LBaaS: Load-Balancer-as-a-Service (LBaaS), API quy định và cấu hình nên các load balancers, được triển khai dựa trên HAProxy software load balancer. </li></p>
<p><li>FWaaS: Firewall-as-a-Service (FWaaS), API thử nghiệm cho phép các nhà cung cấp kiểm thử trên networking của họ. </li></p>
<h3> 5. Cấu hình Neutron </h3>
<p>- Section [Default]: </p>
<p><li> auth_strategy = keystone </li></p>
<p>Loại hình xác thực:</p>

<p><li>core_plugin = None</p></li>
<p></p>
<p><li></p></li>
<p>Plugin mà Neutron sẽ sử dụng:</p>
<p><li>dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq</p></li>
<p>Driver được sử dụng để quản lí DHCP server:</p>
<p><li>enable_isolated_metadata = False</p></li>
<p>DHCP server có thể hỗ trợ để cung cấp metadata trên các mạng riêng biệt:</p>
<p>Section [ml2]</p>
<p><li>type_drivers = local, flat, vlan, gre, vxlan, geneve</p></li>
<p>Loại driver được sử dụng:</p>
<p><li>mechanism_drivers =</p></li>
<p>Cơ chế network sử dụng (OVS, LB)</p>
<p>Section [ml2_type_flat]</p>
<p><li>flat_networks = *</p></li>
<p>Tên mạng vật lý được dùng làm flat network</p>
<p>Section [Linux bridge]</p>
<p><li>bridge_mappings =</p></li>

<p><li>physical_interface_mappings =</p></li>


<p>Section [vxlan]</p>
<p><li>enable_vxlan = True</p></li>
<p>Kích hoạt VXLAN</p>
<p><li>l2_population = False</p></li>
<p>Extension để sử dụng ml2 plugin’s l2population mechanism driver. Nó sẽ kích hoạt plugin để populate VXLAN forwarding table.</p>
<p><li>local_ip = None</p></li>

<p>Địa chỉ ip của overlay (tunnel) network endpoint.</p>
<p>Section [ovs]</p>
<p><li>bridge_mappings =</p></li>
<p>physical_network:</p>
<p>Section [security group]</p>
<p><li>enable_security_group = True</p></li>
<p>Kích hoạt security group API</p>
<p><li>firewall_driver = None</li></p>
<p>driver cho security groups firewall trong l2 agent.</p>





















