From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Single md physical device limit
Date: Tue, 20 Aug 2002 06:13:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15713.20853.644877.766865@notabene.cse.unsw.edu.au>
References: <CDF05CB9FCA0C845B9778F9E463C476101FC5F@cinshrexc01.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rechenberg, Andrew on Monday August 19
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 19, ARechenberg@shermanfinancialgroup.com wrote:
> 
> Without drastically modifying the kernel code, is there any way to
> increase the physical device limit when building a single md device?  I
> believe that the currently limit is 12 physical disks (?)

No, but the current limit is 27 .....
> 
> For reference, I would like to stripe across an entire Dell PowerVault
> 220S, which has 14 drives in it.

so this should work fine.

NeilBrown
