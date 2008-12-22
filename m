From: "David Lethe" <david@santools.com>
Subject: RE: Spread Spectrum (SSC) Enable or Disable?
Date: Mon, 22 Dec 2008 09:22:04 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C031B1D1F@34093-C3-EVS3.exchange.rackspace.com>
References: <alpine.DEB.1.10.0812220857410.27615@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <alpine.DEB.1.10.0812220857410.27615@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
Cc: smartmontools-support@lists.sourceforge.net
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Justin Piszcz
> Sent: Monday, December 22, 2008 7:59 AM
> To: linux-raid@vger.kernel.org
> Cc: smartmontools-support@lists.sourceforge.net
> Subject: Spread Spectrum (SSC) Enable or Disable?
> 
> Besides the power supply/surge/etc with a lot of drives-- I have read:
> 
> http://www.wrightthisway.com/Articles/cat_reviews.html
> "As I mentioned earlier, the enclosure will definitely handle drives
> using Spread Spectrum Clocking (SSC), an increasingly common feature
> that helps reduce electromagnetic interference, especially between
> drives in close proximity with each others, such as you might have in
a
> RAID setup, so that is a definite plus here."
> 
> With 16-24 disks-- if they are close together, it sounds like a good
> idea to use Spread Spectrum Clocking?
> Does anyone here with a large-ish raid array use this?
> 
> Any enterprise-insiders care to comment?
> 
> Justin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
I know for a fact that Xyratex supports SSC on SOME of their enclosures.
However,
there is a caveat to be aware of ... some RAID
controllers/firmware/enclosure combinations
have problems "seeing" disks that have SSC enabled.  Don't just turn
this on unless you
verify with the enclosure manufacturer that they support SSC for your
desired combination.

David


