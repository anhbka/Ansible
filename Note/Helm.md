* Install Helm

```
curl -O https://get.helm.sh/helm-v3.16.2-linux-amd64.tar.gz
tar xvf helm-v3.16.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
helm version
rm helm-v3.16.2-linux-amd64.tar.gz
```

### 1. helm install

Cú pháp: `helm install [release_name] [chart] [flags]`

Mô tả: Cài đặt một chart Helm mới. `release_name` là tên của bản phát hành, và chart là đường dẫn đến chart hoặc tên của chart trong kho.

### 2. helm upgrade

Cú pháp: helm upgrade [release_name] [chart] [flags]

Mô tả: Cập nhật một bản phát hành đã cài đặt với chart mới hoặc các giá trị mới.

### 3. helm uninstall

Cú pháp: helm uninstall [release_name] [flags]

Mô tả: Gỡ bỏ một bản phát hành đã cài đặt.

### 4. helm list

Cú pháp: helm list [flags]

Mô tả: Liệt kê tất cả các bản phát hành đã cài đặt trong namespace hiện tại.

### 5. helm repo add

Cú pháp: helm repo add [repo_name] [repo_url]

Mô tả: Thêm một kho chart mới vào danh sách kho chart của Helm.

### 6. helm repo update

Cú pháp: helm repo update

Mô tả: Cập nhật danh sách các chart có sẵn từ tất cả các kho đã được thêm.

### 7. helm search

Cú pháp: `helm search [keyword]`

Mô tả: Tìm kiếm các chart trong kho chart đã được thêm. Có thể tìm kiếm theo tên hoặc mô tả.

### 8. helm get

Cú pháp: `helm get [release_name] [flags]`

Mô tả: Lấy thông tin chi tiết về một bản phát hành, bao gồm các giá trị đã sử dụng và cấu hình.

### 9. helm rollback

Cú pháp: `helm rollback [release_name] [revision]`

Mô tả: Quay lại một phiên bản trước đó của bản phát hành.

### 10. helm template

Cú pháp: `helm template [chart] [flags]`

Mô tả: Tạo ra các tài nguyên Kubernetes từ chart mà không cài đặt chúng. Thích hợp cho việc kiểm tra hoặc tạo tài nguyên tạm thời.

### 11. helm status

Cú pháp: `helm status [release_name]`

Mô tả: Hiển thị trạng thái hiện tại của một bản phát hành.

### 12. helm history

Cú pháp: `helm history [release_name]`

Mô tả: Hiển thị lịch sử các phiên bản của một bản phát hành.

### 13. helm lint

Cú pháp: `helm lint [chart]`

Mô tả: Kiểm tra chart để phát hiện các lỗi hoặc vấn đề tiềm ẩn.

### 14. helm package

Cú pháp: `helm package [chart]`

Mô tả: Đóng gói một chart thành file .tgz để dễ dàng phân phối.

### 15. helm pull

Cú pháp: `helm pull [chart] [flags]`

Mô tả: Tải xuống một chart từ kho chart mà không cài đặt nó.

### 16. helm test

Cú pháp: `helm test [release_name]`

Mô tả: Chạy các bài kiểm tra cho một bản phát hành đã cài đặt.

### 17. helm uninstall

Cú pháp: `helm uninstall [release_name]`

Mô tả: Gỡ bỏ một bản phát hành đã cài đặt.

### 18. helm dependency

Cú pháp: `helm dependency [command]`

Mô tả: Quản lý các phụ thuộc của chart, bao gồm build, update, và list.

### 19. helm repo remove

Cú pháp: `helm repo remove [repo_name]`

Mô tả: Gỡ bỏ một kho chart khỏi danh sách kho chart của Helm.

### 20. helm show

Cú pháp: `helm show [chart]`

Mô tả: Hiển thị thông tin