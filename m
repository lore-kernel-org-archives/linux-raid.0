From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Re: Preparation advice?
Date: Sat, 27 Nov 2004 11:25:21 -0500
Message-ID: <6d5bedd8041127082528ce68ec@mail.gmail.com>
References: <6d5bedd8041126205255c0fe7d@mail.gmail.com>
	 <Pine.LNX.4.56.0411270837340.5805@lion.drogon.net>
Reply-To: Ewan Grantham <ewan.grantham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0411270837340.5805@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 27 Nov 2004 08:46:37 +0000 (GMT), Gordon Henderson
<gordon@drogon.net> wrote:
> Sounds like a bit of a homebrew bits & pieces box... :)

Well, it started out as a Compaq Presario, but as time has gone on...

> Read the Software RAID FAQ on
> 
>   http://www.tldp.org/HOWTO/Software-RAID-HOWTO.html
> 
> It's got basic instructions for both the older raidtools and the newer
> mdadm.

Is that going to ever be updated? I saw that site, as well as the
helpful chapter extract for using MDADM on O'Reilly, and noticed both
were from about 2002. I understand that the tools still work basically
the same way, but wonder if "our" understanding of RAID hasn't come
along a bit since then. And there are other topics that would be nice
to address - that I will be asking about shortly :-)

> And might you not want to make the bood drive mirrored also?

My boot drive is OS only. Idea has been (from past experience) to not
have anything on the boot drive that I wouldn't mind wiping for a
reinstall.

> Anyway, for the big array, assuming you just want one big ~750GB array
> (RAID 5 gives N-1 capacity) partition each drive the same way with one
> partition for the whole disk, then mark each partition with type FD and
> build the array. Make sure the kernel has RAID built-in to it, or the RAID
> modules are loaded at boot time and off you go. Once it's built, make a
> mount point for it and put an entry in the /etc/fstab for it and it'll be
> there for all time....

Currently building md0 as RAID 5 with chunk of 128 since all the
examples seem to indicate that is "better" than the 64 default.

Created a mount point /mnt/md0, but do I edit /etc/fstab or another
file since fstab seems to be generated on boot?

Also, once the build of md0 is complete, I assume I need to format my
new "drive". Any suggestions as to ext2 or ext3 or reiser or ...

Array will be used to capture and edit home videos - to the extent
that would influence folks suggestions.

Thanks again,
Ewan
