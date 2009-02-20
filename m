From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: General question (scheduler) with SSDs?
Date: Fri, 20 Feb 2009 12:16:42 +0100
Message-ID: <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
	 <20090220094356.GB26124@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090220094356.GB26124@silver.sucs.org>
Sender: linux-raid-owner@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 20, 2009 at 10:43, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> Whoops, I didn't mean to send that previous half formed mail :) Sorry.
>
> On Thu, Feb 19, 2009 at 08:38:38AM -0500, Justin Piszcz wrote:
>>
>> I was curious if anyone had done any benchmarks and/or has conclusive
>> information, what is the best Linux scheduler to use with SSDs?
>>
>> Noop?
>> CFQ?
>> AS?
>> Deadline?
>
> As mentioned in another mail there was a discussion on
> http://lkml.org/lkml/2009/1/31/28 and long thread talking about the
> introduction of the rotational flag here
> http://lkml.org/lkml/2009/1/5/340 . Cheapo SSDs or even USB keys are not
> auto detected as non-rotational devices by the kernel and after a bit of
> poking about I've come up with the following udev rules for my
> particular cases:
>
> SUBSYSTEM=="block", TEST=="/sys$devpath/queue/rotational", ATTRS{model}=="ASUS-PHISON *", RUN+="/bin/sh -c 'echo 0 > /sys$devpath/queue/rotational'"

Udev can write to the attribute itself. This should be all you need:
  SUSBSYTEM=="block", ATTRS{model}=="ASUS-PHISON *", ATTR{queue/rotational}="1"

Kay
