From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Wed, 6 Dec 2017 11:49:05 +0100
Message-ID: <20171206104905.GA4383@metamorpher.de>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru>
 <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Graham <jeremy@doghouse.agency>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 06, 2017 at 03:33:36PM +1100, Jeremy Graham wrote:
> How do I "manually regenerate content for each block in BBL's and then
> manually zero the lists in superblocks"? This is uncharted (and
> slightly scary) territory for me.

You don't. Just mdadm --assemble it with --update=force-no-bbl here.

If you have a filesystem with bad blocks management on top of it, 
check that too and clear it if necessary.

Regards
Andreas Klauer
