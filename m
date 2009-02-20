From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: General question (scheduler) with SSDs?
Date: Fri, 20 Feb 2009 14:23:38 +0100
Message-ID: <ac3eb2510902200523o619e64aas7bffac9aeca86814@mail.gmail.com>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
	 <20090220094356.GB26124@silver.sucs.org>
	 <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com>
	 <20090220131209.GA21446@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090220131209.GA21446@silver.sucs.org>
Sender: linux-raid-owner@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 20, 2009 at 14:12, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Fri, Feb 20, 2009 at 12:16:42PM +0100, Kay Sievers wrote:
>>
>> Udev can write to the attribute itself. This should be all you need:
>>   SUSBSYTEM=="block", ATTRS{model}=="ASUS-PHISON *", ATTR{queue/rotational}="1"
>
> I tried
> SUBSYSTEM=="block", ATTRS{model}=="ASUS-PHISON *", ATTR{queue/rotational}="0"
> but udevtest /sys/block/sda/ doesn't list it as firing (udev 117-8)...

I does here:
  udev_rules_apply_to_event: ATTR '/sys/devices/ ...
/sdb/queue/rotational' writing '0'

  $grep . /sys/class/block/*/queue/rotational
  /sys/class/block/sda/queue/rotational:1
  /sys/class/block/sdb/queue/rotational:0

Maybe "udevtest" is not showing it for you, or udev 117 is too old and
does not work that way.

Thanks,
Kay
