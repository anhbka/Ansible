### Note for work

```
if condition;
then
    commands;
fi
```


```
if condition;
then
    commands_01;
else
    commands_02;
fi
```

```
if condition;
then
    commands;
else if condition;
then
    commands;
else
    commands;
fi
```

```
if [ condition ];
then
    commands;
fi
```

```
if [ condition ];
then
    commands;
else
    commands;
fi
```

```
-eq => Bằng nhau (Equal)
-ne => Không bằng nhau (Not equal)
-lt => Nhỏ hơn (Less than)
-gt => Lớn hơn (Greater than)
-le => Nhỏ hơn hoặc bằng (Less or equal)
-ge => Lớn hơn hoặc bằng (Greater or equal)
```


* So sánh chuỗi

```
Sử dụng các cấu trúc sau để thực hiện việc so sánh chuỗi trong Bash shell

[[ $str1 = $str2 ]] hoặc [[ $str1 == $str2 ]]
Trả về TRUE nếu 2 biến str1 và str2 có nội dung giống nhau. FALSE nếu ngược lại.

[[ $str1 != $str2 ]]
Trả về TRUE nếu 2 biến str1 và str2 có nội dung giống nhau. FALSE nếu ngược lại.

[[ $str1 > $str2 ]]
Trả về TRUE nếu srt1 lớn hơn str2 tính theo bảng chữ cái. FALSE nếu ngược lại.
```

```
[[ $str1 < $str2 ]]
Trả về TRUE nếu srt1 nhỏ hơn str2 tính theo bảng chữ cái. FALSE nếu ngược lại.

[[ -z $str1 ]]
Trả về TRUE nếu $str1 là 1 chuỗi rỗng. FALSE nếu ngược lại

[[ -n $str1 ]]
Trả về TRUE nếu $str1 là 1 chuỗi khác rỗng. FALSE nếu ngược lại.
```


* Kiểm tra hệ thống tập tin

```
Sử dụng các phép toán kiểm tra hệ thống tập tin dưới đây bên trong cấu trúc kiểm tra [] ở phần 1.

[ -f $file_var]
Trả về TRUE nếu file_var là 1 tập tin.

[ -x $var ]
Trả về TRUE nếu var là tập tin và có quyền thực thi (executable)

[ -d $var ]
Trả về TRUE nếu var là 1 thư mục.

[ -e $var ]
Trả về TRUE nếu var tồn tại

[ -w $var ]
Trả về TRUE nếu var là 1 tập tin và có quyền ghi (writable)

[ -r $var ]
Trả về TRUE nếu var là 1 tập tin và có quyền đọc (readable)

[ -L $var ]
Trả về TRUE nếu var là 1 liên kết mềm (symlink)
```

```
str1="Not empty "
str2=""
if [[ -n $str1 ]] && [[ -z $str2 ]];
then
    echo TRUE
fi
```

```
str1="Not empty "
if [[ -n $str1 ]] || [[ -z $str1 ]];
then
    echo TRUE
fi
```


```
#!/bin/bash

file="image.jpg"
name=${file%.*}
extension=${file#*.}

echo "File Name: $name"
echo "File Extension: $extension"

Output: 
File Name: image
File Extension: jpg
```

```
How to rename files with extension *.jpg in current directory using shell script

#!/bin/bash

step=1
for pic in `find . -maxdepth 1 -iname '*.jpg' -type f`
do
   new=image-$step.${pic##*.}
   echo "Renaming $pic to $new"
   mv "$pic" "$new"
   let step++
done

Renaming ./car.jpg to image-1.jpg
Renaming ./bike.jpg to image-2.jpg
```


```
case “$luachon” in
   giatrimau_1) Các câu lệnh ;;
   giatrimau_2) Các câu lệnh ;;
   giatrimau_n) Các câu lệnh ;;
   *) Câu lệnh cho TH còn lại ;; (Giống default trong C/C++)
esac
```


```
case "$1" in
  1) echo 'Monday' ;;
  2) echo 'Tuesday' ;;
  3) echo 'Wednesday' ;;
  4) echo 'Thursday' ;;
  5) echo 'Friday' ;;
  6) echo 'Saturday' ;;
  7) echo 'Sunday' ;;
  *)
  echo "Don't match anything"
  exit 1
;;
esac
case "$1" in
  start | up)
    vagrant up
    ;;
  *)
    echo "Usage: $0 {start|stop|ssh}"
    ;;
esac
```
```
for i in {1..5}; do
    echo "Welcome $i"
done
# lặp từ 5 -> 50 với mỗi step nhảy có giá trị 5 đơn vị.
for i in {5..50..5}; do
    echo "Welcome $i"
done
```

- while: chủ yếu sử dụng vòng lặp này khi ta muốn thực thi một tập lệnh lặp đi lặp lại nhiều lần trong khi điều kiện vẫn còn đúng. (Ở phần điều kiện nếu là true thì vòng lặp while sẽ được thực thi)

```
a=0
while [ $a –le 5 ]
do
  echo $a
  a=$((
```
- Vòng while dùng để đọc file:

```
< file.txt | while read line;
do
  echo $line
done
```

- select: vòng lặp cung cấp một danh sách menu từ một tập các phần tử được cho có đánh số ở đầu để lựa chọn. (Đây là vòng lặp có sẵn trong ksh được điều chỉnh vào bash. Nó không có sẵn trong bash

```
#!/bin/bash
select brand in Samsung Sony iphone symphony Walton
do
echo "You have chosen $brand"
done
select DRINK in tea cofee water juice appe all none
do
   case $DRINK in
     tea|cofee|water|all)
        echo "Go to canteen"
        ;;
     juice|appe)
        echo "Available at home"
        ;;
     none)
        break
        ;;
     *) echo "ERROR: Invalid selection"
        ;;
  esac
done
```
- until: ngược lại với while, vòng lặp này sẽ thực thi tập lệnh của nó khi giá trị điều kiện là sai. Nó sẽ chạy tới khi thỏa mãn điều kiện là đúng.

```
a=0
until [ ! $a –le 5 ]
do
  echo $a
  a=$(($a + 1))
done
```

```
#/bin/bash
function slowquery_day(){
#> /tmp/text
#for x in `cal | sed 's/"$(date +%Y)"/ /g'| sed 's/[^0-9.]/ /g'| sed 's/'"$(date +%Y)"'/ /g'` ; do echo $x >> /tmp/text;
#sq=$(cat /tmp/text | wc -l)
#done
x=$(date +%d)
sq=$(date -d "$x day ago" +'%d')
echo $sq
echo "Total slowquery server $(hostname)"
echo "Number slowquery of day:"

seq -f '%02g' 1 $sq > /tmp/txt
for i in `cat /tmp/txt`
do
count=$(cat Gondor-UAT-AMSDB01-slow.log | grep $(date -d "-1 month" +%Y-%m)-$i | wc -l)
echo "Day $i: $count"
done
}

function min_max(){
cat Gondor-UAT-AMSDB01-slow.log | grep $(date -d "-1 month" +%Y-%m) -C 3 > /tmp/kq
grep -w Query_time /tmp/kq > /tmp/kq1
awk '{print $3}' /tmp/kq1 > /tmp/kq2
a=$(sort -n /tmp/kq2 | tail -1)
echo "Max time slowquery of month: $a "
b=$(sort -n /tmp/kq2 | head -1)
echo "Min time slowquery  of month: $b "
c=$(cat /tmp/kq2 | wc -l)
echo "Total slowquery of Month: $c"
d=$(awk '{s+=($1)} END {print s}' /tmp/kq2)
time_tb=$(($d/$c))
echo $time_tb
echo "Total time slowquery of Month: $d"
echo "Average period slowquery of the month: $(($d/$c))"
> /tmp/kq
> /tmp/kq1
> /tmp/kq2
}
slowquery_day
min_max
```

```
#/bin/bash
function slowquery_day(){
#> /tmp/text
#for x in `cal | sed 's/"$(date +%Y)"/ /g'| sed 's/[^0-9.]/ /g'| sed 's/'"$(date +%Y)"'/ /g'` ; do echo $x >> /tmp/text;
#sq=$(cat /tmp/text | wc -l)
#done
x=$(date +%d)
sq=$(date -d "$x day ago" +'%d')
echo "Total slowquery server $(hostname)"
echo "Number slowquery of day:"
for k in  {01..09}
do
count=$(cat /opt/mysql/data/$(hostname)-slow.log | grep $(date -d "-1 month" +%Y-%m)-$k | wc -l)
echo "Day $k: $count"
done

for (( c=10; c<=$sq; c++ ))
do
count1=$(cat /opt/mysql/data/$(hostname)-slow.log | grep $(date -d "-1 month" +%Y-%m)-$c | wc -l)
echo "Day $c: $count1"
done

}

function min_max(){
cat /opt/mysql/data/$(hostname)-slow.log | grep $(date -d "-1 month" +%Y-%m) -C 3 > /tmp/kq
grep -w Query_time /tmp/kq > /tmp/kq1
awk '{print $3}' /tmp/kq1 > /tmp/kq2
a=$(sort -n /tmp/kq2 | tail -1)
echo "Max time slowquery of month: $a "
b=$(sort -n /tmp/kq2 | head -1)
echo "Min time slowquery  of month: $b "
c=$(cat /tmp/kq2 | wc -l)
echo "Total slowquery of Month: $c"
d=$(awk '{s+=($1)} END {print s}' /tmp/kq2)
time_tb=$(($d/$c))
echo "Total time slowquery of Month: $d"
echo "Average period slowquery of the month: $(($d/$c))"
> /tmp/kq
> /tmp/kq1
> /tmp/kq2
}
slowquery_day
min_max
```

```
#/bin/bash
function slowquery_day(){
#> /tmp/text
#for x in `cal | sed 's/"$(date +%Y)"/ /g'| sed 's/[^0-9.]/ /g'| sed 's/'"$(date +%Y)"'/ /g'` ; do echo $x >> /tmp/text;
#sq=$(cat /tmp/text | wc -l)
#done
#x=$(date +%d)
sq=$(date -d "$(date +%d) day ago" +'%d')
echo "Total slow query server $(hostname)"
echo "Number slow query of day:"

#seq -f '%02g' 1 $sq > /tmp/txt
#for i in `cat /tmp/txt`
for (( i=1; i<=$sq; i++ ))
do
count=$(cat /opt/mysql/data/$(hostname)-slow.log | grep $(date -d "-1 month" +%Y-%m)-$(printf %02d $i) | grep Time | wc -l)
echo "Day $(printf %02d $i): $count"
done
}

function min_max(){
cat /opt/mysql/data/$(hostname)-slow.log | grep $(date -d "-1 month" +%Y-%m) -C 3 > /tmp/kq
grep -w Query_time /tmp/kq > /tmp/kq1
awk '{print $3}' /tmp/kq1 > /tmp/kq2
a=$(sort -n /tmp/kq2 | tail -1)
echo "Max time slow query of month: $a "
b=$(sort -n /tmp/kq2 | head -1)
echo "Min time slow query  of month: $b "
c=$(cat /tmp/kq2 | wc -l)
echo "Total slow query of Month: $c"
#d=$(awk '{s+=($1)} END {print s}' /tmp/kq2)
d=$(awk '{sum+=$1}; END {printf "%.5f\n", sum}'  /tmp/kq2)

#v=$(bc <<<"scale=5;$k/$c")
calc() { awk "BEGIN{ printf \"%.5f\n\", $* }"; }
v=$(calc $d/$c)

echo "Total time slow query of Month: $d"
echo "Average period slow query of the month: $v"
> /tmp/kq
> /tmp/kq1
> /tmp/kq2
}
slowquery_day
min_max
```