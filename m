From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Wed, 18 Jan 2006 09:57:08 +1100
Message-ID: <17357.30276.327186.496018@cse.unsw.edu.au>
References: <20060117174531.27739.patches@notabene>
	<43CCA80B.4020603@tls.msk.ru>
	<20060117095019.GA27262@localhost.localdomain>
	<43CCD453.9070900@tls.msk.ru>
	<43CD71FA.4090908@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Phillip Susi on Tuesday January 17
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, sander@humilis.net, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Tuesday January 17, psusi@cfl.rr.com wrote:
>                                                                  I was 
> also under the impression that md was going to be phased out and 
> replaced by the device mapper.

I wonder where this sort of idea comes from....

Obviously individual distributions are free to support or not support
whatever bits of code they like.  And developers are free to add
duplicate functionality to the kernel (I believe someone is working on
a raid5 target for dm).  But that doesn't mean that anything is going
to be 'phased out'.

md and dm, while similar, are quite different.  They can both
comfortably co-exist even if they have similar functionality.
What I expect will happen (in line with what normally happens in
Linux) is that both will continue to evolve as long as there is
interest and developer support.  They will quite possibly borrow ideas
from each other where that is relevant.  Parts of one may lose
support and eventually die (as md/multipath is on the way to doing)
but there is no wholesale 'phasing out' going to happen in either
direction. 

NeilBrown
