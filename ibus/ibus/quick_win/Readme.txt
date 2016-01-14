1. Create iBus database
1.1 ibus-table-createdb -n quick-windows.db -s quick-windows.txt

2. Install IME to Ubuntu 12.04
2.1 sudo cp quick-windows.db /usr/share/ibus-table/tables/
2.2 sudo cp quick-windows.png /usr/share/ibus-table/icons/

3. Change page size
3.1 sudo gedit /usr/share/ibus-table/engine/table.py
3.2 search "_page_size = 6" and change to "_page_size = 9"

4. Restart iBus daemon
4.1 sudo ibus-daemon -x -r -d
