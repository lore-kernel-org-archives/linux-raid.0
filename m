From: "Scott T. Smith" <scott@gelatinous.com>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sun, 01 Aug 2004 10:57:02 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1091383022.11789.17.camel@tinny.home.foo>
References: <Pine.LNX.4.44.0408011723330.7382-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0408011723330.7382-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Jim Buttafuoco <jim@contactbda.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2004-08-01 at 08:24, Mikael Abrahamsson wrote:
> On Sun, 1 Aug 2004, Jim Buttafuoco wrote:
> 
> > I am switching all of my 3ware controllers over to Adaptec SATA raid
> > controllers.  I am getting better performance with them.  Jim
> 
> I am quite curious about the 16port SATA controller Adaptec has now. Do 
> you have any filesystem write figures for this controller under linux and 
> ext3?

One main problem with the 16port controller, at least in JBOD mode, is
that there is not enough PCI bandwidth to fill the disks if you do large
writes.  Thus two separate 8port controllers, on separate PCI busses,
should yield higher performance.

OTOH, if you're doing small ops, or RAID1, it will probably be fine.

(disclaimer -- I haven't tried the Adaptec boards yet, but they're on my
list, along with Highpoint's)

	Scott


