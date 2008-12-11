From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: Kernel BUG
Date: Thu, 11 Dec 2008 14:23:54 -0700
Message-ID: <e9c3a7c20812111323g4dabfab6q331436e329271b24@mail.gmail.com>
References: <150c16850812011409hf507ac6m5b168571ee6b453e@mail.gmail.com>
	 <150c16850812021306p4334516fo4124b29aa3c117d7@mail.gmail.com>
	 <18741.50918.712839.804410@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18741.50918.712839.804410@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Maggard <jmaggard10@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 2, 2008 at 4:38 PM, Neil Brown <neilb@suse.de> wrote:
> Thanks for reporting this.  And sorry for not responding when you
> posted it over a week ago to linux-kernel.  I did see it....
>
> It seems that the in-kernel shutdown process is stopping the md arrays
> before all dirty data is flushed.  I guess that is reasonable as the
> '-n' means "don't sync".  However the kernel keeps flushing out dirty
> data after the shutdown has started and that seems to be the problem.
>
> The fact that it has only recently started happening is a useful clue.
> It would be really helpful to use 'git bisect' to find out which
> change introduced the problem.  That should make it a lot easier to
> understand the cause.
>
> I might try to give this a try, but if you are able to try that too it
> would be very helpful.
>

So I took a look at this and if I am not mistaken it appears to be
problem with how md handles the readonly flag.  It was not a problem
before because md would not force the switch to readonly prior to
2.6.27.  Another test case which reproduces this, without the shutdown
interaction, is:

1/ create a dirty xfs filesystem such that on next mount it will
require recovery
mdadm --create /dev/md0 /dev/sd[a-d] -n 4 -l 5
mkfs.xfs /dev/md0
mount /dev/md0 /mnt/tmp
dd if=/dev/zero of=/mnt/tmp/test &
reboot -fn

2/ Assemble the array readonly but then mark it rw with blockdev
mdadm -A /dev/md0 /dev/sd[a-d]
mdadm --readonly /dev/md0
blockdev --getro /dev/md0
1
blockdev --setrw /dev/md0
blockdev --getro /dev/md0
0
cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active (read-only) raid5 sda[0] sdd[3] sdc[2] sdb[1]
      234451968 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
        resync=PENDING

3/ Mounting the filesystem triggers the bug in md_write_start
mount /dev/md0 /mnt/tmp
Filesystem "md0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem md0
kernel BUG at drivers/md/md.c:5358!

Is there a reason md does not catch the BLKROSET in md_ioctl?  That
seems like a straightforward fix.  What I am not sure how to properly
handle is the window between setting the block device readonly and
marking the mddev readonly.  Seems like ->quiesce() could be put to
use here, but I don't think that completely closes the door on
in-flight writes:

Thread0	Thread1
write1
write2	setro
write3	quiesce
write4	do_md_stop

write1 succeeeds, write3,4 get EPERM, but write2 can be in flight
after the check but before ->make_request()?

Thanks,
Dan
