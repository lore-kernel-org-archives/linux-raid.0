From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Why are reads not balanced across my RAID-1?
Date: Fri, 24 Jan 2014 16:22:56 -0200
Message-ID: <CAH3kUhGA8x_5hDbqxcskHQq+5YXFrz4XspmzeTq0O8dQci8zzw@mail.gmail.com>
References: <20140124104757.8256.qmail@science.horizon.com>
	<20140124120448.GA19163@www5.open-std.org>
	<CAJvUf-BfK-CeLFZ3WmRFbSpjr_x8x1FO7pDX5gmAJyw2RpekxA@mail.gmail.com>
	<20140124174904.GA6884@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140124174904.GA6884@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Matt Garman <matthew.garman@gmail.com>, George Spelvin <linux@horizon.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi guys, i done some tests some time ago, and what i can tell is

Raid1 use the nearest disk algorithm to select what disk will execute
reads (read balance)
i think it's very good, but don't consider diferent disk speed (access
time and continous read), but it do a very good job
i don't know there's space to improvement here, i got 1% of speed up
doing a mix of disk speed (7.2k rpm 5k rpm and 15k rpm and a ssd) and
changing the read balance algorithm
i think it's solid 1% of speed up, but confuse to config parameters,
parameters are based with access time (head time to move from position
0 to end of disk, or 0 for ssd) and continous read (based on mb/second
in a continous read, or based on rpm and track size)

the best i got is:
if you want raid1 you will run a system like databases, or multi
thread systems, each thread operating a disk
if have a system with continous read/write (dvr, stream, etc) raid10
far is the best

maybe more tunes you can do with align, read ahead, and others
filesystem options/parameters and cache, a raid card with flash backup
or battery is nice too

good luck


2014/1/24 <keld@keldix.com>
>
> On Fri, Jan 24, 2014 at 08:56:02AM -0600, Matt Garman wrote:
> > On Fri, Jan 24, 2014 at 6:04 AM,  <keld@keldix.com> wrote:
> > > The reading is not balanced because it does not make sense to do balanced
> > > reads for sequential reading. In RAID-1 the disk sectors are consequitive.
> > > So if you would read one sector from one disk, and the following sector from the other disk,
> > > then the next read from disk 1 would need to skip a full resolvation of the disk,
> > > which may cost something like 8 ms.  So better read contigously from the same disk, and hope
> > > for some other IO request that can use disk 2.
> >
> >
> > Does that rationale hold for SSDs?
>
> No, this is not relevant for SSDs as access time is almost zero.
>
> best regards
> keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




-- 
Roberto Spadim
