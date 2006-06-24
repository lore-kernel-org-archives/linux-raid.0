From: Neil Brown <neilb@suse.de>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Sat, 24 Jun 2006 15:19:51 +1000
Message-ID: <17564.52087.651968.635043@cse.unsw.edu.au>
References: <449AEB7C.6040108@cjx.com>
	<op.tblclqd3cigqcu@apollo13>
	<fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>
	<449BE381.6070000@cjx.com>
	<fd8d0180606230630x3f6b1ab7g444716cf8d5ab2c2@mail.gmail.com>
	<68c491a60606230746m5c1f0301g8e00fdd4f0e0739b@mail.gmail.com>
	<449C0505.8000601@tmr.com>
	<fd8d0180606230834t18427168jd776d33980f516b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Francois Barre on Friday June 23
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 23, francois.barre@gmail.com wrote:
> > The problem is that there is no cost effective backup available.
> 
> One-liner questions :
> - How does Google make backups ?

No, Google ARE the backups :-)

> - Aren't tapes dead yet ?

LTO-3 does 300Gig, and LTO-4 is planned.
They may not cope with tera-byte arrays in one hit, but they still
have real value.

> - What about a NUMA principle applied to storage ?

You mean an Hierarchical Storage Manager?  Yep, they exist.  I'm sure
SGI, EMC and assorted other TLAs could sell you one.

NeilBrown
