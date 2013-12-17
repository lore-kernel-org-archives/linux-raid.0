From: Nikolaus Jeremic <jeremic@informatik.uni-rostock.de>
Subject: RAID 6 reads all remaining chunks in a stripe when a single chunk
 is rewritten
Date: Tue, 17 Dec 2013 11:40:08 +0100
Message-ID: <52B02A08.4090007@informatik.uni-rostock.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've did some Linux MD RAID 5 and 6 random write performance tests with 
fio 2.1.2 (Flexible I/O tester) under Linux 3.12.4. However, the results 
for RAID 6 show that writes to a single chunk in a stripe (chunk size is 
64 KB) result in more than 3 reads in case of more than 6 drives (tested 
with 7, 8, and 9 drives) in the array (see fio statistics below). It 
seems like that in the event of updating one data chunk in a stripe, all 
of the remaining data chunks are read.

By the way, in case of RAID 5 and 5 or more drives, the remaining chunks 
seem not to be read when updating a single chunk in a stripe.

Here is the fio job description:

########
[global]
ioengine=libaio
iodepth=128
direct=1
continue_on_error=1
time_based
norandommap
rw=randwrite
filename=/dev/md9
bs=64k
numjobs=1
stonewall
runtime=300


[randwritesjob]
########

And, the mdadm commands that were used to create the RAID6 arrays:

6 drives:

mdadm --create /dev/md9 --raid-devices=6 --chunk=64 --assume-clean 
--level=6 /dev/sds1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdx1

7 drives:

mdadm --create /dev/md9 --raid-devices=7 --chunk=64 --assume-clean 
--level=6 /dev/sds1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 
/dev/sdx1

8 drives:
mdadm --create /dev/md9 --raid-devices=8 --chunk=64 --assume-clean 
--level=6 /dev/sds1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 
/dev/sdh1 /dev/sdx1

9 drives:

mdadm --create /dev/md9 --raid-devices=9 --chunk=64 --assume-clean 
--level=5 /dev/sds1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 
/dev/sdh1 /dev/sdn1 /dev/sdx1


In case of 6 drives the number of reads equals to the number of writes 
(3 reads and 3 writes per chunk update):

Disk stats (read/write):
     md9: ios=253/210879, merge=0/0
   sdc: ios=105763/105167, merge=1586024/1577446
   sdd: ios=105543/105414, merge=1582303/1581166
   sde: ios=105585/105431, merge=1582110/1581422
   sdf: ios=105401/105554, merge=1580325/1583232
   sds: ios=105369/105535, merge=1580462/1582964
   sdx: ios=105265/105642, merge=1578948/1584552

However, because reading the remaining 3 data chunks and reading one 
data chunk and 2 parity chunks results in the same number of reads, it's 
not clear which of the two variants is used for MD RAID6.


In case of 7 drives the number of reads seems to be 4 for each chunk update:

Disk stats (read/write):
     md9: ios=249/203012, merge=0/0
   sdc: ios=116110/86970, merge=1740493/1304459
   sdd: ios=115974/87089, merge=1738768/1306256
   sde: ios=115840/87219, merge=1736818/1308189
   sdf: ios=115981/87090, merge=1738738/1306242
   sdg: ios=116114/86894, merge=1741662/1303300
   sds: ios=116044/86964, merge=1740614/1304337
   sdx: ios=116176/86832, merge=1742593/1302371


In case of 8 drives the number of reads seems to increase to 5 for each 
chunk update:

Disk stats (read/write):
     md9: ios=249/193770, merge=0/0
   sdc: ios=121322/72530, merge=1818647/1087889
   sdd: ios=121010/72765, merge=1815182/1091398
   sde: ios=121007/72815, merge=1814401/1092150
   sdf: ios=121303/72512, merge=1818887/1087653
   sdg: ios=121124/72648, merge=1816862/1089676
   sdh: ios=121134/72645, merge=1816998/1089599
   sds: ios=121134/72692, merge=1816231/1090337
   sdx: ios=121022/72750, merge=1815408/1091172


And, in case of 9 drives the number of reads seems to increase to 6 for 
each chunk update:

Disk stats (read/write):
     md9: ios=80/10337, merge=0/0
   sdc: ios=6855/3496, merge=102721/52425
   sdd: ios=6876/3468, merge=103141/52005
   sde: ios=6914/3446, merge=103471/51675
   sdf: ios=6837/3522, merge=102331/52815
   sdg: ios=6923/3422, merge=103815/51331
   sdh: ios=6902/3442, merge=103530/51631
   sdn: ios=6912/3448, merge=103440/51705
   sds: ios=6976/3385, merge=104385/50760
   sdx: ios=6935/3408, merge=104041/51105


To my mind, updating a single chunk in a RAID 6 with 6 or more drives 
should not incur more than reading 3 chunks and writing 3 chunks. The 
reason is that for overwriting a single chunk, it suffices to read the 
old content of the chunk and the two corresponding parity chunks (P and 
Q) in order to be able to calculate the new parity values. After that, 
the new content of the updated data chunk is written along with the two 
parity chunks. Perhaps, this behavior can be controlled by a 
configuration parameter that I have not found yet.
Is anyone aware of this issue in MD RAID 6?


Thanks,
Nikolaus

-- 
Dipl.-Inf. Nikolaus Jeremic          nikolaus.jeremic@uni-rostock.de
Universitaet Rostock                 Tel:  (+49) 381 / 498 - 7635
Albert-Einstein-Str. 22	             Fax:  (+49) 381 / 498 - 7482
18059 Rostock, Germany               wwwava.informatik.uni-rostock.de
