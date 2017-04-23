From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 14:15:45 +0200
Message-ID: <e4c2acc6-420a-e454-fe74-c82737a1bbf0@powerlamerz.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
 <20170423104606.GA4603@metamorpher.de>
 <754209bb-9990-2a36-2233-d7d1273c8e37@powerlamerz.org>
 <58FC91B8.5090603@youngman.org.uk> <20170423165810.75b5836e@natsu>
 <58FC99ED.7080705@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58FC99ED.7080705@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Roman Mamedov <rm@romanrm.net>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/23/2017 02:11 PM, Wols Lists wrote:
> On 23/04/17 12:58, Roman Mamedov wrote:
>> On Sun, 23 Apr 2017 12:36:24 +0100
>> Wols Lists <antlists@youngman.org.uk> wrote:
>>
>>> And, as the raid wiki tells you, download lspci and run that
>>
>> Maybe you meant lsdrv. https://github.com/pturmel/lsdrv
>>
> Sorry, yes I did ... (too many ls_xxx commands :-)
Ok, I had to patch lsdrv a bit to make it run. Diff:
diff --git a/lsdrv b/lsdrv
index fe6e77d..e868dbc 100755
--- a/lsdrv
+++ b/lsdrv
@@ -386,7 +386,8 @@ def probe_block(blocklink):
 				peers = " (w/ %s)" % ",".join(peers)
 			else:
 				peers = ""
-			blk.FS = "MD %s (%s/%s)%s %s" % (blk.array.md.LEVEL, blk.slave.slot, blk.array.md.raid_disks, peers, blk.slave.state)
+			if blk.array.md:
+				blk.FS = "MD %s (%s/%s)%s %s" % (blk.array.md.LEVEL, blk.slave.slot, blk.array.md.raid_disks, peers, blk.slave.state)
 		else:
 			blk.__dict__.update(extractvars(runx(['mdadm', '--export', '--examine', '/dev/block/'+blk.dev])))
 			blk.FS = "MD %s (%s) inactive" % (blk.MD_LEVEL, blk.MD_DEVICES)
@@ -402,9 +403,11 @@ def probe_block(blocklink):
 	else:
 		blk.FS = "Empty/Unknown"
 	if blk.ID_FS_LABEL:
-		blk.FS += " '%s'" % blk.ID_FS_LABEL
+		if blk.FS:
+			blk.FS += " '%s'" % blk.ID_FS_LABEL
 	if blk.ID_FS_UUID:
-		blk.FS += " {%s}" % blk.ID_FS_UUID
+		if blk.FS:
+			blk.FS += " {%s}" % blk.ID_FS_UUID
 	for part in blk.partitions:
 		probe_block(blkpath+'/'+part)
 	return blk

Here's the output of a run. Overlays are enabled:
PCI [ahci] 00:17.0 SATA controller: Intel Corporation Sunrise Point-H SATA controller [AHCI mode] (rev 31)
├scsi 0:0:0:0 ATA      WDC WD60EFRX-68M {WD-WX91D6535N7Y}
│└sda 5.46t [8:0] None
│ └dm-2 5.46t [252:2] MD raid5 (6) inactive 'rack-server-1:1' {510d9668-d30c-b4cd-cc76-9fcace98c3b1}
├scsi 1:0:0:0 ATA      WDC WD600PF4PZ-4 {WD-WX11D741AE8K}
│└sdb 5.64t [8:16] None
│ └dm-5 5.64t [252:5] MD raid5 (6) inactive 'rack-server-1:1' {510d9668-d30c-b4cd-cc76-9fcace98c3b1}
├scsi 2:0:0:0 ATA      WDC WD60EFRX-68M {WD-WX11DC449Y02}
│└sdc 5.46t [8:32] None
│ └dm-1 5.46t [252:1] MD raid5 (6) inactive 'rack-server-1:1' {510d9668-d30c-b4cd-cc76-9fcace98c3b1}
├scsi 3:0:0:0 ATA      WDC WD60EFRX-68L {WD-WX11DA53427A}
│└sdd 5.46t [8:48] None
│ └dm-3 5.46t [252:3] MD raid5 (6) inactive 'rack-server-1:1' {510d9668-d30c-b4cd-cc76-9fcace98c3b1}
├scsi 4:0:0:0 ATA      WDC WD60EFRX-68L {WD-WXB1HB4W238J}
│└sde 5.46t [8:64] None
│ └dm-4 5.46t [252:4] MD raid5 (6) inactive 'rack-server-1:1' {510d9668-d30c-b4cd-cc76-9fcace98c3b1}
└scsi 5:0:0:0 ATA      WDC WD60EFRX-68L {WD-WX41D75LN7CK}
 └sdf 5.46t [8:80] None
  └dm-6 5.46t [252:6] MD raid5 (6) inactive 'rack-server-1:1' {18cd5b54-707a-36df-36be-8f01e8a77122}
USB [usb-storage] Bus 001 Device 003: ID 152d:2338 JMicron Technology Corp. / JMicron USA Technology Corp. JM20337 Hi-Speed USB to SATA & PATA Combo Bridge {77C301992933}
└scsi 6:0:0:0 WDC WD20  WD-WMC301992933 {WD-WMC301992933}
 └sdg 1.82t [8:96] Partitioned (dos)
  ├sdg1 1.80t [8:97] ext4 {eb94342f-2eea-4318-9f79-3517ae1ccaad}
  │└Mounted as /dev/sdg1 @ /
  ├sdg2 1.00k [8:98] Partitioned (dos)
  └sdg5 15.93g [8:101] swap {568ea822-2f0c-42a8-a355-1a2e856728a0}
   └dm-0 15.93g [252:0] swap {fac64c73-bb78-417d-9323-a5dd381178bf}
USB [usb-storage] Bus 001 Device 006: ID 0781:5567 SanDisk Corp. Cruzer Blade {2005224340054080F2CD}
└scsi 9:0:0:0 SanDisk  Cruzer Blade     {2005224340054080F2CD}
 └sdh 3.73g [8:112] Partitioned (dos)
  └sdh1 3.73g [8:113] vfat {6E17-F675}
   └Mounted as /dev/sdh1 @ /media/cdrom
Other Block Devices
├loop0 5.86t [7:0] DM_snapshot_cow
│└dm-4 5.46t [252:4] MD raid5 (6) inactive 'rack-server-1:1' {510d9668-d30c-b4cd-cc76-9fcace98c3b1}
├loop1 5.86t [7:1] DM_snapshot_cow
│└dm-1 5.46t [252:1] MD raid5 (6) inactive 'rack-server-1:1' {510d9668-d30c-b4cd-cc76-9fcace98c3b1}
├loop2 5.86t [7:2] Empty/Unknown
│└dm-2 5.46t [252:2] MD raid5 (6) inactive 'rack-server-1:1' {510d9668-d30c-b4cd-cc76-9fcace98c3b1}
├loop3 5.86t [7:3] DM_snapshot_cow
│└dm-3 5.46t [252:3] MD raid5 (6) inactive 'rack-server-1:1' {510d9668-d30c-b4cd-cc76-9fcace98c3b1}
├loop4 5.86t [7:4] DM_snapshot_cow
│└dm-5 5.64t [252:5] MD raid5 (6) inactive 'rack-server-1:1' {510d9668-d30c-b4cd-cc76-9fcace98c3b1}
├loop5 5.86t [7:5] DM_snapshot_cow
│└dm-6 5.46t [252:6] MD raid5 (6) inactive 'rack-server-1:1' {18cd5b54-707a-36df-36be-8f01e8a77122}
├loop6 0.00k [7:6] Empty/Unknown
└loop7 0.00k [7:7] Empty/Unknown

Please note that the superblocks have probably been trashed by Permute arrays

> 
> Cheers,
> Wol
> 
