From: Janos Farkas <jf-ml-k3-raid@lk8rp.mail.xeon.eu.org>
Subject: Re: raid1 with 1.2 superblock never marked healthy?
Date: Fri, 24 Feb 2006 16:24:47 +0100
Message-ID: <priv$1140794048.koan@shadow.banki.hu>
References: <priv$1140364975.koan@shadow.banki.hu> <17400.61822.230666.23651@cse.unsw.edu.au> <privx$1140425087.koan@lk8rp.mail.xeon.eu.org> <Pine.LNX.4.64.0602200741570.29156@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0602200741570.29156@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2006-02-20 at 07:48:01, James W. Laferriere wrote:
> 	How hard would it be for mdadm & md to allow use of both internal
> 	and external bitmaps ?  And then mdadm be extended to do a compare
> 	of an external against a internal when the opertaor askes to do
> 	so .  Soes this sound reasonable ?  Thoughts ?

Can you explain a bit more what would it be useful?  As I understand the
concept (which may be quite different from the reality and/or
implementation), the bitmap of the "most up-to-date" component is used to
determine what updates the other component is missing.

(What to do in the case of multi-way, arbitrarily removed mirrors is
above my head :)

In that scheme, I don't see any use of a bitmap which is not "connected"
to any available sub-component.

Janos
