From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Fwd: "Enhanced" MD code avaible for review]
Date: Wed, 17 Mar 2004 20:34:16 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040317193416.GA24542@lst.de>
References: <405899E8.8070806@pobox.com> <20040317183756.GA23667@lst.de> <2241002704.1079549645@aslan.btc.adaptec.com> <20040317190117.GA23968@lst.de> <2260532704.1079550351@aslan.btc.adaptec.com> <20040317190916.GA24118@lst.de> <4058A6FB.6080602@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4058A6FB.6080602@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>, linux-raid@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 17, 2004 at 02:28:59PM -0500, Jeff Garzik wrote:
> If early userspace isn't ready, it sounds like a choice between 
> "nothing" and "it works".
> 
> We want a clean, tasteful solution, sure.  But I think we can work 
> within the confines of the existing 2.6 API, and not postpone this stuff 
> under early userspace is ready.

Umm, early userspace works nicely, you don't need the klibc and
initramfs buzzwords for that, good 'ol initrd still works and people
actually use it, e.g. for dm.

