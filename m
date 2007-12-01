From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Sat, 1 Dec 2007 13:13:42 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>
Sender: linux-ide-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids


On Dec 1 2007 06:26, Justin Piszcz wrote:
> I ran the following:
>
> dd if=/dev/zero of=/dev/sdc
> dd if=/dev/zero of=/dev/sdd
> dd if=/dev/zero of=/dev/sde
>
> (as it is always a very good idea to do this with any new disk)

Why would you care about what's on the disk? fdisk, mkfs and
the day-to-day operation will overwrite it _anyway_.

(If you think the disk is not empty, you should look at it
and copy off all usable warez beforehand :-)

