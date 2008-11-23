From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Last Velociraptor analysis before moving to HW-RAID card.
Date: Sun, 23 Nov 2008 08:04:19 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811230649180.22086@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

With a small loop, I read every sector on the disk and captured the dmesg.

for dir in $(seq 1 100)
do
   mkdir -p "$dir"
   # total sectors = 586072368
   # but it errors if you try and read the last one, so 586072368-1
   sector=1
   sector_max=586072367
   while [ $sector != $sector_max ]
   do
     hdparm --read-sector $sector /dev/sda > $dir/$sector.sector 2>&1
     dmesg >> $dir/$sector.sector 2>&1
     printf "sector $sector/$sector_max\r"
     sector=$(($sector+1))
   done
done

After reading the entire disk, one sector at time; 
(1319, etc, is a regular sector):
-rw-r--r-- 1 root root   1319 2008-11-22 17:14 2.sector
-rw-r--r-- 1 root root   1319 2008-11-22 17:14 3.sector

A bad one (out of quite a few)
-rw-r--r-- 1 root root    820 2008-11-23 01:04 4765653.sector

Suffice to say-- time to try a HW RAID controller, will be getting a 3ware
9650SE-16 port card in a few days and I will see how the drives work with 
it, if they continue to have problems I will replace them all with 1TiB 
disks and be done with it as this is consuming too much time.

Example of one bad sector: (but read below to see what is REALLY strange)
# cat 4765653.sector
/dev/sda:
reading sector 4765653: FAILED: Input/output error
[663401.168896] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[663401.168902] ata1.00: irq_stat 0x40000001
[663401.168908] ata1.00: cmd 20/00:01:d5:b7:48/00:00:00:00:00/40 tag 0 pio 512 in
[663401.168909]          res 51/40:01:d5:b7:48/00:00:00:48:00/40 Emask 0x9 (media error)
[663401.168914] ata1.00: status: { DRDY ERR }
[663401.168918] ata1.00: error: { UNC }
[663401.193289] ata1.00: configured for UDMA/133
[663401.193302] ata1: EH complete
[663401.193356] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
[663401.193372] sd 0:0:0:0: [sda] Write Protect is off
[663401.193374] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[663401.193411] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

After this ran, I re-ran a short+long test:
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%       871         -
# 2  Short offline       Completed without error       00%       870         -

..... No errors!

In any case, will provide an update once I move over to the 9650SE and we'll
see how that goes, thanks all for those who responded in regards to my previous
velociraptor-issues :)

The full list:
1/4765653.sector:reading sector 4765653: FAILED: Input/output error
1/4765656.sector:reading sector 4765656: FAILED: Input/output error
1/4765659.sector:reading sector 4765659: FAILED: Input/output error
1/4765662.sector:reading sector 4765662: FAILED: Input/output error
1/4765666.sector:reading sector 4765666: FAILED: Input/output error
1/4765669.sector:reading sector 4765669: FAILED: Input/output error
1/4765672.sector:reading sector 4765672: FAILED: Input/output error
1/4765678.sector:reading sector 4765678: FAILED: Input/output error
1/4765681.sector:reading sector 4765681: FAILED: Input/output error
1/4765684.sector:reading sector 4765684: FAILED: Input/output error
1/4765687.sector:reading sector 4765687: FAILED: Input/output error
1/4765690.sector:reading sector 4765690: FAILED: Input/output error
1/4765693.sector:reading sector 4765693: FAILED: Input/output error
1/4765697.sector:reading sector 4765697: FAILED: Input/output error
1/4765700.sector:reading sector 4765700: FAILED: Input/output error
1/4765703.sector:reading sector 4765703: FAILED: Input/output error
1/4765707.sector:reading sector 4765707: FAILED: Input/output error
1/4765710.sector:reading sector 4765710: FAILED: Input/output error
1/4765713.sector:reading sector 4765713: FAILED: Input/output error
1/4765717.sector:reading sector 4765717: FAILED: Input/output error
1/4765720.sector:reading sector 4765720: FAILED: Input/output error
1/4765726.sector:reading sector 4765726: FAILED: Input/output error
1/4765729.sector:reading sector 4765729: FAILED: Input/output error
1/4765732.sector:reading sector 4765732: FAILED: Input/output error
1/4765735.sector:reading sector 4765735: FAILED: Input/output error
1/4765738.sector:reading sector 4765738: FAILED: Input/output error
1/4765741.sector:reading sector 4765741: FAILED: Input/output error
1/4765745.sector:reading sector 4765745: FAILED: Input/output error
1/4765749.sector:reading sector 4765749: FAILED: Input/output error
1/4765752.sector:reading sector 4765752: FAILED: Input/output error
1/4765755.sector:reading sector 4765755: FAILED: Input/output error
1/4765758.sector:reading sector 4765758: FAILED: Input/output error
1/4765761.sector:reading sector 4765761: FAILED: Input/output error
1/4765765.sector:reading sector 4765765: FAILED: Input/output error
1/4765768.sector:reading sector 4765768: FAILED: Input/output error
1/4765771.sector:reading sector 4765771: FAILED: Input/output error
1/4765774.sector:reading sector 4765774: FAILED: Input/output error
1/4765777.sector:reading sector 4765777: FAILED: Input/output error
1/4765780.sector:reading sector 4765780: FAILED: Input/output error
1/4765783.sector:reading sector 4765783: FAILED: Input/output error
1/4765786.sector:reading sector 4765786: FAILED: Input/output error
1/4765791.sector:reading sector 4765791: FAILED: Input/output error
1/4765795.sector:reading sector 4765795: FAILED: Input/output error
1/4765799.sector:reading sector 4765799: FAILED: Input/output error
1/4765801.sector:reading sector 4765801: FAILED: Input/output error
1/4765804.sector:reading sector 4765804: FAILED: Input/output error
1/4765807.sector:reading sector 4765807: FAILED: Input/output error
1/4765810.sector:reading sector 4765810: FAILED: Input/output error
1/4765813.sector:reading sector 4765813: FAILED: Input/output error
1/4765815.sector:reading sector 4765815: FAILED: Input/output error
1/4765818.sector:reading sector 4765818: FAILED: Input/output error
1/4765821.sector:reading sector 4765821: FAILED: Input/output error
1/4765824.sector:reading sector 4765824: FAILED: Input/output error
1/4765826.sector:reading sector 4765826: FAILED: Input/output error
1/4765829.sector:reading sector 4765829: FAILED: Input/output error
1/4765831.sector:reading sector 4765831: FAILED: Input/output error
1/4765834.sector:reading sector 4765834: FAILED: Input/output error
1/4765838.sector:reading sector 4765838: FAILED: Input/output error
1/4765840.sector:reading sector 4765840: FAILED: Input/output error
1/4765841.sector:reading sector 4765841: FAILED: Input/output error
1/4765843.sector:reading sector 4765843: FAILED: Input/output error
1/4765845.sector:reading sector 4765845: FAILED: Input/output error
1/4765847.sector:reading sector 4765847: FAILED: Input/output error
1/4765849.sector:reading sector 4765849: FAILED: Input/output error
1/4765851.sector:reading sector 4765851: FAILED: Input/output error
1/4765853.sector:reading sector 4765853: FAILED: Input/output error
1/4765855.sector:reading sector 4765855: FAILED: Input/output error
1/4765858.sector:reading sector 4765858: FAILED: Input/output error
1/4765860.sector:reading sector 4765860: FAILED: Input/output error
1/4765862.sector:reading sector 4765862: FAILED: Input/output error
1/4765864.sector:reading sector 4765864: FAILED: Input/output error
1/4765866.sector:reading sector 4765866: FAILED: Input/output error
1/4765868.sector:reading sector 4765868: FAILED: Input/output error
1/4765870.sector:reading sector 4765870: FAILED: Input/output error
1/4765873.sector:reading sector 4765873: FAILED: Input/output error
1/4765879.sector:reading sector 4765879: FAILED: Input/output error
1/4765881.sector:reading sector 4765881: FAILED: Input/output error
1/4765883.sector:reading sector 4765883: FAILED: Input/output error
1/4765887.sector:reading sector 4765887: FAILED: Input/output error
1/4765889.sector:reading sector 4765889: FAILED: Input/output error
1/4765895.sector:reading sector 4765895: FAILED: Input/output error
1/4765897.sector:reading sector 4765897: FAILED: Input/output error
1/4765899.sector:reading sector 4765899: FAILED: Input/output error
1/4765901.sector:reading sector 4765901: FAILED: Input/output error
1/4765903.sector:reading sector 4765903: FAILED: Input/output error
1/4765905.sector:reading sector 4765905: FAILED: Input/output error
1/4765906.sector:reading sector 4765906: FAILED: Input/output error
1/4765907.sector:reading sector 4765907: FAILED: Input/output error
1/4765909.sector:reading sector 4765909: FAILED: Input/output error
1/4765911.sector:reading sector 4765911: FAILED: Input/output error
1/4765913.sector:reading sector 4765913: FAILED: Input/output error
1/4765915.sector:reading sector 4765915: FAILED: Input/output error
1/4765917.sector:reading sector 4765917: FAILED: Input/output error
1/4765920.sector:reading sector 4765920: FAILED: Input/output error
1/4765922.sector:reading sector 4765922: FAILED: Input/output error
1/4765924.sector:reading sector 4765924: FAILED: Input/output error
1/4765926.sector:reading sector 4765926: FAILED: Input/output error
1/4765929.sector:reading sector 4765929: FAILED: Input/output error
1/4765934.sector:reading sector 4765934: FAILED: Input/output error
1/4765935.sector:reading sector 4765935: FAILED: Input/output error
1/4765937.sector:reading sector 4765937: FAILED: Input/output error
1/4765941.sector:reading sector 4765941: FAILED: Input/output error
1/4765944.sector:reading sector 4765944: FAILED: Input/output error
1/4765946.sector:reading sector 4765946: FAILED: Input/output error
1/4765950.sector:reading sector 4765950: FAILED: Input/output error
1/4765952.sector:reading sector 4765952: FAILED: Input/output error
1/4765954.sector:reading sector 4765954: FAILED: Input/output error
1/4765956.sector:reading sector 4765956: FAILED: Input/output error
1/4765957.sector:reading sector 4765957: FAILED: Input/output error
1/4765959.sector:reading sector 4765959: FAILED: Input/output error
1/4765962.sector:reading sector 4765962: FAILED: Input/output error
1/4765964.sector:reading sector 4765964: FAILED: Input/output error
1/4765966.sector:reading sector 4765966: FAILED: Input/output error
1/4765970.sector:reading sector 4765970: FAILED: Input/output error
1/4765972.sector:reading sector 4765972: FAILED: Input/output error
1/4765974.sector:reading sector 4765974: FAILED: Input/output error
1/4765977.sector:reading sector 4765977: FAILED: Input/output error
1/4765979.sector:reading sector 4765979: FAILED: Input/output error
1/4765981.sector:reading sector 4765981: FAILED: Input/output error
1/4765983.sector:reading sector 4765983: FAILED: Input/output error
1/4765985.sector:reading sector 4765985: FAILED: Input/output error
1/4765989.sector:reading sector 4765989: FAILED: Input/output error
1/4765991.sector:reading sector 4765991: FAILED: Input/output error
1/4765993.sector:reading sector 4765993: FAILED: Input/output error
1/4765995.sector:reading sector 4765995: FAILED: Input/output error
1/4765997.sector:reading sector 4765997: FAILED: Input/output error
1/4765999.sector:reading sector 4765999: FAILED: Input/output error
1/4766001.sector:reading sector 4766001: FAILED: Input/output error
1/4766003.sector:reading sector 4766003: FAILED: Input/output error
1/4766005.sector:reading sector 4766005: FAILED: Input/output error
1/4766008.sector:reading sector 4766008: FAILED: Input/output error
1/4766010.sector:reading sector 4766010: FAILED: Input/output error
1/4766013.sector:reading sector 4766013: FAILED: Input/output error
1/4766014.sector:reading sector 4766014: FAILED: Input/output error
1/4766016.sector:reading sector 4766016: FAILED: Input/output error
1/4766019.sector:reading sector 4766019: FAILED: Input/output error
1/4766020.sector:reading sector 4766020: FAILED: Input/output error
1/4766022.sector:reading sector 4766022: FAILED: Input/output error
1/4766027.sector:reading sector 4766027: FAILED: Input/output error
1/4766028.sector:reading sector 4766028: FAILED: Input/output error
1/4766029.sector:reading sector 4766029: FAILED: Input/output error
1/4766031.sector:reading sector 4766031: FAILED: Input/output error
1/4766032.sector:reading sector 4766032: FAILED: Input/output error
1/4766034.sector:reading sector 4766034: FAILED: Input/output error
1/4766035.sector:reading sector 4766035: FAILED: Input/output error
1/4766036.sector:reading sector 4766036: FAILED: Input/output error
1/4766038.sector:reading sector 4766038: FAILED: Input/output error
1/4766039.sector:reading sector 4766039: FAILED: Input/output error
1/4766040.sector:reading sector 4766040: FAILED: Input/output error
1/4766043.sector:reading sector 4766043: FAILED: Input/output error
1/4766044.sector:reading sector 4766044: FAILED: Input/output error
1/4766045.sector:reading sector 4766045: FAILED: Input/output error
1/4766046.sector:reading sector 4766046: FAILED: Input/output error
1/4766047.sector:reading sector 4766047: FAILED: Input/output error
1/4766049.sector:reading sector 4766049: FAILED: Input/output error
1/4766051.sector:reading sector 4766051: FAILED: Input/output error
1/4766052.sector:reading sector 4766052: FAILED: Input/output error
1/4766053.sector:reading sector 4766053: FAILED: Input/output error
1/4766054.sector:reading sector 4766054: FAILED: Input/output error
1/4766056.sector:reading sector 4766056: FAILED: Input/output error
1/4766058.sector:reading sector 4766058: FAILED: Input/output error
1/4766061.sector:reading sector 4766061: FAILED: Input/output error
1/4766063.sector:reading sector 4766063: FAILED: Input/output error
1/4766064.sector:reading sector 4766064: FAILED: Input/output error
1/4766065.sector:reading sector 4766065: FAILED: Input/output error
1/4766066.sector:reading sector 4766066: FAILED: Input/output error
1/4766067.sector:reading sector 4766067: FAILED: Input/output error
1/4766073.sector:reading sector 4766073: FAILED: Input/output error
1/4766075.sector:reading sector 4766075: FAILED: Input/output error
1/4766077.sector:reading sector 4766077: FAILED: Input/output error
1/4766078.sector:reading sector 4766078: FAILED: Input/output error
1/4766081.sector:reading sector 4766081: FAILED: Input/output error
1/4766082.sector:reading sector 4766082: FAILED: Input/output error
1/4766083.sector:reading sector 4766083: FAILED: Input/output error
1/4766084.sector:reading sector 4766084: FAILED: Input/output error
1/4766085.sector:reading sector 4766085: FAILED: Input/output error
1/4766086.sector:reading sector 4766086: FAILED: Input/output error
1/4766087.sector:reading sector 4766087: FAILED: Input/output error
1/4766088.sector:reading sector 4766088: FAILED: Input/output error
1/4766089.sector:reading sector 4766089: FAILED: Input/output error
1/4766090.sector:reading sector 4766090: FAILED: Input/output error
1/4766091.sector:reading sector 4766091: FAILED: Input/output error
1/4766092.sector:reading sector 4766092: FAILED: Input/output error
1/4766093.sector:reading sector 4766093: FAILED: Input/output error
1/4766094.sector:reading sector 4766094: FAILED: Input/output error
1/4766095.sector:reading sector 4766095: FAILED: Input/output error
1/4766096.sector:reading sector 4766096: FAILED: Input/output error
1/4766097.sector:reading sector 4766097: FAILED: Input/output error
1/4766099.sector:reading sector 4766099: FAILED: Input/output error
1/4766100.sector:reading sector 4766100: FAILED: Input/output error
1/4766101.sector:reading sector 4766101: FAILED: Input/output error
1/4766103.sector:reading sector 4766103: FAILED: Input/output error
1/4766105.sector:reading sector 4766105: FAILED: Input/output error
1/4766106.sector:reading sector 4766106: FAILED: Input/output error
1/4766107.sector:reading sector 4766107: FAILED: Input/output error
1/4766110.sector:reading sector 4766110: FAILED: Input/output error
1/4766112.sector:reading sector 4766112: FAILED: Input/output error
1/4766113.sector:reading sector 4766113: FAILED: Input/output error
1/4766114.sector:reading sector 4766114: FAILED: Input/output error
1/4766115.sector:reading sector 4766115: FAILED: Input/output error
1/4766116.sector:reading sector 4766116: FAILED: Input/output error
1/4766117.sector:reading sector 4766117: FAILED: Input/output error
1/4766118.sector:reading sector 4766118: FAILED: Input/output error
1/4766123.sector:reading sector 4766123: FAILED: Input/output error
1/4766124.sector:reading sector 4766124: FAILED: Input/output error
1/4766125.sector:reading sector 4766125: FAILED: Input/output error
1/4766126.sector:reading sector 4766126: FAILED: Input/output error
1/4766127.sector:reading sector 4766127: FAILED: Input/output error
1/4766129.sector:reading sector 4766129: FAILED: Input/output error
1/4766130.sector:reading sector 4766130: FAILED: Input/output error
1/4766131.sector:reading sector 4766131: FAILED: Input/output error
1/4766132.sector:reading sector 4766132: FAILED: Input/output error
1/4766135.sector:reading sector 4766135: FAILED: Input/output error
1/4766138.sector:reading sector 4766138: FAILED: Input/output error
1/4766139.sector:reading sector 4766139: FAILED: Input/output error
1/4766140.sector:reading sector 4766140: FAILED: Input/output error
1/4766141.sector:reading sector 4766141: FAILED: Input/output error
1/4766142.sector:reading sector 4766142: FAILED: Input/output error
1/4766146.sector:reading sector 4766146: FAILED: Input/output error
1/4766147.sector:reading sector 4766147: FAILED: Input/output error
1/4766148.sector:reading sector 4766148: FAILED: Input/output error
1/4766149.sector:reading sector 4766149: FAILED: Input/output error
1/4766150.sector:reading sector 4766150: FAILED: Input/output error
1/4766152.sector:reading sector 4766152: FAILED: Input/output error
1/4766153.sector:reading sector 4766153: FAILED: Input/output error
1/4766155.sector:reading sector 4766155: FAILED: Input/output error
1/4766156.sector:reading sector 4766156: FAILED: Input/output error
1/4766157.sector:reading sector 4766157: FAILED: Input/output error
1/4766158.sector:reading sector 4766158: FAILED: Input/output error
1/4766159.sector:reading sector 4766159: FAILED: Input/output error
1/4766160.sector:reading sector 4766160: FAILED: Input/output error
1/4766161.sector:reading sector 4766161: FAILED: Input/output error
1/4766162.sector:reading sector 4766162: FAILED: Input/output error
1/4766163.sector:reading sector 4766163: FAILED: Input/output error
1/4766167.sector:reading sector 4766167: FAILED: Input/output error
1/4766168.sector:reading sector 4766168: FAILED: Input/output error
1/4766169.sector:reading sector 4766169: FAILED: Input/output error
1/4766171.sector:reading sector 4766171: FAILED: Input/output error
1/4766172.sector:reading sector 4766172: FAILED: Input/output error
1/4766173.sector:reading sector 4766173: FAILED: Input/output error
1/4766174.sector:reading sector 4766174: FAILED: Input/output error
1/4766175.sector:reading sector 4766175: FAILED: Input/output error
1/4766177.sector:reading sector 4766177: FAILED: Input/output error
1/4766181.sector:reading sector 4766181: FAILED: Input/output error
1/4766182.sector:reading sector 4766182: FAILED: Input/output error
1/4766185.sector:reading sector 4766185: FAILED: Input/output error
1/4766186.sector:reading sector 4766186: FAILED: Input/output error
1/4766187.sector:reading sector 4766187: FAILED: Input/output error
1/4766190.sector:reading sector 4766190: FAILED: Input/output error
1/4766191.sector:reading sector 4766191: FAILED: Input/output error
1/4766192.sector:reading sector 4766192: FAILED: Input/output error
1/4766193.sector:reading sector 4766193: FAILED: Input/output error
1/4766194.sector:reading sector 4766194: FAILED: Input/output error
1/4766195.sector:reading sector 4766195: FAILED: Input/output error
1/4766197.sector:reading sector 4766197: FAILED: Input/output error
1/4766198.sector:reading sector 4766198: FAILED: Input/output error
1/4766200.sector:reading sector 4766200: FAILED: Input/output error
1/4766203.sector:reading sector 4766203: FAILED: Input/output error
1/4766204.sector:reading sector 4766204: FAILED: Input/output error
1/4766205.sector:reading sector 4766205: FAILED: Input/output error
1/4766206.sector:reading sector 4766206: FAILED: Input/output error
1/4766207.sector:reading sector 4766207: FAILED: Input/output error
1/4766209.sector:reading sector 4766209: FAILED: Input/output error

smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART Error Log Version: 1
ATA Error Count: 265 (device log contains only the most recent five errors)
 	CR = Command Register [HEX]
 	FR = Features Register [HEX]
 	SC = Sector Count Register [HEX]
 	SN = Sector Number Register [HEX]
 	CL = Cylinder Low Register [HEX]
 	CH = Cylinder High Register [HEX]
 	DH = Device/Head Register [HEX]
 	DC = Device Command Register [HEX]
 	ER = Error register [HEX]
 	ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 265 occurred at disk power-on lifetime: 866 hours (36 days + 2 hours)
   When the command that caused the error occurred, the device was doing SMART Offline or Self-test.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 01 01 ba 48 40  Error: UNC at LBA = 0x0048ba01 = 4766209

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   20 00 01 01 ba 48 00 08  10d+08:31:15.085  READ SECTOR(S)
   20 00 01 00 ba 48 00 08  10d+08:31:08.857  READ SECTOR(S)
   27 00 00 00 00 00 00 08  10d+08:31:08.845  READ NATIVE MAX ADDRESS EXT
   ec 00 00 00 00 00 00 08  10d+08:31:08.838  IDENTIFY DEVICE
   ef 03 46 00 00 00 00 08  10d+08:31:08.838  SET FEATURES [Set transfer mode]

Error 264 occurred at disk power-on lifetime: 866 hours (36 days + 2 hours)
   When the command that caused the error occurred, the device was doing SMART Offline or Self-test.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 01 ff b9 48 40  Error: UNC at LBA = 0x0048b9ff = 4766207

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   20 00 01 ff b9 48 00 08  10d+08:31:01.825  READ SECTOR(S)
   27 00 00 00 00 00 00 08  10d+08:31:01.813  READ NATIVE MAX ADDRESS EXT
   ec 00 00 00 00 00 00 08  10d+08:31:01.807  IDENTIFY DEVICE
   ef 03 46 00 00 00 00 08  10d+08:31:01.807  SET FEATURES [Set transfer mode]
   27 00 00 00 00 00 00 08  10d+08:31:01.798  READ NATIVE MAX ADDRESS EXT

Error 263 occurred at disk power-on lifetime: 866 hours (36 days + 2 hours)
   When the command that caused the error occurred, the device was doing SMART Offline or Self-test.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 01 fe b9 48 40  Error: UNC at LBA = 0x0048b9fe = 4766206

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   20 00 01 fe b9 48 00 08  10d+08:30:54.794  READ SECTOR(S)
   27 00 00 00 00 00 00 08  10d+08:30:54.782  READ NATIVE MAX ADDRESS EXT
   ec 00 00 00 00 00 00 08  10d+08:30:54.775  IDENTIFY DEVICE
   ef 03 46 00 00 00 00 08  10d+08:30:54.775  SET FEATURES [Set transfer mode]
   27 00 00 00 00 00 00 08  10d+08:30:54.767  READ NATIVE MAX ADDRESS EXT

Error 262 occurred at disk power-on lifetime: 866 hours (36 days + 2 hours)
   When the command that caused the error occurred, the device was doing SMART Offline or Self-test.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 01 fd b9 48 40  Error: UNC at LBA = 0x0048b9fd = 4766205

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   20 00 01 fd b9 48 00 08  10d+08:30:47.763  READ SECTOR(S)
   27 00 00 00 00 00 00 08  10d+08:30:47.750  READ NATIVE MAX ADDRESS EXT
   ec 00 00 00 00 00 00 08  10d+08:30:47.744  IDENTIFY DEVICE
   ef 03 46 00 00 00 00 08  10d+08:30:47.744  SET FEATURES [Set transfer mode]
   27 00 00 00 00 00 00 08  10d+08:30:47.735  READ NATIVE MAX ADDRESS EXT

Error 261 occurred at disk power-on lifetime: 866 hours (36 days + 2 hours)
   When the command that caused the error occurred, the device was doing SMART Offline or Self-test.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 01 fc b9 48 40  Error: UNC at LBA = 0x0048b9fc = 4766204

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   20 00 01 fc b9 48 00 08  10d+08:30:40.731  READ SECTOR(S)
   27 00 00 00 00 00 00 08  10d+08:30:40.719  READ NATIVE MAX ADDRESS EXT
   ec 00 00 00 00 00 00 08  10d+08:30:40.713  IDENTIFY DEVICE
   ef 03 46 00 00 00 00 08  10d+08:30:40.713  SET FEATURES [Set transfer mode]
   27 00 00 00 00 00 00 08  10d+08:30:40.705  READ NATIVE MAX ADDRESS EXT
