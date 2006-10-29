From: Neil Brown <neilb@suse.de>
Subject: Re: md array numbering is messed up
Date: Mon, 30 Oct 2006 08:26:43 +1100
Message-ID: <17733.7315.357603.311275@cse.unsw.edu.au>
References: <45451A4C.9010708@peeble.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peb on Sunday October 29
Sender: linux-raid-owner@vger.kernel.org
To: Peb <peb-misc@peeble.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday October 29, peb-misc@peeble.net wrote:
> Hi,
> 
> I have 2 arrays whose numbers get inverted, creating havoc, when booting
> under different kernels.
> 
> I have md0 (raid1) made up of ide drives and md1 (raid5) made up of five
> sata drives, when booting with my current ubuntu 2.6.12-9 kernel. When I
> try to boot a more recent kernel (2.6.15-26 or 2.6.15-27) the
> order is inversed and my sata raid5 array shows up as md0.
> 
> My arrays are part of evms volumes that just stop working if the
> numbering is inverted.
> 
> any clues ?

Your arrays are being started the wrong way.
Do you have an mdadm.conf that lists the arrays?  Can you show us what
it looked like?
If not, do you know how the arrays are started in ubuntu?

NeilBrown
