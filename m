From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Wed, 6 Dec 2017 17:03:46 +0100
Message-ID: <20171206160346.GA5806@metamorpher.de>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru>
 <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
 <20171206104905.GA4383@metamorpher.de>
 <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Jeremy Graham <jeremy@doghouse.agency>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 06, 2017 at 09:15:21AM -0500, Phil Turmel wrote:
> The problem with this is that the sectors currently marked don't have
> appropriate data.

It might have the correct data. Depends what exactly happened.
If it happened years ago and you never noticed until reshape, 
chances are it won't matter one way or another.

Of course, it doesn't hurt to take additional steps, if you have 
backups to compare with or some other way to check file integrity. 

> > If you have a filesystem with bad blocks management on top of it, 
> > check that too and clear it if necessary.
> 
> MD's BBL system doesn't coordinate with the filesystem on top, so this
> is meaningless.

MD with duped BBLs does return read errors, so it's a possibility.
 
> The BBL in MD is woefully incomplete and should *never* be used.

There's ups and downs to everything. Relocations would be awful too. 
Harms performance and makes recovery all but impossible. So many people 
on this list with lost metadata, figuring out RAID layout and drive 
oder is hard, but figuring out random relocations is impossible.

The BBL could be improved a lot if it prevented BBLs to be identical 
across drives, and gave bad blocks a second chance. Once the cable 
problem is solved, MD should help you turning those bad blocks back 
into good ones.

And if your drive actually has real bad blocks, the only correct course 
of action is to replace it entirely. The problem with BBL right now is 
that even if you replace all drives, the BBL stays. Once it's duplicated 
you are stuck with it forever until you forcibly remove it.

Regards
Andreas Klauer
