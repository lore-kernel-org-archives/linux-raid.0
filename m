From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 Recovery
Date: Wed, 14 Nov 2007 10:58:34 +0000
Message-ID: <473AD4DA.7060801@dgreaves.com>
References: <f0d815c0711131705s17f365b4kc122db98e8e27895@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f0d815c0711131705s17f365b4kc122db98e8e27895@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Cavan <neilcavan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Cavan wrote:
> Hello,
Hi Neil

What kernel version?
What mdadm version?

> This morning, I woke up to find the array had kicked two disks. This
> time, though, /proc/mdstat showed one of the failed disks (U_U_U, one
> of the "_"s) had been marked as a spare - weird, since there are no
> spare drives in this array. I rebooted, and the array came back in the
> same state: one failed, one spare. I hot-removed and hot-added the
> spare drive, which put the array back to where I thought it should be
> ( still U_U_U, but with both "_"s marked as failed). Then I rebooted,
> and the array began rebuilding on its own. Usually I have to hot-add
> manually, so that struck me as a little odd, but I gave it no mind and
> went to work. Without checking the contents of the filesystem. Which
> turned out not to have been mounted on reboot.
OK

> Because apparently things went horribly wrong.
Yep :(

> Do I have any hope of recovering this data? Could rebuilding the
> reiserfs superblock help if the rebuild managed to corrupt the
> superblock but not the data?
See below



> Nov 13 02:01:03 localhost kernel: [17805772.424000] hdc: dma_intr:
> status=0x51 { DriveReady SeekComplete Error }
<snip>
> Nov 13 02:01:06 localhost kernel: [17805775.156000] lost page write
> due to I/O error on md0
hdc1 fails


> Nov 13 02:01:06 localhost kernel: [17805775.196000] RAID5 conf printout:
> Nov 13 02:01:06 localhost kernel: [17805775.196000]  --- rd:5 wd:3 fd:2
> Nov 13 02:01:06 localhost kernel: [17805775.196000]  disk 0, o:1, dev:hda1
> Nov 13 02:01:06 localhost kernel: [17805775.196000]  disk 1, o:0, dev:hdc1
> Nov 13 02:01:06 localhost kernel: [17805775.196000]  disk 2, o:1, dev:hde1
> Nov 13 02:01:06 localhost kernel: [17805775.196000]  disk 4, o:1, dev:hdi1

hdg1 is already missing?

> Nov 13 02:01:06 localhost kernel: [17805775.212000] RAID5 conf printout:
> Nov 13 02:01:06 localhost kernel: [17805775.212000]  --- rd:5 wd:3 fd:2
> Nov 13 02:01:06 localhost kernel: [17805775.212000]  disk 0, o:1, dev:hda1
> Nov 13 02:01:06 localhost kernel: [17805775.212000]  disk 2, o:1, dev:hde1
> Nov 13 02:01:06 localhost kernel: [17805775.212000]  disk 4, o:1, dev:hdi1

so now the array is bad.

a reboot happens and:
> Nov 13 07:21:07 localhost kernel: [17179584.712000] md: md0 stopped.
> Nov 13 07:21:07 localhost kernel: [17179584.876000] md: bind<hdc1>
> Nov 13 07:21:07 localhost kernel: [17179584.884000] md: bind<hde1>
> Nov 13 07:21:07 localhost kernel: [17179584.884000] md: bind<hdg1>
> Nov 13 07:21:07 localhost kernel: [17179584.884000] md: bind<hdi1>
> Nov 13 07:21:07 localhost kernel: [17179584.892000] md: bind<hda1>
> Nov 13 07:21:07 localhost kernel: [17179584.892000] md: kicking
> non-fresh hdg1 from array!
> Nov 13 07:21:07 localhost kernel: [17179584.892000] md: unbind<hdg1>
> Nov 13 07:21:07 localhost kernel: [17179584.892000] md: export_rdev(hdg1)
> Nov 13 07:21:07 localhost kernel: [17179584.896000] raid5: allocated
> 5245kB for md0
... apparently hdc1 is OK? Hmmm.

> Nov 13 07:21:07 localhost kernel: [17179665.524000] ReiserFS: md0:
> found reiserfs format "3.6" with standard journal
> Nov 13 07:21:07 localhost kernel: [17179676.136000] ReiserFS: md0:
> using ordered data mode
> Nov 13 07:21:07 localhost kernel: [17179676.164000] ReiserFS: md0:
> journal params: device md0, size 8192, journal first block 18, max
> trans len 1024, max batch 900, max commit age 30, max trans age 30
> Nov 13 07:21:07 localhost kernel: [17179676.164000] ReiserFS: md0:
> checking transaction log (md0)
> Nov 13 07:21:07 localhost kernel: [17179676.828000] ReiserFS: md0:
> replayed 7 transactions in 1 seconds
> Nov 13 07:21:07 localhost kernel: [17179677.012000] ReiserFS: md0:
> Using r5 hash to sort names
> Nov 13 07:21:09 localhost kernel: [17179682.064000] lost page write
> due to I/O error on md0
Reiser tries to mount/replay itself relying on hdc1 (which is partly bad)

> Nov 13 07:25:39 localhost kernel: [17179584.828000] md: raid5
> personality registered as nr 4
> Nov 13 07:25:39 localhost kernel: [17179585.708000] md: kicking
> non-fresh hdg1 from array!
Another reboot...

> Nov 13 07:25:40 localhost kernel: [17179666.064000] ReiserFS: md0:
> found reiserfs format "3.6" with standard journal
> Nov 13 07:25:40 localhost kernel: [17179676.904000] ReiserFS: md0:
> using ordered data mode
> Nov 13 07:25:40 localhost kernel: [17179676.928000] ReiserFS: md0:
> journal params: device md0, size 8192, journal first block 18, max
> trans len 1024, max batch 900, max commit age 30, max trans age 30
> Nov 13 07:25:40 localhost kernel: [17179676.932000] ReiserFS: md0:
> checking transaction log (md0)
> Nov 13 07:25:40 localhost kernel: [17179677.080000] ReiserFS: md0:
> Using r5 hash to sort names
> Nov 13 07:25:42 localhost kernel: [17179683.128000] lost page write
> due to I/O error on md0
Reiser tries again...

> Nov 13 07:26:57 localhost kernel: [17179757.524000] md: unbind<hdc1>
> Nov 13 07:26:57 localhost kernel: [17179757.524000] md: export_rdev(hdc1)
> Nov 13 07:27:03 localhost kernel: [17179763.700000] md: bind<hdc1>
> Nov 13 07:30:24 localhost kernel: [17179584.180000] md: md driver
hdc is kicked too (again)

> Nov 13 07:30:24 localhost kernel: [17179584.184000] md: raid5
> personality registered as nr 4
Another reboot...

> Nov 13 07:30:24 localhost kernel: [17179585.068000] md: syncing RAID array md0
Now (I guess) hdg is being restored using hdc data:

> Nov 13 07:30:24 localhost kernel: [17179684.160000] ReiserFS: md0:
> warning: sh-2021: reiserfs_fill_super: can not find reiserfs on md0
But Reiser is confused.

> Nov 13 08:57:11 localhost kernel: [17184895.816000] md: md0: sync done.
hdg is back up to speed:


So hdc looks faulty.
Your only hope (IMO) is to use reiserfs recovery tools.
You may want to replace hdc to avoid an hdc failure interrupting any rebuild.

I think what happened is that hdg failed prior to 2am and you didn't notice
(mdadm --monitor is your friend). Then hdc had a real failure - at that point
you had data loss (not enough good disks). I don't know why md rebuilt using hdc
- I would expect it to have found hdc and hdg stale. If this is a newish kernel
then maybe Neil should take a look...

David

