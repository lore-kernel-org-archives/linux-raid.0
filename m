From: Adam Kropelin <akropel1@rochester.rr.com>
Subject: Re: Linux: Why software RAID?
Date: Thu, 24 Aug 2006 09:07:41 -0400
Message-ID: <20060824090741.J30362@mail.kroptech.com>
References: <44ED1E41.40606@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44ED1E41.40606@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, marc@perkel.com
List-Id: linux-raid.ids

Jeff Garzik <jeff@garzik.org> wrote:
> But anyway, to help answer the question of hardware vs. software RAID, I 
> wrote up a page:
> 
> 	http://linux.yyz.us/why-software-raid.html
> 
> Generally, you want software RAID unless your PCI bus (or more rarely, 
> your CPU) is getting saturated.  With RAID-0, there is no duplication of 
> data, and so, PCI bus and CPU usage should be about the same for 
> hardware and software RAID.

Hardware RAID can be (!= is) more tolerant of serious drive failures
where a single drive locks up the bus. A high-end hardware RAID card 
may be designed with independent controllers so a single drive failure
cannot take other spindles down with it. The same can be accomplished 
with sw RAID of course if the builder is careful to use multiple PCI 
cards, etc. Sw RAID over your motherboard's onboard controllers leaves
you vulnerable.

--Adam

