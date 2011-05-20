From: Ed W <lists@wildgooses.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 08:33:28 +0100
Message-ID: <4DD61948.8050302@wildgooses.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110520020853.GC4759@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/05/2011 03:08, Andy Smith wrote:
> Are there actually any HBAs that have BBU without using their RAID
> features?
> 
> I'd like to stop using hardware RAID but I can't give up the BBU and
> write cache.


This is a very interesting question. Does anyone know if say the Areca
ARC-1880ix-24 can be used in the same way, ie battery backed JBOD type mode?

I received a recommendation offlist that the various 3Ware SAS 9750-xx
cards can be used easily as a bunch of single drives, however, comparing
the photos of these with the LSI MegaRAID 9280-xx they seem identical?
(Presumed to be identical?).  Anyone know why LSI sell an identical card
under the 3ware brand (still)?  Curiously I see the LSI generally
selling a little cheaper than the 3ware in the uk... (wierd)

Are there any cards to avoid because they *can't* be used in this way?
eg Dell PERC6 seem to come up cheaply on ebay - can these be used as BBU
backed single JBOD controllers?

I guess the limitation is that some of these cards can only create a
small number of arrays and/or they don't use their writeback cache
efficiently in the case of multiple arrays?

Thanks for any education here.  (I found a cheap Areca on ebay, plus
been eyeing up the various cheap Dell PERC cards...)

Ed W
