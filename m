From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Fri, 2 Oct 2009 08:46:47 -0700
Message-ID: <babafd2f0910020846o22e7dd30l4a7be554770d0904@mail.gmail.com>
References: <babafd2f0910012046i46f77e82lc1a75bbee3b1a6d8@mail.gmail.com>
	<887103.5263.qm@web38801.mail.mud.yahoo.com> <babafd2f0910020754i4818043aw3d4a15e91eec9eb8@mail.gmail.com>
	<20091002151504.GA22207@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091002151504.GA22207@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, keld@dkuug.dk, robin@robinhill.me.uk
List-Id: linux-raid.ids

keld@dkuug.dk,robin@robinhill.me.uk


Hi,

2009/10/2 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> raid10 is "new" and "dangerous" (FUD). Many people
> do not know about raid10, and its wonders.

So, the "usual suspects".

> if the raid type happens to be the same layout as  a non-raid partiti=
on, it
> works. raid10,n2 default layout (ver 0.90) is equivalent with non-rai=
d,
> as the raid superblock is in the end of the partition.

That makes sense, thanks. Not clear whether that's "officially
supported" or "just lucky".

Just to be ccertain, which metadata version, 0.90(default) or 1.0?
According to the man page,

	0, 0.90, default
		 Use  the original 0.90 format superblock.  This format limits
arrays to 28 component devices and limits
		 component devices of levels 1 and greater to 2 terabytes.

	1, 1.0, 1.1, 1.2
		 Use the new version-1 format superblock.  This has few
restrictions.  The different sub-versions  store
		 the  superblock  at  different  locations on the device, either at
the end (for 1.0), at the start (for
		 1.1) or 4K from the start (for 1.2).

it's v 1.0 that specifically states the super block is "at the end".
Will either/both work?

On Fri, Oct 2, 2009 at 8:15 AM, Robin Hill <robin@robinhill.me.uk> wrot=
e:
> The main reason is that RAID-1 works across any number of disks (as
> they're all identical) whereas RAID-10,nX working is an artifact of h=
ow
> that layout works for X drives (they end up being identical to RAID-1=
).

As X is a variable, according to the man page,

  "The number is the number of copies of each datablock.  2 is normal,
3 can be useful.
   This number  can  be  at most equal to the number of devices in the
array.  It does
   not need to divide evenly into that number (e.g. it is perfectly
legal to have an 'n2'
   layout for an array with an odd number of devices)."

does "RAID-10,nX working is an artifact" hold true for any X?

If I've a 4-drive RAID-10 array that I want to have a bootable-/boot
on, should X best be "normmal" 2, "useful" 3, or "unmentioned" 4?  As
usual it seems that performance, redundancy/robustness, and space
utilization, as well as just being able to boot, all have a part to
play.

>> On Fri, Oct 2, 2009 at 12:54 AM, Robin Hill <robin@robinhill.me.uk> =
wrote:
> Yes, Alt-F2 will get you to the second console, Alt-F3 for the third =
(or
> Ctrl-Alt-F2 from within X).

Just found the docs, too. Thanks!

> It's the combination - RAID10,o2 for 2 drives results in one drive
> having all data in normal order (so bootable) and the other having ev=
ery
> pair of chunks flipped.

Sound like RAID10,n2 (or n3 or n4, in my case) is the right approach.

> The Wikipedia entry for Non-standard RAID levels has diagrams

=46ound it, Thanks.

Thanks for the help & discussion!

Ben
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
