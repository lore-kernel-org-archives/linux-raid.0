From: Ron Leach <ronleach@tesco.net>
Subject: Repairing R1: Part tabl, & precise command
Date: Tue, 05 Apr 2016 10:14:57 +0100
Message-ID: <57038211.6040101@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

List, good morning,

We use a 2 x 3TB Raid 1 configuration in a Debian Oldstable (Wheezy) 
machine employed for backup and one of the Raid pair has dropped off 
the array.  An lsdrv report [1] is pasted below; sdb has failed. 
Oddly, the offending disc seems to not have a partition table, now, 
either.  The backup space occupied an LVM space on a 2.5TB R1 array; 
the discs also have other R1 arrays.  I haven't altered any of the 
information on the surviving element of the raid1-lvm, which seems to 
be (read) functioning and with its data complete.

I've re-seated cables and power connectors and read-tested the failed 
disc using

dd if=/dev/sdb of=/dev/null bs=1M

which, after running overnight, reported the whole (suspect) disc read 
without any errors.

I'd like to try to restore the array using the previously-failed disk, 
temporarily, while another drive arrives from suppliers.  I'm not sure 
of the precise mechanism for restoring the array.  I think the same 
process will be needed when the replacement disk - which will be 
blank, too - arrives.

Presumably, I need to set up the partition table again.  These are 
identical discs from the same manufacturer.  Elsewhere, people have 
suggested using:

sfdisk -d /dev/sdc | sfdisk /dev/sdb

Will this be ok for mdadm or will this command also replicate some 
UUIDs or headers or partition content that mdadm prefers should be 
kept unique?

Having prepared the partition table on sdb, is the next step a simple

mdadm --manage /dev/md(x) --add /dev/sdb(y)

sequence of commands?  Do I need to disable any attempt by mdadm to 
rebuild itself?

Would be grateful for any pointers to anything incorrect I'm 
proposing.  Though it is 'only' backup material on the disks, to us it 
is pretty important because it was incremental and also therefore is 
the repository of anything accidentally deleted since.

regards, Ron

[1] lsdrv output

root@D7bak:/home/user# ./lsdrv

PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation NM10/ICH7 
Family SATA Controller [IDE mode] (rev 01)


-scsi 0:0:1:0 ATA      WDC WD2500AAKX-2 {WD-WCC2ED752256}

-:sda 232.88g [8:0] Partitioned (dos)
- -sda1 17.27g [8:1] ext2 {ac6943f4-24dd-4605-ab97-9633bdf4aa0f}
- -sda2 1.00k [8:2] Partitioned (dos)
- -sda5 1.86g [8:5] ext4 {d0f0831b-b67b-43c7-869a-74ccd2b82f0a}
- -:Mounted as /dev/disk/by-uuid/d0f0831b-b67b-43c7-869a-74ccd2b82f0a @ /
- -sda6 13.97g [8:6] ext4 {777a0299-5756-4bb4-ae86-4b968a25ed20}
- -:Mounted as /dev/sda6 @ /usr
- -sda7 23.28g [8:7] ext4 {519b7c6e-cc14-4b4e-b8cb-8d9573da48fb}
- -:Mounted as /dev/sda7 @ /var
- -sda8 2.05g [8:8] swap {c1527154-1cfe-42c9-bc00-780fda199508}
- -sda9 2.79g [8:9] ext4 {ca294bd6-4c95-4008-8531-1f467d2a3d7b}
- -:Mounted as /dev/sda9 @ /tmp
- :sda10 79.16g [8:10] ext4 {1a4793f3-cb46-4256-88f6-f065b4c49d88}
-  :Mounted as /dev/sda10 @ /home


-scsi 1:0:0:0 ATA      WDC WD30EZRX-00D {WD-WMC1T4003426}

-:sdb 2.73t [8:16] Empty/Unknown


:scsi 1:0:1:0 ATA      WDC WD30EZRX-00D {WD-WMC1T3894559}

  :sdc 2.73t [8:32] Partitioned (gpt)
   -sdc1 1.00m [8:33] Empty/Unknown
   -sdc2 100.00m [8:34] MD raid1 (1/2) in_sync 
{cc72a049-f9e6-7085-4a8f-b478c8ee9588}
   -:md2 99.94m [9:2] MD v0.90 raid1 (2) read-auto DEGRADED 
{cc72a049:f9e67085:4a8fb478:c8ee9588}
   -                  ext2 'boot' {e211fdf8-4179-4d52-b994-61e958789b6c}
   -sdc3 2.00g [8:35] Empty/Unknown
   -sdc4 150.00g [8:36] MD raid1 (1/2) in_sync 'D7bak:4' 
{741fb6b3-491b-f823-ba5d-bb377101ce96}
   -:md4 149.87g [9:4] MD v1.2 raid1 (2) read-auto DEGRADED 
{741fb6b3:491bf823:ba5dbb37:7101ce96}
   -                   ext4 'OS' {618eae7a-2a6b-44fd-90d4-74595d3f24bd}
   :sdc5 2.58t [8:37] MD raid1 (1/2) in_sync 'D7bak:5' 
{0a1bd77e-6f0d-4fba-3260-932c021ed347}
    :md5 2.58t [9:5] MD v1.2 raid1 (2) clean DEGRADED 
{0a1bd77e:6f0d4fba:3260932c:021ed347}
     -               PV LVM2_member 2.58t used, 0 free 
{5b0KRp-rFJ3-WiBR-JW3i-U01v-SITm-fNcVbr}
     :VG bkp100vg 2.58t 0 free {zWgmjF-zYiv-X9fp-0XCU-RFIf-kT8E-7bropr}
      :dm-0 2.58t [253:0] LV bkp100lv ext4 
{709a00ef-9306-4617-b464-4f30a4790f60}
       :Mounted as /dev/mapper/bkp100vg-bkp100lv @ /mnt/bkp


Other Block Devices
-loop0 0.00k [7:0] Empty/Unknown
-loop1 0.00k [7:1] Empty/Unknown
-loop2 0.00k [7:2] Empty/Unknown
-loop3 0.00k [7:3] Empty/Unknown
-loop4 0.00k [7:4] Empty/Unknown
-loop5 0.00k [7:5] Empty/Unknown
-loop6 0.00k [7:6] Empty/Unknown
-loop7 0.00k [7:7] Empty/Unknown
root@D7bak:/home/user#

