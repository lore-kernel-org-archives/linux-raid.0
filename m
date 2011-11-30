From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: mdadm 3.2.2: Behavioral change when adding back a previously
 faulted device
Date: Wed, 30 Nov 2011 15:21:38 +0000
Message-ID: <4ED64A02.6030506@anonymous.org.uk>
References: <201111301556.59323.ms@teamix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201111301556.59323.ms@teamix.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Stefan Becker <sbe@teamix.de>
List-Id: linux-raid.ids

On 30/11/2011 14:56, Martin Steigerwald wrote:
> Hi Neil, hi Linux SoftRAID developers and users,
>
> On preparing best practice / sample solution for some SoftRAID related
> exercises in one of our Linux courses I came about a behavorial change in
> mdadm that puzzled me. I use Linux 3.1.0 debian package.
>
> I create a softraid 1 on logical volumes located on different SATA disks:
>
> mdadm --create --level 1 --raid-devices 2 /dev/md3 /dev/mango1/raidtest
> /dev/mango2/raidtest
>
> I let it sync and then set one disk faulty:
>
> mdadm --manage --set-faulty /dev/md3 /dev/mango2/raidtest
>
> mango:~# head -3 /proc/mdstat
> Personalities : [raid1]
> md3 : active raid1 dm-7[1](F) dm-6[0]
>        52427704 blocks super 1.2 [2/1] [U_]
>
>
> Then I removed it:
>
> mdadm /dev/md3 --remove failed
>
> mango:~# head -3 /proc/mdstat
> Personalities : [raid1]
> md3 : active raid1 dm-6[0]
>        52427704 blocks super 1.2 [2/1] [U_]
>
>
> And then I tried adding it again with:
>
> mango:~# mdadm -vv /dev/md3 --add /dev/mango2/raidtest
> mdadm: /dev/mango2/raidtest reports being an active member for /dev/md3, but a
> --re-add fails.
> mdadm: not performing --add as that would convert /dev/mango2/raidtest in to a
> spare.
> mdadm: To make this a spare, use "mdadm --zero-superblock
> /dev/mango2/raidtest" first.
>
>
> This is how it works with mdadm upto 3.1.4 at least and how I know it. That
> said, considered that re-adding the device failed the error message makes some
> sense to me.
>
>
> I tried explicitely to re-add it:
>
> mango:~# mdadm -vv /dev/md3 --re-add /dev/mango2/raidtest
> mdadm: --re-add for /dev/mango2/raidtest to /dev/md3 is not possible
>
> Here mdadm fails to mention on why it is not able to re-add the device.
>
>
> Here is what I find on syslog:
>
> mango:~# tail -15 /var/log/syslog
> Nov 30 15:50:06 mango kernel: [11146.968265] md/raid1:md3: Disk failure on
> dm-3, disabling device.
> Nov 30 15:50:06 mango kernel: [11146.968268] md/raid1:md3: Operation
> continuing on 1 devices.
> Nov 30 15:50:06 mango kernel: [11146.996597] RAID1 conf printout:
> Nov 30 15:50:06 mango kernel: [11146.996603]  --- wd:1 rd:2
> Nov 30 15:50:06 mango kernel: [11146.996608]  disk 0, wo:0, o:1, dev:dm-6
> Nov 30 15:50:06 mango kernel: [11146.996612]  disk 1, wo:1, o:0, dev:dm-3
> Nov 30 15:50:06 mango kernel: [11147.020032] RAID1 conf printout:
> Nov 30 15:50:06 mango kernel: [11147.020037]  --- wd:1 rd:2
> Nov 30 15:50:06 mango kernel: [11147.020042]  disk 0, wo:0, o:1, dev:dm-6
> Nov 30 15:50:11 mango kernel: [11151.631376] md: unbind<dm-3>
> Nov 30 15:50:11 mango kernel: [11151.644064] md: export_rdev(dm-3)
> Nov 30 15:50:17 mango kernel: [11157.787979] md: export_rdev(dm-3)
> Nov 30 15:50:22 mango kernel: [11162.531139] md: export_rdev(dm-3)
> Nov 30 15:50:25 mango kernel: [11165.883082] md: export_rdev(dm-3)
> Nov 30 15:51:04 mango kernel: [11204.723241] md: export_rdev(dm-3)
>
>
> We tried tried it with metadata 0.90 but had the same behavior. Then we tried
> after downgrading mdadm to 3.1.4 and then mdadm --add just added the device as
> spare initially and then SoftRAID used it for recovery after it found that it
> needed another disk to make a RAID complete.
>
> What works with mdadm 3.2.2 is to --zero-superblock the device and then --add
> it. Is that the recommended way to re-adding a device previously marked as
> faulty?
>
>
> I bet the observed behavior might be party due to
>
> commit d6508f0cfb60edf07b36f1532eae4d9cddf7178b
> Author: NeilBrown<neilb@suse.de>
> Date:   Mon Nov 22 19:35:25 2010 +1100
>
>      Manage:  be more careful about --add attempts.
>
>      If an --add is requested and a re-add looks promising but fails or
>      cannot possibly succeed, then don't try the add.  This avoids
>      inadvertently turning devices into spares when an array is failed but
>      the devices seem to actually work.
>
>      Signed-off-by: NeilBrown<neilb@suse.de>
>
> which I also found as commit 8453e704305b92f043e436d6f90a0c5f068b09eb in git
> log. But this doesn't explain why readding the device fails. Since the device
> was previously in this RAID array, should mdadm just be able to re-add it?
>
>
> Now is not being able to --re-add the device a (security) feature or bug?
>
> I understand that it might not be common to re-add a device previously marked
> as faulty, but aside from being useful in an exercise it can be useful if
> someone marked the wrong device as faulty accidentally.
>
> Please advice.

This is deliberate to stop people overwriting discs they want to recover 
data from, when they said --add where they should have used --re-add.

Reasons for --re-add to fail include the array you're re-adding to 
having been updated since the drive you're re-adding was set faulty. 
Arrays with a write intent bitmap can have devices re-added even if the 
array has been updated in the mean time and only the updates are 
applied, but without the write intent bitmap the whole disc needs to be 
resync'ed, which is what an --add would do, and is why mdadm is now more 
cautious.

I think I've got this right and I hope it helps!

Cheers,

John.

