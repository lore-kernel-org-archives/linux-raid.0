From: dean gaudet <dean@arctic.org>
Subject: Re: soft-lockup in raid5 / 2.6.24
Date: Sun, 13 Apr 2008 21:23:28 -0700 (PDT)
Message-ID: <alpine.DEB.1.10.0804132119250.10006@twinlark.arctic.org>
References: <alpine.DEB.1.10.0804070806300.7751@twinlark.arctic.org> <e9c3a7c20804071543l6d9df2dbkc86bec6388da3f77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20804071543l6d9df2dbkc86bec6388da3f77@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 7 Apr 2008, Dan Williams wrote:

> On Mon, Apr 7, 2008 at 8:22 AM, dean gaudet <dean@arctic.org> wrote:
> > while my system was doing its monthly check (debian) i bumped into
> >  soft-lockups in the raid5 code.  i must mention this is a rather mature
> >  system, the disks are 3.5 years old at this point... so i'm not surprised
> >  that the check will find some bad sectors which will take the
> >  device/driver a while to read/correct.
> >
> >  all SMART events in this log are on disks which are part of /dev/md4 which
> >  is a raid5.  the controller is a 3ware 7508, the disks are seagate
> >  ST3400832A.
> >
> >  apparently no errors propagated all the way up to raid5, but based on the
> >  SMART events i'm pretty sure several sectors took a long time to finish
> >  being read and were probably corrected by the drive itself.
> >
> >  this is debian kernel image 2.6.24-1-686 version 2.6.24-4 which contains
> >  upstream 2.6.24.2.
> >
> >  -dean
> >
> >  root@neemlark:~# cat /sys/block/md4/md/mismatch_cnt
> >  0
> >
> 
> This does not look like the hang that is set to be fixed in 2.6.24.5.
> Does /proc/mdstat show that the resync is progressing, or does it
> appear to be stalled?

oh it finished, sorry i should have said that :)

there were just those various soft lockup warnings...

as a wild stab in the dark -- does the "faulty" test mode support
delaying reads or writes for a very long time?  (or is there some other
fake block device we can inject long delays with?)

-dean
