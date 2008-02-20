From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: How many drives are bad?
Date: Wed, 20 Feb 2008 07:21:11 +0000
Message-ID: <18363.54503.132788.594068@tree.ty.sabi.co.UK>
References: <6b3a7f010802190923v6b600fedy2a68ad6797449c6e@mail.gmail.com>
	<alpine.DEB.1.00.0802191231100.25959@p34.internal.lan>
	<21289113-077C-4082-8EE1-C7AA11D4FE69@gmail.com>
	<alpine.DEB.1.00.0802191332390.25959@p34.internal.lan>
	<6b3a7f010802191038y377999e0v46dcd7132ab3bc97@mail.gmail.com>
	<alpine.DEB.1.00.0802191413060.26058@p34.internal.lan>
	<6b3a7f010802191125q3905d1abw2372ed5c7ab1eaf0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6b3a7f010802191125q3905d1abw2372ed5c7ab1eaf0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Tue, 19 Feb 2008 14:25:28 -0500, "Norman Elton"
>>> <normelton@gmail.com> said:

[ ... ]

normelton> The box presents 48 drives, split across 6 SATA
normelton> controllers. So disks sda-sdh are on one controller,
normelton> etc. In our configuration, I run a RAID5 MD array for
normelton> each controller, then run LVM on top of these to form
normelton> one large VolGroup.

Pure genius! I wonder how many Thumpers have been configured in
this well thought out way :-).

BTW, just to be sure -- you are running LVM in default linear
mode over those 6 RAID5s aren't you?

normelton> I found that it was easiest to setup ext3 with a max
normelton> of 2TB partitions. So running on top of the massive
normelton> LVM VolGroup are a handful of ext3 partitions, each
normelton> mounted in the filesystem.

Uhm, assuming 500GB drives each RAID set has a capacity of
3.5TB, and odds are that a bit over half of those 2TB volumes
will straddle array boundaries. Such attention to detail is
quite remarkable :-).

normelton> This less than ideal (ZFS would allow us one large
normelton> partition),

That would be another stroke of genius! (especially if you were
still using a set of underlying RAID5s instead of letting ZFS do
its RAIDZ thing). :-)

normelton> but we're rewriting some software to utilize the
normelton> multi-partition scheme.

Good luck!
