From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Roadmap for md/raid ???
Date: Mon, 19 Jan 2009 22:08:29 +0100
Message-ID: <20090119210829.GA6143@rap.rap.dk>
References: <18763.7881.300921.177207@notabene.brown> <20090111181413.GA24988@lazy.lzy> <18803.55804.905420.503480@nbeee.brown> <20090119181919.GB4290@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090119181919.GB4290@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 19, 2009 at 07:19:19PM +0100, Piergiorgio Sartor wrote:
> Hi,
> 
> Let's assume we have a RAID-5 with 7 disks.
> Each time an HD fails, we will replace it with a
> larger one, since this will be cheaper.
> Once we replaced 3 HDs, with could use the unused
> space in RAID-5 again.
> Unfortunately, with the current features, we will
> have to wait to fail all the 7 disks.

Nah, when you have 2 new disks, you can put the excessive space into a
new raid, which should be able to grow, with further new disks to arrive. 
But in principle you are right, it would be nice to use dirfferent
age/size disks in a clever way.

Best regards
Keld
