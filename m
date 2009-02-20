From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: General question (scheduler) with SSDs?
Date: Fri, 20 Feb 2009 13:12:09 +0000
Message-ID: <20090220131209.GA21446@silver.sucs.org>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan> <20090220094356.GB26124@silver.sucs.org> <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 20, 2009 at 12:16:42PM +0100, Kay Sievers wrote:
> 
> Udev can write to the attribute itself. This should be all you need:
>   SUSBSYTEM=="block", ATTRS{model}=="ASUS-PHISON *", ATTR{queue/rotational}="1"

I tried 
SUBSYSTEM=="block", ATTRS{model}=="ASUS-PHISON *", ATTR{queue/rotational}="0"
but udevtest /sys/block/sda/ doesn't list it as firing (udev 117-8)...

-- 
Sitsofe | http://sucs.org/~sits/
