From: "Norman Elton" <normelton@gmail.com>
Subject: Re: How many drives are bad?
Date: Tue, 19 Feb 2008 14:25:28 -0500
Message-ID: <6b3a7f010802191125q3905d1abw2372ed5c7ab1eaf0@mail.gmail.com>
References: <6b3a7f010802190923v6b600fedy2a68ad6797449c6e@mail.gmail.com>
	 <alpine.DEB.1.00.0802191231100.25959@p34.internal.lan>
	 <21289113-077C-4082-8EE1-C7AA11D4FE69@gmail.com>
	 <alpine.DEB.1.00.0802191332390.25959@p34.internal.lan>
	 <6b3a7f010802191038y377999e0v46dcd7132ab3bc97@mail.gmail.com>
	 <alpine.DEB.1.00.0802191413060.26058@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0802191413060.26058@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Justin,

There was actually a discussion I fired off a few weeks ago about how
to best run SW RAID on this hardware. Here's the recap:

We're running RHEL, so no access to ZFS/XFS. I really wish we could do
ZFS, but no luck.

The box presents 48 drives, split across 6 SATA controllers. So disks
sda-sdh are on one controller, etc. In our configuration, I run a
RAID5 MD array for each controller, then run LVM on top of these to
form one large VolGroup.

I found that it was easiest to setup ext3 with a max of 2TB
partitions. So running on top of the massive LVM VolGroup are a
handful of ext3 partitions, each mounted in the filesystem. This less
than ideal (ZFS would allow us one large partition), but we're
rewriting some software to utilize the multi-partition scheme.

In this setup, we should be fairly protected against drive failure. We
are vulnerable to a controller failure. If such a failure occurred,
we'd have to restore from backup.

Hope this helps, let me know if you have any questions or suggestions.
I'm certainly no expert here!

Thanks,

Norman

On 2/19/08, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Norman,
>
> I am extremely interested in what distribution you are running on it and
> what type of SW raid you are employing (besides the one you showed here),
> are all 48 drives filled, or?
>
> Justin.
>
> On Tue, 19 Feb 2008, Norman Elton wrote:
>
> > Justin,
> >
> > This is a Sun X4500 (Thumper) box, so it's got 48 drives inside.
> > /dev/sd[a-z] are all there as well, just in other RAID sets. Once you
> > get to /dev/sdz, it starts up at /dev/sdaa, sdab, etc.
> >
> > I'd be curious if what I'm experiencing is a bug. What should I try to
> > restore the array?
> >
> > Norman
> >
> > On 2/19/08, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> >> Neil,
> >>
> >> Is this a bug?
> >>
> >> Also, I have a question for Norman-- how come your drives are sda[a-z]1?
> >> Typically it is /dev/sda1 /dev/sdb1 etc?
> >>
> >> Justin.
> >>
> >> On Tue, 19 Feb 2008, Norman Elton wrote:
> >>
> >>> But why do two show up as "removed"?? I would expect /dev/sdal1 to show up
> >>> someplace, either active or failed.
> >>>
> >>> Any ideas?
> >>>
> >>> Thanks,
> >>>
> >>> Norman
> >>>
> >>>
> >>>
> >>> On Feb 19, 2008, at 12:31 PM, Justin Piszcz wrote:
> >>>
> >>>> How many drives actually failed?
> >>>>> Failed Devices : 1
> >>>>
> >>>>
> >>>> On Tue, 19 Feb 2008, Norman Elton wrote:
> >>>>
> >>>>> So I had my first "failure" today, when I got a report that one drive
> >>>>> (/dev/sdam) failed. I've attached the output of "mdadm --detail". It
> >>>>> appears that two drives are listed as "removed", but the array is
> >>>>> still functioning. What does this mean? How many drives actually
> >>>>> failed?
> >>>>>
> >>>>> This is all a test system, so I can dink around as much as necessary.
> >>>>> Thanks for any advice!
> >>>>>
> >>>>> Norman Elton
> >>>>>
> >>>>> ====== OUTPUT OF MDADM =====
> >>>>>
> >>>>>      Version : 00.90.03
> >>>>> Creation Time : Fri Jan 18 13:17:33 2008
> >>>>>   Raid Level : raid5
> >>>>>   Array Size : 6837319552 (6520.58 GiB 7001.42 GB)
> >>>>>  Device Size : 976759936 (931.51 GiB 1000.20 GB)
> >>>>> Raid Devices : 8
> >>>>> Total Devices : 7
> >>>>> Preferred Minor : 4
> >>>>>  Persistence : Superblock is persistent
> >>>>>
> >>>>>  Update Time : Mon Feb 18 11:49:13 2008
> >>>>>        State : clean, degraded
> >>>>> Active Devices : 6
> >>>>> Working Devices : 6
> >>>>> Failed Devices : 1
> >>>>> Spare Devices : 0
> >>>>>
> >>>>>       Layout : left-symmetric
> >>>>>   Chunk Size : 64K
> >>>>>
> >>>>>         UUID : b16bdcaf:a20192fb:39c74cb8:e5e60b20
> >>>>>       Events : 0.110
> >>>>>
> >>>>>  Number   Major   Minor   RaidDevice State
> >>>>>     0      66        1        0      active sync   /dev/sdag1
> >>>>>     1      66       17        1      active sync   /dev/sdah1
> >>>>>     2      66       33        2      active sync   /dev/sdai1
> >>>>>     3      66       49        3      active sync   /dev/sdaj1
> >>>>>     4      66       65        4      active sync   /dev/sdak1
> >>>>>     5       0        0        5      removed
> >>>>>     6       0        0        6      removed
> >>>>>     7      66      113        7      active sync   /dev/sdan1
> >>>>>
> >>>>>     8      66       97        -      faulty spare   /dev/sdam1
> >>>>> -
> >>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >>>>> the body of a message to majordomo@vger.kernel.org
> >>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
