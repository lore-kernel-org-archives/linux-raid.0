From: Michael-John Turner <mj@mjturner.net>
Subject: Re: raid1 running fine for years .. and then
Date: Tue, 13 Oct 2009 12:45:52 +0100
Message-ID: <20091013114552.GC11085@aurora.pimp.org.za>
References: <alpine.DEB.2.00.0910072350440.30153@p34.internal.lan>
 <20091012160040.GE17021@aurora.pimp.org.za>
 <alpine.DEB.2.00.0910121320160.2020@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910121320160.2020@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 12, 2009 at 01:20:55PM -0400, Justin Piszcz wrote:
> Drive is a 150GB raptor:
> 
> Device Model:     WDC WD1500ADFS-00SLR5
> Firmware Version: 21.07QR5

Hmm.... Doesn't seem drive related then. What kernel and SATA controller?
I'm using 2.6.26 and an ICH9R, with NCQ enabled.

-mj
-- 
 Michael-John Turner
 mj@mjturner.net      <>     http://mjturner.net/
