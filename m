From: Phil Turmel <philip@turmel.org>
Subject: Re: Please Help! RAID5 -> 6 reshapre gone bad
Date: Mon, 06 Feb 2012 21:57:23 -0500
Message-ID: <4F309313.2070406@turmel.org>
References: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com> <4F30893F.4000709@turmel.org> <CAOANJV955ZdLexRTjVkQzTMapAaMitq5eqxP0rUvDjjLh4Wgzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOANJV955ZdLexRTjVkQzTMapAaMitq5eqxP0rUvDjjLh4Wgzw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Herd <2001oddity@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Richard,

[restored CC list...  please use reply-to-all on kernel.org lists]

On 02/06/2012 09:40 PM, Richard Herd wrote:
> Hi Phil,
> 
> Thanks for the swift response :-)  Also I'm in (what I'd like to say
> but can't - sunny) Sydney...
> 
> OK, without slathering this thread is smart reports I can quite
> definitely say you are exactly nail-on-the-head with regard to the
> read errors escalating into link timeouts.  This is exactly what is
> happening.  I had thought this was actually a pretty common setup for
> home users (eg mdadm and drives such as WD20EARS/ST2000s) - I have the
> luxury of budgets for Netapp kit at work - unfortunately my personal
> finances only stretch to an ITX case and a bunch of cheap HDs!

I understand the constraints, as I pinch pennies at home and at the
office (I own my engineering firm).  I've made do with cheap desktop
drives that do support ERC.  I got burned when Seagate dropped ERC on
their latest desktop drives.  Hitachi Deskstar is the only affordable
model on the market that still support ERC.

> I understand it's the ERC causing disks to get kicked, and fully
> understand if you can't help further.

Not that I won't help, as there's no risk to me :-)

> Assembling without sdg I'm not sure will do it, as what we have is 4
> disks with the same events counter (3 active sync (sda/sdb/sdf), 1
> spare rebuilding (sdd)), and 2 (sdg/sdc) removed with older event
> counters.  Leaving out sdg leaves us with sdc which has an event
> counter of 1848333.  As the 3 active sync (sda/sdb/sdf) + 1 spare
> (sdd) have an event counter of 1848341, mdadm doesn't want to let me
> use sdc in the array even with --force.

This surprises me.  The purpose of "--force" with assemble is to
ignore the event count.  Have you tried this with the newer mdadm
you compiled?

> As you say as it's in the middle of a reshape so a recreate is out.
> 
> I'm considering data loss is a given at this point, but even being
> able to bring the array online degraded and pull out whatever is still
> intact would help.
> 
> If you have any further suggestions that would be great, but I do
> understand your position on ERC and thank you for your input :-)

Please do retry the --assemble --force with /dev/sdg left out?

I'll leave the balance of your response untrimmed for the list to see.

Phil


> Feb  7 01:07:16 raven kernel: [18891.989330] ata8: hard resetting link
> Feb  7 01:07:22 raven kernel: [18897.356104] ata8: link is slow to
> respond, please be patient (ready=0)
> Feb  7 01:07:26 raven kernel: [18902.004280] ata8: hard resetting link
> Feb  7 01:07:32 raven kernel: [18907.372104] ata8: link is slow to
> respond, please be patient (ready=0)
> Feb  7 01:07:36 raven kernel: [18912.020097] ata8: SATA link up 6.0
> Gbps (SStatus 133 SControl 300)
> Feb  7 01:07:41 raven kernel: [18917.020093] ata8.00: qc timeout (cmd 0xec)
> Feb  7 01:07:41 raven kernel: [18917.028074] ata8.00: failed to
> IDENTIFY (I/O error, err_mask=0x4)
> Feb  7 01:07:41 raven kernel: [18917.028310] ata8: hard resetting link
> Feb  7 01:07:47 raven kernel: [18922.396089] ata8: link is slow to
> respond, please be patient (ready=0)
> Feb  7 01:07:51 raven kernel: [18927.044313] ata8: hard resetting link
> Feb  7 01:07:56 raven kernel: [18932.020099] ata8: SATA link up 6.0
> Gbps (SStatus 133 SControl 300)
> Feb  7 01:08:06 raven kernel: [18942.020048] ata8.00: qc timeout (cmd 0xec)
> Feb  7 01:08:06 raven kernel: [18942.028075] ata8.00: failed to
> IDENTIFY (I/O error, err_mask=0x4)
> Feb  7 01:08:06 raven kernel: [18942.028307] ata8: limiting SATA link
> speed to 3.0 Gbps
> Feb  7 01:08:06 raven kernel: [18942.028321] ata8: hard resetting link
> Feb  7 01:08:12 raven kernel: [18947.396108] ata8: link is slow to
> respond, please be patient (ready=0)
> Feb  7 01:08:16 raven kernel: [18951.988069] ata8: SATA link up 6.0
> Gbps (SStatus 133 SControl 320)
> Feb  7 01:08:46 raven kernel: [18981.988104] ata8.00: qc timeout (cmd 0xec)
> Feb  7 01:08:46 raven kernel: [18981.996070] ata8.00: failed to
> IDENTIFY (I/O error, err_mask=0x4)
> Feb  7 01:08:46 raven kernel: [18981.996302] ata8.00: disabled
> Feb  7 01:08:46 raven kernel: [18981.996324] ata8.00: device reported
> invalid CHS sector 0
> Feb  7 01:08:46 raven kernel: [18981.996348] ata8: hard resetting link
> Feb  7 01:08:52 raven kernel: [18987.364104] ata8: link is slow to
> respond, please be patient (ready=0)
> Feb  7 01:08:56 raven kernel: [18992.012050] ata8: SATA link up 6.0
> Gbps (SStatus 133 SControl 320)
> Feb  7 01:08:56 raven kernel: [18992.012114] ata8: EH complete
> Feb  7 01:08:56 raven kernel: [18992.012158] sd 8:0:0:0: [sdg]
> Unhandled error code
> Feb  7 01:08:56 raven kernel: [18992.012165] sd 8:0:0:0: [sdg] Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> Feb  7 01:08:56 raven kernel: [18992.012176] sd 8:0:0:0: [sdg] CDB:
> Write(10): 2a 00 e8 e0 74 3f 00 00 08 00
> Feb  7 01:08:56 raven kernel: [18992.012696] md: super_written gets
> error=-5, uptodate=0
> Feb  7 01:08:56 raven kernel: [18992.013169] sd 8:0:0:0: [sdg]
> Unhandled error code
> Feb  7 01:08:56 raven kernel: [18992.013176] sd 8:0:0:0: [sdg] Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> Feb  7 01:08:56 raven kernel: [18992.013186] sd 8:0:0:0: [sdg] CDB:
> Read(10): 28 00 04 9d bd bf 00 00 80 00
> Feb  7 01:08:56 raven kernel: [18992.276986] sd 8:0:0:0: [sdg]
> Unhandled error code
> Feb  7 01:08:56 raven kernel: [18992.276999] sd 8:0:0:0: [sdg] Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> Feb  7 01:08:56 raven kernel: [18992.277012] sd 8:0:0:0: [sdg] CDB:
> Read(10): 28 00 04 9d be 3f 00 00 80 00
> Feb  7 01:08:56 raven kernel: [18992.316919] sd 8:0:0:0: [sdg]
> Unhandled error code
> Feb  7 01:08:56 raven kernel: [18992.316930] sd 8:0:0:0: [sdg] Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> Feb  7 01:08:56 raven kernel: [18992.316942] sd 8:0:0:0: [sdg] CDB:
> Read(10): 28 00 04 9d be bf 00 00 80 00
> Feb  7 01:08:56 raven kernel: [18992.326906] sd 8:0:0:0: [sdg]
> Unhandled error code
> Feb  7 01:08:56 raven kernel: [18992.326920] sd 8:0:0:0: [sdg] Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> Feb  7 01:08:56 raven kernel: [18992.326932] sd 8:0:0:0: [sdg] CDB:
> Read(10): 28 00 04 9d bf 3f 00 00 80 00
> Feb  7 01:08:56 raven kernel: [18992.327944] sd 8:0:0:0: [sdg]
> Unhandled error code
> Feb  7 01:08:56 raven kernel: [18992.327956] sd 8:0:0:0: [sdg] Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> Feb  7 01:08:56 raven kernel: [18992.327968] sd 8:0:0:0: [sdg] CDB:
> Read(10): 28 00 04 9d bf bf 00 00 80 00
> Feb  7 01:08:57 raven kernel: [18992.555093] md: md0: reshape done.
> Feb  7 01:08:57 raven kernel: [18992.607595] md: reshape of RAID array md0
> Feb  7 01:08:57 raven kernel: [18992.607606] md: minimum _guaranteed_
> speed: 200000 KB/sec/disk.
> Feb  7 01:08:57 raven kernel: [18992.607614] md: using maximum
> available idle IO bandwidth (but not more than 200000 KB/sec) for
> reshape.
> Feb  7 01:08:57 raven kernel: [18992.607628] md: using 128k window,
> over a total of 1953511936 blocks.
> Feb  7 06:41:02 raven rsyslogd: [origin software="rsyslogd"
> swVersion="4.2.0" x-pid="911" x-info="http://www.rsyslog.com"]
> rsyslogd was HUPed, type 'lightweight'.
> Feb  7 07:12:32 raven kernel: [40807.989092] ata5: hard resetting link
> Feb  7 07:12:38 raven kernel: [40813.524074] ata5: SATA link up 6.0
> Gbps (SStatus 133 SControl 300)
> Feb  7 07:12:43 raven kernel: [40818.524106] ata5.00: qc timeout (cmd 0xec)
> Feb  7 07:12:43 raven kernel: [40818.524126] ata5.00: failed to
> IDENTIFY (I/O error, err_mask=0x4)
> Feb  7 07:12:43 raven kernel: [40818.532788] ata5: hard resetting link
> Feb  7 07:12:48 raven kernel: [40824.058039] ata5: SATA link up 6.0
> Gbps (SStatus 133 SControl 300)
> Feb  7 07:12:58 raven kernel: [40834.056101] ata5.00: qc timeout (cmd 0xec)
> Feb  7 07:12:58 raven kernel: [40834.056121] ata5.00: failed to
> IDENTIFY (I/O error, err_mask=0x4)
> Feb  7 07:12:58 raven kernel: [40834.064203] ata5: limiting SATA link
> speed to 3.0 Gbps
> Feb  7 07:12:58 raven kernel: [40834.064217] ata5: hard resetting link
> Feb  7 07:13:04 raven kernel: [40839.592095] ata5: SATA link up 3.0
> Gbps (SStatus 123 SControl 320)
> Feb  7 07:13:34 raven kernel: [40869.592088] ata5.00: qc timeout (cmd 0xec)
> Feb  7 07:13:34 raven kernel: [40869.592110] ata5.00: failed to
> IDENTIFY (I/O error, err_mask=0x4)
> Feb  7 07:13:34 raven kernel: [40869.599676] ata5.00: disabled
> Feb  7 07:13:34 raven kernel: [40869.599700] ata5.00: device reported
> invalid CHS sector 0
> Feb  7 07:13:34 raven kernel: [40869.599724] ata5: hard resetting link
> Feb  7 07:13:39 raven kernel: [40875.124128] ata5: SATA link up 3.0
> Gbps (SStatus 123 SControl 320)
> Feb  7 07:13:39 raven kernel: [40875.124201] ata5: EH complete
> Feb  7 07:13:39 raven kernel: [40875.124243] sd 4:0:0:0: [sdd]
> Unhandled error code
> Feb  7 07:13:39 raven kernel: [40875.124251] sd 4:0:0:0: [sdd] Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> Feb  7 07:13:39 raven kernel: [40875.124262] sd 4:0:0:0: [sdd] CDB:
> Write(10): 2a 00 e8 e0 74 3f 00 00 08 00
> Feb  7 07:13:39 raven kernel: [40875.135544] md: super_written gets
> error=-5, uptodate=0
> Feb  7 07:13:39 raven kernel: [40875.152171] sd 4:0:0:0: [sdd]
> Unhandled error code
> Feb  7 07:13:39 raven kernel: [40875.152179] sd 4:0:0:0: [sdd] Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> Feb  7 07:13:39 raven kernel: [40875.152189] sd 4:0:0:0: [sdd] CDB:
> Read(10): 28 00 09 2b f2 3f 00 00 80 00
> Feb  7 07:13:41 raven kernel: [40876.734504] md: md0: reshape done.
> Feb  7 07:13:41 raven kernel: [40876.736298] lost page write due to
> I/O error on md0
> Feb  7 07:13:41 raven kernel: [40876.743529] lost page write due to
> I/O error on md0
> Feb  7 07:13:41 raven kernel: [40876.750009] lost page write due to
> I/O error on md0
> Feb  7 07:13:41 raven kernel: [40876.755143] lost page write due to
> I/O error on md0
> Feb  7 07:13:41 raven kernel: [40876.760126] lost page write due to
> I/O error on md0
> Feb  7 07:13:41 raven kernel: [40876.765070] lost page write due to
> I/O error on md0
> Feb  7 07:13:41 raven kernel: [40876.769890] lost page write due to
> I/O error on md0
> Feb  7 07:13:41 raven kernel: [40876.774759] lost page write due to
> I/O error on md0
> Feb  7 07:13:41 raven kernel: [40876.779456] lost page write due to
> I/O error on md0
> Feb  7 07:13:41 raven kernel: [40876.784166] lost page write due to
> I/O error on md0
> Feb  7 07:13:41 raven kernel: [40876.788773] JBD: Detected IO errors
> while flushing file data on md0
> Feb  7 07:13:41 raven kernel: [40876.796386] JBD: Detected IO errors
> while flushing file data on md0
> 
> On Tue, Feb 7, 2012 at 1:15 PM, Phil Turmel <philip@turmel.org> wrote:
>> Hi Richard,
>>
>> On 02/06/2012 08:34 PM, Richard Herd wrote:
>>> Hey guys,
>>>
>>> I'm in a bit of a pickle here and if any mdadm kings could step in and
>>> throw some advice my way I'd be very grateful :-)
>>>
>>> Quick bit of background - little NAS based on an AMD E350 running
>>> Ubuntu 10.04. Running a software RAID 5 from 5x2TB disks.  Every few
>>> months one of the drives would fail a request and get kicked from the
>>> array (as is becoming common for these larger multi TB drives they
>>> tolerate the occasional bad sector by reallocating from a pool of
>>> spares (but that's a whole other story)).  This happened across a
>>> variety of brands and two different controllers. I'd simply add the
>>> disk that got popped back in and let it re-sync.  SMART tests always
>>> in good health.
>>
>> Some more detail on the actual devices would help, especially the
>> output of lsdrv [1] to document what device serial numbers are which,
>> for future reference.
>>
>> I also suspect you have problems with your drive's error recovery
>> control, also known as time-limited error recovery.  Simple sector
>> errors should *not* be kicking out your drives.  Mdadm knows to
>> reconstruct from parity and rewrite when a read error is encountered.
>> That either succeeds directly, or causes the drive to remap.
>>
>> You say that the SMART tests are good, so read errors are probably
>> escalating into link timeouts, and the drive ignores the attempt to
>> reconstruct.  *That* kicks the drive out.
>>
>> "smartctl -x" reports for all of your drives would help identify if
>> you have this problem.  You *cannot* safely run raid arrays with drives
>> that don't (or won't) report errors in a timely fashion (a few seconds).
>>
>>> It did make me nervous though.  So I decided I'd add a second disk for
>>> a bit of extra redundancy, making the array a RAID 6 - the thinking
>>> was the occasional disk getting kicked and re-added from a RAID 6
>>> array wouldn't present as much risk as a single disk getting kicked
>>> from a RAID 5.
>>>
>>> So first off, I added the 6th disk as a hotspare to the RAID5 array.
>>> So I now had my 5 disk RAID 5 + hotspare.
>>>
>>> I then found that mdadm 2.6.7 (in the repositories) isn't actually
>>> capable of a 5->6 reshape.  So I pulled the latest 3.2.3 sources and
>>> compiled myself a new version of mdadm.
>>>
>>> With the newer version of mdadm, it was happy to do the reshape - so I
>>> set it off on it's merry way, using an esata HD (mounted at /usb :-P)
>>> for the backupfile:
>>>
>>> root@raven:/# mdadm --grow /dev/md0 --level=6 --raid-devices=6
>>> --backup-file=/usb/md0.backup
>>>
>>> It would take a week to reshape, but it was ona UPS & happily ticking
>>> along.  The array would be online the whole time so I was in no rush.
>>> Content, I went to get some shut-eye.
>>>
>>> I got up this morning and took a quick look in /proc/mdstat to see how
>>> things were going and saw things had failed spectacularly.  At least
>>> two disks had been kicked from the array and the whole thing had
>>> crumbled.
>>
>> Do you still have the dmesg for this?
>>
>>> Ouch.
>>>
>>> I tried to assembe the array, to see if it would continue the reshape:
>>>
>>> root@raven:/# mdadm -Avv --backup-file=/usb/md0.backup /dev/md0
>>> /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sdf1 /dev/sdg1
>>>
>>> Unfortunately mdadm had decided that the backup-file was out of date
>>> (timestamps didn't match) and was erroring with: Failed to restore
>>> critical section for reshape, sorry..
>>>
>>> Chances are things were in such a mess that backup file wasn't going
>>> to be used anyway, so I blocked the timestamp check with: export
>>> MDADM_GROW_ALLOW_OLD=1
>>>
>>> That allowed me to assemble the array, but not run it as there were
>>> not enough disks to start it.
>>>
>>> This is the current state of the array:
>>>
>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>>> [raid4] [raid10]
>>> md0 : inactive sdb1[1] sdd1[5] sdf1[4] sda1[2]
>>>       7814047744 blocks super 0.91
>>>
>>> unused devices: <none>
>>>
>>> root@raven:/# mdadm --detail /dev/md0
>>> /dev/md0:
>>>         Version : 0.91
>>>   Creation Time : Tue Jul 12 23:05:01 2011
>>>      Raid Level : raid6
>>>   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>>>    Raid Devices : 6
>>>   Total Devices : 4
>>> Preferred Minor : 0
>>>     Persistence : Superblock is persistent
>>>
>>>     Update Time : Tue Feb  7 09:32:29 2012
>>>           State : active, FAILED, Not Started
>>>  Active Devices : 3
>>> Working Devices : 4
>>>  Failed Devices : 0
>>>   Spare Devices : 1
>>>
>>>          Layout : left-symmetric-6
>>>      Chunk Size : 64K
>>>
>>>      New Layout : left-symmetric
>>>
>>>            UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 (local to host raven)
>>>          Events : 0.1848341
>>>
>>>     Number   Major   Minor   RaidDevice State
>>>        0       0        0        0      removed
>>>        1       8       17        1      active sync   /dev/sdb1
>>>        2       8        1        2      active sync   /dev/sda1
>>>        3       0        0        3      removed
>>>        4       8       81        4      active sync   /dev/sdf1
>>>        5       8       49        5      spare rebuilding   /dev/sdd1
>>>
>>> The two removed disks:
>>> [ 3020.998529] md: kicking non-fresh sdc1 from array!
>>> [ 3021.012672] md: kicking non-fresh sdg1 from array!
>>>
>>> Attempted to re-add the disks (same for both):
>>> root@raven:/# mdadm /dev/md0 --add /dev/sdg1
>>> mdadm: /dev/sdg1 reports being an active member for /dev/md0, but a
>>> --re-add fails.
>>> mdadm: not performing --add as that would convert /dev/sdg1 in to a spare.
>>> mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdg1" first.
>>>
>>> With a failed array the last thing we want to do is add spares and
>>> trigger a resync so obviously I haven't zeroed the superblocks and
>>> added yet.
>>
>> That would be catastrophic.
>>
>>> Checked and two disks really are out of sync:
>>> root@raven:/# mdadm --examine /dev/sd[a-h]1 | grep Event
>>>          Events : 1848341
>>>          Events : 1848341
>>>          Events : 1848333
>>>          Events : 1848341
>>>          Events : 1848341
>>>          Events : 1772921
>>
>> So /dev/sdg1 dropped out first, and /dev/sdc1 followed and killed the
>> array.
>>
>>> I'll post the output of --examine on all the disks below - if anyone
>>> has any advice I'd really appreciate it (Neil Brown doesn't read these
>>> forums does he?!?).  I would usually move next to recreating the array
>>> and using assume-clean but since it's right in the middle of a reshape
>>> I'm not inclined to try.
>>
>> Neil absolutely reads this mailing list, and is likely to pitch in if
>> I don't offer precisely correct advice :-)
>>
>> He's in an Australian time zone though, so latency might vary.  I'm on the
>> U.S. east coast, fwiw.
>>
>> In any case, with a re-shape in progress, "--create --assume-clean" is
>> not an option.
>>
>>> Critical stuff is of course backed up, but there is some user data not
>>> covered by backups that I'd like to try and restore if at all
>>> possible.
>>
>> Hope is not all lost.  If we can get your ERC adjusted, the next step
>> would be to disconnect /dev/sdg from the system, and assemble with
>> --force and MDADM_GROW_ALLOW_OLD=1
>>
>> That'll let the reshape finish, leaving you with a single-degraded
>> raid6.  Then you fsck and make critical backups.  Then you --zero- and
>> --add /dev/sdg.
>>
>> If your drives don't support ERC, I can't recommend you continue until
>> you've ddrescue'd your drives onto new ones that do support ERC.
>>
>> HTH,
>>
>> Phil
>>
>> [1] http://github.com/pturmel/lsdrv

