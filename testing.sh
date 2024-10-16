./test.sh 00
./test.sh 01
./test.sh 02
./test.sh 03
echo "Test 1:"
./easy_compress.sh ./test_folder00
echo "Test 2:"
./easy_compress.sh ./test_folder01 60
echo "Test 3:"
./easy_compress.sh ./test_folder02 50
echo "Test 4:"
./easy_compress.sh ./test_folder03 40
