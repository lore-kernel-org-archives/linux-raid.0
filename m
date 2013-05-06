From: Sam Bingner <sam@bingner.com>
Subject: Re: Reshape Shrink Hung Again
Date: Mon, 6 May 2013 06:36:29 +0000
Message-ID: <F83D995D-967D-4D89-9CE9-46A0305290C6@bingner.com>
References: <96A49024-A8A7-4ED9-82B1-5AE430374EBE@bingner.com>
 <20130422072414.3e30882c@notabene.brown>
 <7A4C666A-D95E-41AB-96B2-5E75097D8BBB@bingner.com>
 <20130506152926.067d3459@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130506152926.067d3459@notabene.brown>
Content-Language: en-US
Content-ID: <D995A9EC345DEB4F90A97C10CD28FCF4@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On May 5, 2013, at 7:29 PM, NeilBrown <neilb@suse.de> wrote:

> On Wed, 1 May 2013 02:00:30 +0000 Sam Bingner <sam@bingner.com> wrote:
> 
>> On Apr 21, 2013, at 11:24 AM, NeilBrown <neilb@suse.de> wrote:
>> 
>>> On Fri, 19 Apr 2013 08:29:37 +0000 Sam Bingner <sam@bingner.com> wrote:
>>> 
>>>> I'll start this off by saying that no data is in jeopardy, but I would like to track down the cause of this problem and fix it.  I originally thought it must have been due to the incorrect backup-file size with a raid array shrunk to smaller than the final size when it happened to me last time but this time this was not the case.
>>>> 
>>>> I initiated a shrink from a 4-drive RAID5 to a 3-drive RAID5, this shrink had no problems except that a drive failed right at the end of the reshape... then it hung at 99.9% and does not allow me to remove the failed drive from the array because it is "rebuilding".  I am not sure if the drive failed at the end, or if it was after it had gotten to 99.9% because I didn't see this until the next morning as it ran overnight.
>>>> 
>>>> Sam
>>>> 
>>>> root@fs:/var/log# uname -a
>>>> Linux fs 2.6.32-5-686 #1 SMP Mon Jan 16 16:04:25 UTC 2012 i686 GNU/Linux
>>>> 
>>>> Apr 17 22:37:41 fs kernel: [25860779.639762] md1: detected capacity change from 749122093056 to 499414728704
>>>> Apr 17 22:38:40 fs kernel: [25860837.912441] md: reshape of RAID array md1
>>>> Apr 17 22:38:40 fs kernel: [25860837.912447] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>>>> Apr 17 22:38:40 fs kernel: [25860837.912452] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
>>>> Apr 17 22:38:40 fs kernel: [25860837.912459] md: using 128k window, over a total of 243854848 blocks.
>>>> Apr 18 07:51:09 fs kernel: [25893987.273813] raid5: Disk failure on sda2, disabling device.
>>>> Apr 18 07:51:09 fs kernel: [25893987.273815] raid5: Operation continuing on 2 devices.
>>>> Apr 18 07:51:09 fs kernel: [25893987.287168] md: super_written gets error=-5, uptodate=0
>>>> Apr 18 07:51:10 fs kernel: [25893987.657039] md: md1: reshape done.
>>>> Apr 18 07:51:10 fs kernel: [25893987.781599] md: reshape of RAID array md1
>>>> Apr 18 07:51:10 fs kernel: [25893987.781607] md: minimum _guaranteed_  speed: 100 KB/sec/disk.
>>>> Apr 18 07:51:10 fs kernel: [25893987.781613] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
>>>> Apr 18 07:51:10 fs kernel: [25893987.781620] md: using 128k window, over a total of 243854848 blocks.
>>>> 
>>>> 
>>>> md1 : active raid5 sdd2[3] sda2[0](F) sdc2[2] sdb2[4]
>>>>     487709696 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [_UU]
>>>>     [===================>.]  reshape = 99.9% (243853824/243854848) finish=343.6min speed=0K/sec
>>>> 
>>> 
>>> Looks like a bug - probably in mdadm.
>>> mdadm needs to help the reshape over the last little bit, and md is probably
>>> waiting for it to do that.  This will be the only time in the whole process
>>> when the backup file is used.
>>> 
>>> I would try stopping the array and re-assembling it.  That might require a
>>> reboot.  If that doesn't fix it, let me know and I'll prioritise this.
>>> Otherwise - I've put it on my to-do list.  I'll try to reproduce and fix it
>>> in due course.
>>> 
>>> Thanks for the report,
>>> NeilBrown
>> 
>> Sorry for the delay in responding, the server was at a remote location and didn't have a remote console.  My attempt to make an initrd that provided me SSH failed for unknown reasons (it works now that I've got physical access to the server).  Based on the results below, it looks like the drive that did drop out was pretty much at the very end and I really don't think it was related to the error.  I can leave the system in this state and get you access to it to see if you desire.  This system was in the process of being decommissioned and soon after the failure the replacement came in.  This same error happened to me twice, but I also did another reshape where it didn't happen.  I can play with this system and try to duplicate it again also.  As I said, I'll be happy to do anything to h
 elp find the source of this. 
>> 
>> In any case, here is what happened from initramfs:
> 
> Thanks.
> It looks like sda2 (first device in array) failed shortly after Thu Apr 18
> 11:49:51 2013 when there was still 13MB to be reshaped.
> Then the reshape froze with only 2MB to go.  Don't know why yet.
> 
> Could yo retry the assemble command with --verbose added?
> i.e.
>  mdadm.static --assemble /dev/md0 --backup-file=/boot/backup.md --verbose
> 
> The 
>   export MDADM_GROW_ALLOW_OLD=1
> and try again.
> If that doesn't start the array, try adding
>   --invalid-backup
> 
> and report the results.
> 
> Thanks.
> 
> NeilBrown
> 

The backup.md file is all zeroes (and seems to have always been since it only uses it at the end?)  The --invalid-backup option seemed to work, but I guess then the question is why it was expecting valid data if it never put anything there to start with?  It seems to have actually happily backed up the 3MB after being told to accept an invalid backup...

I'm thinking it somehow froze originally trying to restore a backup that it never made?

Sam

# ./mdadm.static --assemble --force --verbose /dev/md1 --backup-file=/boot/backup.md
mdadm: looking for devices for /dev/md1
mdadm: /dev/sdd2 is identified as a member of /dev/md1, slot 3.
mdadm: /dev/sdc2 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sdb2 is identified as a member of /dev/md1, slot 1.
mdadm: /dev/sda2 is identified as a member of /dev/md1, slot 0.
mdadm:/dev/md1 has an active reshape - checking if critical section needs to be restored
mdadm: No backup metadata on /boot/backup.md
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.

# export MDADM_GROW_ALLOW_OLD=1
# ./mdadm.static --assemble --force --verbose /dev/md1 --backup-file=/boot/backup.md 
mdadm: looking for devices for /dev/md1
mdadm: /dev/sdd2 is identified as a member of /dev/md1, slot 3.
mdadm: /dev/sdc2 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sdb2 is identified as a member of /dev/md1, slot 1.
mdadm: /dev/sda2 is identified as a member of /dev/md1, slot 0.
mdadm:/dev/md1 has an active reshape - checking if critical section needs to be restored
mdadm: No backup metadata on /boot/backup.md
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.

# ./mdadm.static --assemble --force --verbose /dev/md1 --backup-file=/boot/backup.md --invalid-backup
mdadm: looking for devices for /dev/md1
mdadm: /dev/sdd2 is identified as a member of /dev/md1, slot 3.
mdadm: /dev/sdc2 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sdb2 is identified as a member of /dev/md1, slot 1.
mdadm: /dev/sda2 is identified as a member of /dev/md1, slot 0.
mdadm:/dev/md1 has an active reshape - checking if critical section needs to be restored
mdadm: No backup metadata on /boot/backup.md
mdadm: Failed to find backup of critical section
mdadm: continuing without restoring backup
mdadm: added /dev/sda2 to /dev/md1 as 0 (possibly out of date)
mdadm: added /dev/sdc2 to /dev/md1 as 2
mdadm: added /dev/sdd2 to /dev/md1 as 3
mdadm: added /dev/sdb2 to /dev/md1 as 1
mdadm: Need to backup 3072K of critical section..
mdadm: /dev/md1 has been started with 3 drives (out of 4).

# cat /proc/mdstat 
Personalities : [raid1] [raid6] [raid5] [raid4] 
md1 : active raid5 sdb2[4] sdd2[3] sdc2[2]
      487709696 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [_UU]
      [>....................]  recovery =  0.0% (167432/243854848) finish=121.2min speed=33486K/sec

