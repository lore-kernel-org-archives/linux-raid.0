From: Sam Clark <sclark_77@hotmail.com>
Subject: Re: RAID5 - Disk failed during re-shape
Date: Sat, 11 Aug 2012 10:42:01 +0200
Message-ID: <BLU401-EAS3343C9BB7296EA68990FF2294B20@phx.gbl>
References: <BLU153-ds1688A6A36A974526D12FDB94CC0@phx.gbl> <50258CEA.10100@turmel.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50258CEA.10100@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Thanks for the response Phil. 

I was thinking that 'toast' was the case, and have been looking into my backups (not so great, though the critical data is fine). 

Regards
Sam


On 11.08.2012, at 00:36, "Phil Turmel" <philip@turmel.org> wrote:

Hi Sam,

On 08/09/2012 04:38 AM, Sam Clark wrote:
> Hi All, 
> 
> Hoping you can help recover my data!
> 
> I have (had?) a software RAID 5 volume, created on Ubuntu 10.04 a few years
> back consisting of 4 x 1500GB drives.  Was running great until the
> motherboard died last week.   Purchased new motherboard, CPU & RAM,
> installed Ubuntu 12.04, and got everything assembled fine, and working for
> around 48 hours.  

Uh-oh.  Stock 12.04 has a buggy kernel.  See here:
http://neil.brown.name/blog/20120615073245

> After that I added a 2000GB drive to increase capacity, and ran mdadm --add
> /dev/md0 /dev/sdf.  The Re-configuration started to run, and then around
> 11.4% of the reshaping I saw that the server had some errors:

And you reshaped and got media errors ...

> Aug  8 22:17:41 nas kernel: [ 5927.453434] Buffer I/O error on device md0,
> logical block 715013760
> Aug  8 22:17:41 nas kernel: [ 5927.453439] EXT4-fs warning (device md0):
> ext4_end_bio:251: I/O error writing to inode 224003641 (offset 157810688
> size 4096 starting block 715013760)
> Aug  8 22:17:41 nas kernel: [ 5927.453448] JBD2: Detected IO errors while
> flushing file data on md0-8
> Aug  8 22:17:41 nas kernel: [ 5927.453467] Aborting journal on device md0-8.
> Aug  8 22:17:41 nas kernel: [ 5927.453642] Buffer I/O error on device md0,
> logical block 548962304
> Aug  8 22:17:41 nas kernel: [ 5927.453643] lost page write due to I/O error
> on md0
> Aug  8 22:17:41 nas kernel: [ 5927.453656] JBD2: I/O error detected when
> updating journal superblock for md0-8.
> Aug  8 22:17:41 nas kernel: [ 5927.453688] Buffer I/O error on device md0,
> logical block 0
> Aug  8 22:17:41 nas kernel: [ 5927.453690] lost page write due to I/O error
> on md0
> Aug  8 22:17:41 nas kernel: [ 5927.453697] EXT4-fs error (device md0):
> ext4_journal_start_sb:327: Detected aborted journal
> Aug  8 22:17:41 nas kernel: [ 5927.453700] EXT4-fs (md0): Remounting
> filesystem read-only
> Aug  8 22:17:41 nas kernel: [ 5927.453703] EXT4-fs (md0): previous I/O error
> to superblock detected
> Aug  8 22:17:41 nas kernel: [ 5927.453826] Buffer I/O error on device md0,
> logical block 715013760
> Aug  8 22:17:41 nas kernel: [ 5927.453828] lost page write due to I/O error
> on md0
> Aug  8 22:17:41 nas kernel: [ 5927.453842] JBD2: Detected IO errors while
> flushing file data on md0-8
> Aug  8 22:17:41 nas kernel: [ 5927.453848] Buffer I/O error on device md0,
> logical block 0
> Aug  8 22:17:41 nas kernel: [ 5927.453850] lost page write due to I/O error
> on md0
> Aug  8 22:20:54 nas kernel: [ 6120.964129] INFO: task md0_reshape:297
> blocked for more than 120 seconds.
> 
> On checking the progress of /proc/mdstat, I found that 2 drives were listed
> as failed (__UUU), and the finish time was simply growing by hundreds of
> minutes at a time.
> 
> I was able to browse some data on the Raid set (incl my Home folder), but
> couldn't browse some other sections - shell simply hung when I tried to
> issue "ls /raidmount".  I tied to add one of the failed disks back in, but
> got the response that there was no superblock on it.  rebooted it at that
> time.

Poof.  The bug wiped your active device's metadata.

> During boot I was given the option to manually recover, or skip mounting - I
> chose the latter. 

Good instincts, but probably not any help.

> Now that the system is running, I tried to assemble, but keeps failing. 
> Have tried:
> mdadm --assemble --force /dev/md0 /dev/sdb /dev/sdc /dev/sdd /dev/sde
> /dev/sdf
> 
> I am able to see all the drives, but can see the UUID is incorrect and the
> Raid Level states -unknown-, as below... does this mean the data can't be
> recovered?  

If you weren't in the middle of a reshape, you could recover using the
instructions in the blog entry above.

[trim /]

> I guess the 'invalid argument' is the -unknown- in the raid level.. but it's
> only a guess. 
> 
> I'm at the extent of my knowledge - would appreciate some expert assistance
> in recovering this array, if it's possible!

I think you are toast, as I saw nothing in the metadata that would give
you a precise reshape restart position, even if you got Neil to work up
a custom mdadm that could use it.  The 11.4% could be converted into an
approximate restart position, perhaps.

Neil, is there any way to do some combination of "create
--assume-clean", start a reshape held at zero, then skip 11.4% ?

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
