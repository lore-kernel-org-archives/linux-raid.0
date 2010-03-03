From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Wed, 3 Mar 2010 10:13:15 +0100
Message-ID: <20100303091314.GA3730@lazy.lzy>
References: <yq1ocjemx46.fsf@sermon.lab.mkp.net>
 <20100225083936.07cd48ad@notabene.brown>
 <20100228080949.GA30574@maude.comedia.it>
 <20100302160100.621f9811@notabene.brown>
 <20100302073624.GA28827@maude.comedia.it>
 <4877c76c1003020204r477e942fo8ada66e1e9426295@mail.gmail.com>
 <20100302110232.GA14131@maude.comedia.it>
 <4B8D5581.8070509@shiftmail.org>
 <20100302185216.GB2243@lazy.lzy>
 <4B8D9EDD.2080300@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B8D9EDD.2080300@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> LVM copies the buffer!?
> I don't think so...
> LVM is near-zero overhead, so I would be surprised if it copied the buffer.

well, I'm not so sure it is near-zero overhead (I'll exaplain
below), and even if, making copies could be still "near-zero"
overhead, it depends on where the bottlenecks are.

I'm not an LVM insider, so this are just random thoughts.

About the near-zero overhead, maybe this could open a
different thread, but just to give some numbers...

I've a bunch of RAID-6 volumes, made of USB disks, i.e. using
PATA<->USB bridges.
This volumes are aggregated using LVM and, on top of that, there
is a LUKS container.

The raw read perfomance on the RAID-6 is, in the best case,
around about 48MB/s, which is pretty good for USB, I guess it
will be difficult to get more.
The raw read perfomance of the LVM volume is i~38MB/s.
The raw read performance of the LUKS is ~28MB/s (actually
maybe a bit less).

Each further layer loses about 10MB/s.

I guess this is much more visible in USB than in SATA/SAS
situations, since going from 205 to 195 might get unnoticed.

This is not a CPU problem, since the PC is dual core, one
core runs and it never exceeds 30%. The USB is slow enough
to allow all the operations to be performed in real-time.

Nevertheless, LVM is doing something there, in this setup
is has an overhead of about 20%, far from zero.
So, the 10MB/s loss could be, again I've no idea on how LVM
works, caused by copying.
Could also be something else, of course, it would be interesting
to have more information from some expert (also to optimize my
USB setup, if possible).

> Also I don't think it was needed in their case, except maybe if

Maybe, but if the filesystem can play with the buffer while
submitted, then I would rather copy the data.

Again, some expert opinion would be appreciated.

> LVM also does not merge requests AFAIR. (visible with mdstat -x 1)

BTW, what's that? I mean "mdstat -x 1"...
 
> But me also I have never seen mismatches and the only raid-1's I
> have are above LVM. (except /boot but that's almost never modified)

Well, that's good, you confirmed my experience.

I've also RAID-10 on LVM and never got mismatches, while the
plain RAID-10 got sometimes.

bye,

-- 

piergiorgio
