From: Johannes Moos <jmoos@gmx.de>
Subject: Re: Data recovery from linear array (Intel SS4000-E)
Date: Sat, 15 Oct 2011 14:44:39 +0200
Message-ID: <4E998037.50204@gmx.de>
References: <4E972C82.1020605@gmx.de> <4E97539D.8040007@turmel.org> <4E985902.1070606@gmx.de> <4E98ECC1.8080403@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E98ECC1.8080403@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,
here's my current status:

root@ThinkPad /media/Backup/NAS # mdadm --zero-superblock /dev/loop{0,1,3}

root@ThinkPad /media/Backup/NAS # mdadm --create --chunk=64 
--metadata=0.90 --level=linear -n 4 /dev/md0 /dev/loop{0,1,2,3}
mdadm: partition table exists on /dev/loop0 but will be lost or
        meaningless after creating array
Continue creating array? n
mdadm: create aborted.


I answered 'no' and checked the loop devices with disktype:

root@ThinkPad /media/Backup/NAS # disktype /dev/loop{0,1,2,3}

--- /dev/loop0
Block device, size 297.7 GiB (319668830208 bytes)
DOS/MBR partition map
Partition 1: 7.844 MiB (8224768 bytes, 16064 sectors from 1)
   Type 0x77 (Unknown)
Partition 2: 1.490 TiB (1638736625152 bytes, 3200657471 sectors from 16065)
   Type 0x88 (Unknown)

--- /dev/loop1
Block device, size 297.7 GiB (319668830208 bytes)

--- /dev/loop2
Block device, size 465.4 GiB (499703758848 bytes)
Blank disk/medium

--- /dev/loop3
Block device, size 465.4 GiB (499703758848 bytes)


fdisk output:

root@ThinkPad /usr/src/linux # fdisk -l /dev/loop0

Disk /dev/loop0: 319.7 GB, 319668830208 bytes
255 heads, 63 sectors/track, 38864 cylinders, total 624353184 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

       Device Boot      Start         End      Blocks   Id  System
/dev/loop0p1               1       16064        8032   77  Unknown
/dev/loop0p2           16065  3200673535  1600328735+  88  Linux plaintext


After examining /dev/loop0 with hexdump I found LVM on there as well:

hexdump -C /dev/loop0 | head -n 116
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  
|................|
*
000001c0  02 00 77 fe 3f 00 01 00  00 00 c0 3e 00 00 00 00  
|..w.?......>....|
000001d0  01 01 88 fe ff ff c1 3e  00 00 3f 28 c6 be 00 00  
|.......>..?(....|
000001e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  
|................|
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  
|..............U.|
00000200  3c 49 50 53 74 6f 72 50  61 72 74 69 74 69 6f 6e  
|<IPStorPartition|
00000210  20 76 65 72 73 69 6f 6e  3d 22 33 2e 30 22 20 73  | 
version="3.0" s|
00000220  69 7a 65 3d 22 31 31 37  33 22 20 6f 77 6e 65 72  |ize="1173" 
owner|
00000230  3d 22 73 74 6f 72 61 67  65 22 20 63 68 65 63 6b  |="storage" 
check|
00000240  73 75 6d 3d 22 22 20 73  69 67 6e 61 74 75 72 65  |sum="" 
signature|
00000250  3d 22 49 70 53 74 4f 72  44 79 4e 61 4d 69 43 64  
|="IpStOrDyNaMiCd|
00000260  49 73 4b 22 20 64 61 74  61 53 74 61 72 74 41 74  |IsK" 
dataStartAt|
00000270  53 65 63 74 6f 72 4e 6f  3d 22 31 36 31 32 38 22  
|SectorNo="16128"|
00000280  20 6c 6f 67 76 6f 6c 3d  22 30 22 20 63 61 74 65  | logvol="0" 
cate|
00000290  67 6f 72 79 3d 22 56 69  72 74 75 61 6c 20 44 65 
|gory="Virtual De|
000002a0  76 69 63 65 22 2f 3e 0a  3c 50 68 79 73 69 63 61 
|vice"/>.<Physica|
000002b0  6c 44 65 76 20 67 75 69  64 3d 22 37 37 37 64 36  |lDev 
guid="777d6|
000002c0  38 30 30 2d 37 30 65 37  2d 37 38 31 33 2d 38 34  
|800-70e7-7813-84|
000002d0  38 34 2d 30 30 30 30 34  38 36 38 62 62 64 38 22  
|84-00004868bbd8"|
000002e0  20 43 6f 6d 6d 65 6e 74  3d 22 22 20 57 6f 72 6c  | Comment="" 
Worl|
000002f0  64 57 69 64 65 49 44 3d  22 46 41 4c 43 4f 4e 20  
|dWideID="FALCON |
00000300  20 4c 56 4d 44 49 53 4b  2d 4d 30 39 4e 30 31 20  | 
LVMDISK-M09N01 |
00000310  20 76 31 2e 30 2d 30 2d  30 2d 30 30 22 2f 3e 0a  | 
v1.0-0-0-00"/>.|
00000320  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  
|................|
*
00000400  3c 44 79 6e 61 6d 69 63  44 69 73 6b 53 65 67 6d  
|<DynamicDiskSegm|
00000410  65 6e 74 20 67 75 69 64  3d 22 37 30 35 62 66 31  |ent 
guid="705bf1|
00000420  31 65 2d 38 66 36 39 2d  31 63 64 61 2d 38 37 32  
|1e-8f69-1cda-872|
00000430  37 2d 30 30 30 30 34 38  36 38 62 62 65 33 22 20  
|7-00004868bbe3" |
00000440  66 69 72 73 74 53 65 63  74 6f 72 3d 22 31 36 31  
|firstSector="161|
00000450  32 38 22 20 6c 61 73 74  53 65 63 74 6f 72 3d 22  |28" 
lastSector="|
00000460  32 32 32 37 31 22 20 6f  77 6e 65 72 3d 22 73 74  |22271" 
owner="st|
00000470  6f 72 61 67 65 22 20 64  61 74 61 73 65 74 3d 22  |orage" 
dataset="|
00000480  31 32 31 34 38 32 33 33  39 35 22 20 73 65 71 4e  |1214823395" 
seqN|
00000490  6f 3d 22 30 22 20 69 73  4c 61 73 74 53 65 67 6d  |o="0" 
isLastSegm|
000004a0  65 6e 74 3d 22 74 72 75  65 22 20 73 65 63 74 6f  |ent="true" 
secto|
000004b0  72 53 69 7a 65 3d 22 35  31 32 22 20 74 79 70 65  |rSize="512" 
type|
000004c0  3d 22 55 6d 61 70 22 20  6c 75 6e 54 79 70 65 3d  |="Umap" 
lunType=|
000004d0  22 30 22 20 74 69 6d 65  73 74 61 6d 70 3d 22 31  |"0" 
timestamp="1|
000004e0  32 31 34 38 32 33 33 39  35 22 20 75 6d 61 70 54  |214823395" 
umapT|
000004f0  69 6d 65 73 74 61 6d 70  3d 22 30 22 20 64 65 76 |imestamp="0" 
dev|
00000500  69 63 65 4e 61 6d 65 3d  22 4e 41 53 44 69 73 6b 
|iceName="NASDisk|
00000510  2d 30 30 30 30 32 22 20  66 69 6c 65 53 79 73 74  |-00002" 
fileSyst|
00000520  65 6d 3d 22 58 46 53 22  2f 3e 0a 3c 44 79 6e 61 
|em="XFS"/>.<Dyna|
00000530  6d 69 63 44 69 73 6b 53  65 67 6d 65 6e 74 20 67 
|micDiskSegment g|
00000540  75 69 64 3d 22 37 30 35  62 66 31 31 65 2d 38 66 
|uid="705bf11e-8f|
00000550  36 39 2d 31 63 64 61 2d  38 37 32 37 2d 30 30 30  
|69-1cda-8727-000|
00000560  30 34 38 36 38 62 62 65  33 22 20 66 69 72 73 74  |04868bbe3" 
first|
00000570  53 65 63 74 6f 72 3d 22  32 32 32 37 32 22 20 6c 
|Sector="22272" l|
00000580  61 73 74 53 65 63 74 6f  72 3d 22 32 31 31 39 34  
|astSector="21194|
00000590  32 33 22 20 6f 77 6e 65  72 3d 22 73 74 6f 72 61  |23" 
owner="stora|
000005a0  67 65 22 20 64 61 74 61  73 65 74 3d 22 31 32 31  |ge" 
dataset="121|
000005b0  34 38 32 33 33 39 35 22  20 73 65 71 4e 6f 3d 22  |4823395" 
seqNo="|
000005c0  31 22 20 69 73 4c 61 73  74 53 65 67 6d 65 6e 74  |1" 
isLastSegment|
000005d0  3d 22 74 72 75 65 22 20  73 65 63 74 6f 72 53 69  |="true" 
sectorSi|
000005e0  7a 65 3d 22 35 31 32 22  20 74 79 70 65 3d 22 4e  |ze="512" 
type="N|
000005f0  41 53 22 20 6c 75 6e 54  79 70 65 3d 22 30 22 20  |AS" 
lunType="0" |
00000600  74 69 6d 65 73 74 61 6d  70 3d 22 31 32 31 34 38  
|timestamp="12148|
00000610  32 33 33 39 35 22 20 75  6d 61 70 54 69 6d 65 73  |23395" 
umapTimes|
00000620  74 61 6d 70 3d 22 30 22  20 64 65 76 69 63 65 4e  |tamp="0" 
deviceN|
00000630  61 6d 65 3d 22 4e 41 53  44 69 73 6b 2d 30 30 30  
|ame="NASDisk-000|
00000640  30 32 22 2f 3e 0a 3c 44  79 6e 61 6d 69 63 44 69  
|02"/>.<DynamicDi|
00000650  73 6b 53 65 67 6d 65 6e  74 20 67 75 69 64 3d 22  |skSegment 
guid="|
00000660  35 36 32 63 35 65 35 35  2d 64 34 34 62 2d 61 63  
|562c5e55-d44b-ac|
00000670  37 39 2d 37 39 61 39 2d  30 30 30 30 34 38 36 38  
|79-79a9-00004868|
00000680  62 62 65 66 22 20 66 69  72 73 74 53 65 63 74 6f  |bbef" 
firstSecto|
00000690  72 3d 22 32 31 31 39 34  32 34 22 20 6c 61 73 74  |r="2119424" 
last|
000006a0  53 65 63 74 6f 72 3d 22  32 31 32 35 35 36 37 22  
|Sector="2125567"|
000006b0  20 6f 77 6e 65 72 3d 22  73 74 6f 72 61 67 65 22  | 
owner="storage"|
000006c0  20 64 61 74 61 73 65 74  3d 22 31 32 31 34 38 32  | 
dataset="121482|
000006d0  33 34 30 37 22 20 73 65  71 4e 6f 3d 22 30 22 20  |3407" 
seqNo="0" |
000006e0  69 73 4c 61 73 74 53 65  67 6d 65 6e 74 3d 22 74 
|isLastSegment="t|
000006f0  72 75 65 22 20 73 65 63  74 6f 72 53 69 7a 65 3d  |rue" 
sectorSize=|
00000700  22 35 31 32 22 20 74 79  70 65 3d 22 55 6d 61 70  |"512" 
type="Umap|
00000710  22 20 6c 75 6e 54 79 70  65 3d 22 30 22 20 74 69  |" 
lunType="0" ti|
00000720  6d 65 73 74 61 6d 70 3d  22 31 32 31 34 38 32 33  
|mestamp="1214823|
00000730  34 30 37 22 20 75 6d 61  70 54 69 6d 65 73 74 61  |407" 
umapTimesta|
00000740  6d 70 3d 22 30 22 20 64  65 76 69 63 65 4e 61 6d  |mp="0" 
deviceNam|
00000750  65 3d 22 4e 41 53 44 69  73 6b 2d 30 30 30 30 33  
|e="NASDisk-00003|
00000760  22 20 66 69 6c 65 53 79  73 74 65 6d 3d 22 58 46  |" 
fileSystem="XF|
00000770  53 22 2f 3e 0a 3c 44 79  6e 61 6d 69 63 44 69 73 
|S"/>.<DynamicDis|
00000780  6b 53 65 67 6d 65 6e 74  20 67 75 69 64 3d 22 35  |kSegment 
guid="5|
00000790  36 32 63 35 65 35 35 2d  64 34 34 62 2d 61 63 37  
|62c5e55-d44b-ac7|
000007a0  39 2d 37 39 61 39 2d 30  30 30 30 34 38 36 38 62  
|9-79a9-00004868b|
000007b0  62 65 66 22 20 66 69 72  73 74 53 65 63 74 6f 72  |bef" 
firstSector|
000007c0  3d 22 32 31 32 35 35 36  38 22 20 6c 61 73 74 53  |="2125568" 
lastS|
000007d0  65 63 74 6f 72 3d 22 33  32 30 30 36 37 31 34 38  
|ector="320067148|
000007e0  37 22 20 6f 77 6e 65 72  3d 22 73 74 6f 72 61 67  |7" 
owner="storag|
000007f0  65 22 20 64 61 74 61 73  65 74 3d 22 31 32 31 34  |e" 
dataset="1214|
00000800  38 32 33 34 30 37 22 20  73 65 71 4e 6f 3d 22 31  |823407" 
seqNo="1|
00000810  22 20 69 73 4c 61 73 74  53 65 67 6d 65 6e 74 3d  |" 
isLastSegment=|
00000820  22 74 72 75 65 22 20 73  65 63 74 6f 72 53 69 7a  |"true" 
sectorSiz|
00000830  65 3d 22 35 31 32 22 20  74 79 70 65 3d 22 4e 41  |e="512" 
type="NA|
00000840  53 22 20 6c 75 6e 54 79  70 65 3d 22 30 22 20 74  |S" 
lunType="0" t|
00000850  69 6d 65 73 74 61 6d 70  3d 22 31 32 31 34 38 32  
|imestamp="121482|
00000860  33 34 30 37 22 20 75 6d  61 70 54 69 6d 65 73 74  |3407" 
umapTimest|
00000870  61 6d 70 3d 22 30 22 20  64 65 76 69 63 65 4e 61  |amp="0" 
deviceNa|
00000880  6d 65 3d 22 4e 41 53 44  69 73 6b 2d 30 30 30 30  
|me="NASDisk-0000|
00000890  33 22 2f 3e 0a 00 00 00  00 00 00 00 00 00 00 00  
|3"/>............|
000008a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  
|................|
*
007e0000  85 f0 10 60 4b ea f7 df  00 00 00 f8 00 00 00 01  
|...`K...........|
007e0010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  
|................|
*
007e1000  5d 10 f0 85 00 00 00 00  00 00 20 00 e5 bb 68 48  |]......... 
...hH|
007e1010  7f 2b 00 00 00 00 00 00  00 00 00 00 08 00 00 00  
|.+..............|
007e1020  00 20 00 00 aa 58 27 50  01 00 00 00 00 00 00 00  |. 
...X'P........|
007e1030  00 00 00 00 01 00 00 00  00 00 00 00 00 00 00 00  
|................|
007e1040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  
|................|
*
007e1100  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  
|................|
*
007e1500  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  
|................|
*
00ae0000  58 46 53 42 00 00 10 00  00 00 00 00 00 04 00 00  
|XFSB............|

 From what I read in a forum it's possible to mount the XFS partition 
with an offset, in my case that would be 00ae0000 (last line in hexdump).
But the guy in the forum had no problem assembling his array, so I have 
to proceed with that first.

Just wanted to make sure that it's OK to answer 'yes' and let mdadm do 
its job?

Best regards,
Johannes Moos
