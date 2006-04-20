From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: replace disk in raid5 without linux noticing?
Date: Thu, 20 Apr 2006 17:22:08 +0200
Message-ID: <20060420152208.GF27744@boogie.lpds.sztaki.hu>
References: <200604191631.04305.Dexter.Filmore@gmx.de> <e3edb0fa0604190931i1160d94eo829ba17943b0c5eb@mail.gmail.com> <1145466223.8608.84.camel@localhost.localdomain> <44467654.2060903@swcp.com> <1145470570.8608.100.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1145470570.8608.100.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Brendan Conoboy <synk@swcp.com>, Shai <shaibn@gmail.com>, Dexter Filmore <Dexter.Filmore@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 19, 2006 at 02:16:10PM -0400, Ming Zhang wrote:

> is this possible? 
> * stop RAID5
> * set a mirror between current disk X and a new added disk Y, and X as
> primary one (which means copy X to Y to full sync, and before this ends,
> only read from X); also this mirror will not have any metadata or mark
> on existing disk;

The mirror should be created without persistent superblocks (obviously),
but --build does not seem to allow RAID1.

> * add this mirror to RAID5
> * start RAID5;
> 
> ... mirror will continue copy data from X to Y, once end
> 
> * stop RAID5
> * split mirror
> * put DISK Y back to RAID5
> * restart RAID5.
> 
> since this is a mirror, all metadata are same. it will be even greater
> if no need to stop raid5 to do this.

The process seems rather fragile. If I created a RAID5 array to protect
my data I most certainly would not like to perform so much steps where I
can mess up.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
