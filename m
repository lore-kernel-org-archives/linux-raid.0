From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: poor performance with raid1 / raid0
Date: Wed, 18 Jun 2003 11:03:30 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030618150330.GA19643@willow.seitz.com>
References: <PERBUMSGID-ul6fzm7tvl3.fsf@ipchains.linpro.no> <1055943743.31927.20.camel@cinshrlnxws01.shermfin.com> <PERBUMSGID-ul63ci7trhw.fsf@ipchains.linpro.no> <3EF079A9.9FB561AF@SteelEye.com> <3EF07C9C.7070802@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3EF07C9C.7070802@bnap.hu>
To: Farkas Levente <lfarkas@bnap.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 18, 2003 at 04:52:12PM +0200, Farkas Levente wrote:
> can someone tell me what these numbers means?

They're a max speed in K/sec.

> of course my goal (as everyones) to achieve the maximum possible 
> performance.
> can I do any harm if I set these numbers to high?

Nope.

> it no, why not set it bu default?

By default, the RAID code uses max bandwidth and backs off when it sees
that the device is busy.  However, you're running RAID1 over RAID0 - so
to the RAID1 layer, the lower layer is busy - namely, it's being used by
the RAID0 code.  You can avoid this problem by running RAID0 over RAID1
instead.  But since your disk configuration makes this impossible (you'd
need matching disks for the mirrors), just modify your boot scripts to max
out speed_limit*.

-- 
Ross Vandegrift
ross@willow.seitz.com

A Pope has a Water Cannon.                               It is a Water Cannon.
He fires Holy-Water from it.                        It is a Holy-Water Cannon.
He Blesses it.                                 It is a Holy Holy-Water Cannon.
He Blesses the Hell out of it.          It is a Wholly Holy Holy-Water Cannon.
He has it pierced.                It is a Holey Wholly Holy Holy-Water Cannon.
He makes it official.       It is a Canon Holey Wholly Holy Holy-Water Cannon.
Batman and Robin arrive.                                       He shoots them.
