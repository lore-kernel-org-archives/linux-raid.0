From: Tejun Heo <htejun@gmail.com>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Mon, 10 Dec 2007 17:23:39 +0900
Message-ID: <475CF78B.3040404@gmail.com>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan> <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712010722590.28887@p34.internal.lan> <20071201174733.646a5c35@absurd> <Pine.LNX.4.64.0712011155110.6257@p34.internal.lan> <Pine.LNX.4.64.0712020409280.30169@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712020409280.30169@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

Justin Piszcz wrote:
> The badblocks did not do anything; however, when I built a software raid
> 5 and the performed a dd:
> 
> /usr/bin/time dd if=/dev/zero of=fill_disk bs=1M
> 
> [42332.936615] ata5.00: exception Emask 0x2 SAct 0x7000 SErr 0x0 action
> 0x2 frozen
> [42332.936706] ata5.00: spurious completions during NCQ issue=0x0
> SAct=0x7000 FIS=004040a1:00000800
> 
> Next test, I will turn off NCQ and try to make the problem re-occur.
> If anyone else has any thoughts here..?
> I ran long smart tests on all 3 disks, they all ran successfully.
> 
> Perhaps these drives need to be NCQ BLACKLISTED with the P35 chipset?

That was me being stupid.  Patches for both upstream and -stable
branches are posted.  These will go away.

Thanks.

-- 
tejun
