From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: How best to re-sync raid1 array? zero superblock on removed disk
 and let it rebuild?
Date: Fri, 28 Aug 2015 08:16:15 -0500
Message-ID: <55E05F1F.4090202@suddenlinkmail.com>
References: <55E02841.9050701@suddenlinkmail.com> <20150828095250.GA2602@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150828095250.GA2602@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/28/2015 04:52 AM, Robin Hill wrote:
> On Fri Aug 28, 2015 at 04:22:09am -0500, David C. Rankin wrote:
>
>> Reading, it looks like one approach is the boot the install media and
>> then zero the superblock on /dev/sda7 and then reboot. Will that force
>> a rebuild, or do I need to fail and remove the disk first? I was thinking:
>>
>> # mdadm --zero-superblock /dev/sda7
>>
>> should set it up for a rebuild without more. Is this a sane approach?
>>
> No need to over-complicate things. The only issue you have looks to be
> that sda7 has not come up as part of md1, so just add it back in:
>      mdadm /dev/md1 -a /dev/sda7
>
> You probably want to check dmesg, etc. to see why it didn't get added in
> at all in the first place (I'd have expected it to be at least in as a
> spare).
>
> Cheers,
>      Robin
>

Hah!

   You guys are great!

[07:57 phoinix:.../david/dev] #  mdadm /dev/md1 -a /dev/sda7
mdadm: added /dev/sda7
[07:58 phoinix:.../david/dev] # cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sda7[2] sdb7[1]
       52396032 blocks super 1.2 [2/1] [_U]
       [=>...................]  recovery =  6.1% (3246848/52396032) 
finish=9.7min speed=83527K/sec

   I have no clue what happened? I have never seen this before. There was never 
an attempt to md: bind<sda7> (just like it didn't exist). The only thing 
different about this boot (aside from the new highpoint raid controller) was the 
fact I left the Arch install CD in the CD/DVD drive. I don't know if in the 
early boot process, prior to the handoff to the highpoint controller, it somehow 
may have grabbed sda?? (the CD drive is still on the onboard ATA controller, 
while all SATA drives are attached to the highpoint controller).

   Let me know if you see anything that makes any more sense?

   And... during the time it took to compose this reply:

Personalities : [raid1]
md1 : active raid1 sda7[2] sdb7[1]
       52396032 blocks super 1.2 [2/2] [UU]

md3 : active raid1 sdb6[1] sda6[0]
       1047552 blocks super 1.2 [2/2] [UU]

md2 : active raid1 sda8[0] sdb8[1]
       922944192 blocks super 1.2 [2/2] [UU]
       bitmap: 0/7 pages [0KB], 65536KB chunk

md0 : active raid1 sda5[0] sdb5[1]
       204608 blocks super 1.2 [2/2] [UU]

unused devices: <none>

   Whoop!

   I've gathered the relevant dmesg output. Maybe you can help make sense out of 
it. It just looks like the system never tried to activate sda7...

[    3.261932] sd 3:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 
TB/931 GiB)
[    3.261948] sd 2:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 
TB/931 GiB)
[    3.261988] sd 2:0:0:0: [sda] Write Protect is off
[    3.261990] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.262010] sd 3:0:0:0: [sdb] Write Protect is off
[    3.262012] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.262018] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.262034] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.298037]  sda: sda1 < sda5 sda6 sda7 sda8 >
[    3.298469] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.317052]  sdb: sdb1 < sdb5 sdb6 sdb7 sdb8 >
[    3.317456] sd 3:0:0:0: [sdb] Attached SCSI disk
[    3.420533] md: bind<sdb5>
[    3.421641] md: bind<sdb8>
[    3.423385] md: bind<sda8>
[    3.425987] md: raid1 personality registered for level 1
[    3.426035] md: bind<sda5>
[    3.426204] md/raid1:md2: active with 2 out of 2 mirrors
[    3.426322] created bitmap (7 pages) for device md2
[    3.426614] md2: bitmap initialized from disk: read 1 pages, set 0 of 14084 bits
[    3.427474] md/raid1:md0: active with 2 out of 2 mirrors
[    3.427496] md0: detected capacity change from 0 to 209518592
[    3.469789]  md0: unknown partition table
[    3.543932] md2: detected capacity change from 0 to 945094852608
[    3.544373] md: bind<sda6>
[    3.545918] md: bind<sdb6>
[    3.546646]  md2: unknown partition table
[    3.547402] md/raid1:md3: active with 2 out of 2 mirrors
[    3.547428] md3: detected capacity change from 0 to 1072693248
[    3.547986] md: bind<sdb7>
[    3.549323] md/raid1:md1: active with 1 out of 2 mirrors
[    3.549348] md1: detected capacity change from 0 to 53653536768
[    3.558920]  md3: unknown partition table
[    3.559052]  md1: unknown partition table
[    4.345217]  md1: unknown partition table
[    4.371798] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: 
(null)
<snip>
[    6.020249] EXT4-fs (md1): re-mounted. Opts: stripe=32,data=ordered
[    6.020965] systemd[1]: Started Remount Root and Kernel File Systems.
<snip>
[   10.110516]  md0: unknown partition table
[   10.480935]  md2: unknown partition table
[   10.531124] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: 
stripe=32,data=ordered
[   10.573132] EXT4-fs (md2): mounted filesystem with ordered data mode. Opts: 
stripe=32,data=ordered
<snip>
[223796.599863] md: export_rdev(sda7)
[223796.658203] md: bind<sda7>
[223796.719104]  disk 0, wo:1, o:1, dev:sda7
[223796.719108]  disk 1, wo:0, o:1, dev:sdb7
[223796.719155] md: recovery of RAID array md1
[223796.719156] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[223796.719158] md: using maximum available idle IO bandwidth (but not more than 
200000 KB/sec) for recovery.
[223796.719161] md: using 128k window, over a total of 52396032k.


-- 
David C. Rankin, J.D.,P.E.
