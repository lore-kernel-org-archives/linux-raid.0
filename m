From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Preparation advice?
Date: Sun, 28 Nov 2004 11:07:15 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0411281052440.5805@lion.drogon.net>
References: <6d5bedd8041126205255c0fe7d@mail.gmail.com>
 <Pine.LNX.4.56.0411270837340.5805@lion.drogon.net> <6d5bedd8041127082528ce68ec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d5bedd8041127082528ce68ec@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 27 Nov 2004, Ewan Grantham wrote:

> On Sat, 27 Nov 2004 08:46:37 +0000 (GMT), Gordon Henderson
> <gordon@drogon.net> wrote:
> > Sounds like a bit of a homebrew bits & pieces box... :)
>
> Well, it started out as a Compaq Presario, but as time has gone on...
>
> > Read the Software RAID FAQ on
> >
> >   http://www.tldp.org/HOWTO/Software-RAID-HOWTO.html
> >
> > It's got basic instructions for both the older raidtools and the newer
> > mdadm.
>
> Is that going to ever be updated? I saw that site, as well as the
> helpful chapter extract for using MDADM on O'Reilly, and noticed both
> were from about 2002. I understand that the tools still work basically
> the same way, but wonder if "our" understanding of RAID hasn't come
> along a bit since then. And there are other topics that would be nice
> to address - that I will be asking about shortly :-)

Er, I'm sure if you want to volenteer to update it your thoughts will be
taken on-board :)

> > And might you not want to make the bood drive mirrored also?
>
> My boot drive is OS only. Idea has been (from past experience) to not
> have anything on the boot drive that I wouldn't mind wiping for a
> reinstall.

Fair-enough, but with 4 big disks, taking a GB to put the OS on, and have
it RAID1'd over the 4 disks might just save you that half-days agony if
the boot disk ever fails..

> Currently building md0 as RAID 5 with chunk of 128 since all the
> examples seem to indicate that is "better" than the 64 default.

"Better" really depends on what you might be using it for - but it sounds
like it might be OK if all you are doing is streaming large files... The
only realy way to work out is to benchmark the array with something thats
as close to your application as possible.

Remember that you can reflect the chunk size in the ext2/3 strip size...
(And maybe for other filesystems too)

> Created a mount point /mnt/md0, but do I edit /etc/fstab or another
> file since fstab seems to be generated on boot?

I don't know any distros that denetate this at boot time, but I only
really know Debian and a bit of deadrat these days. Traditionally you
would edit this file to add in your array under some mount point of your
choosing.

> Also, once the build of md0 is complete, I assume I need to format my
> new "drive". Any suggestions as to ext2 or ext3 or reiser or ...

You can format is while it's building. However, in-light of the recent
threads on drive failures, etc. it's well worth your time to run badblocks
on it overnight with both read and write tests just to make sure that
every block can be actually written and read back again, although just
waiting for the raid5 to sync will do some of this, but not everything. If
you have the time, I'd recomend you do it.

Also make sure you have the right drivers loaded in the kernel - it's
worth while doing a gross speed test on each device using hdparm to check
this - eg. hdparm -Tt /dev/sad1 etc.

I'd build the array, wait for it to sync, run badblocks -sw -p99 -c8192 on
it overnight, then mkfs it with your favouring filesystem.

Holy wars have been fought over lesser issues than filesystem choice, so
you might as well toss a coin, or stick to something you know and like. A
journalling filesystem (eg. ext3, xfs, reiser) may impose some latency on
long streaming writes which is what you are after, but only benchmarking
will tell you this.

Personally, I'd stick to ext2 or 3, having used it for many years now, but
I might have a look at XFS again, which I looked at some 12-18 months back
but didn't really have good results with it.

> Array will be used to capture and edit home videos - to the extent
> that would influence folks suggestions.

Enjoy!

Gordon
