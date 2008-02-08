From: Iustin Pop <iusty@k1024.org>
Subject: Re: Any inexpensive hardware recommendations for PCI interface
	cards?
Date: Fri, 8 Feb 2008 20:01:47 +0100
Message-ID: <20080208190147.GA24083@teal.hq.k1024.org>
References: <11ae01c86a44$aff357a0$0603a8c0@meanmachine> <47AC5162.4080700@tmr.com> <alpine.DEB.1.00.0802080854390.11577@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0802080854390.11577@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Steve Fairbairn <steve@fairbairn-family.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 08, 2008 at 08:54:55AM -0500, Justin Piszcz wrote:
> The promise tx4 pci works great and supports sata/300+ncq/etc $60-$70.

Wait, I have used tx4 pci up until ~2.6.22 and it didn't support AFAIK
ncq. Are you sure that current driver supports NCQ? I might then revive
that card :)

thanks,
iustin
