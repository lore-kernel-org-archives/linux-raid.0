From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: General question (scheduler) with SSDs?
Date: Fri, 20 Feb 2009 20:35:15 +0100
Message-ID: <ac3eb2510902201135x70abdce9n46c7c53a5c04edcd@mail.gmail.com>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
	 <20090220094356.GB26124@silver.sucs.org>
	 <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com>
	 <20090220131209.GA21446@silver.sucs.org>
	 <ac3eb2510902200523o619e64aas7bffac9aeca86814@mail.gmail.com>
	 <20090220142705.GA429@silver.sucs.org>
	 <ac3eb2510902200656l11275aber128848182553726d@mail.gmail.com>
	 <20090220192543.GA21644@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090220192543.GA21644@silver.sucs.org>
Sender: linux-raid-owner@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 20, 2009 at 20:25, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Fri, Feb 20, 2009 at 03:56:06PM +0100, Kay Sievers wrote:
>> Also the whitespace after "...PHISON *" does not need to be matched.
>> If the match value does not end in whitespace itself, udev will match
>> against the value with all trailing whitespace ignored.
>
> Ah, I'm not matching against only whitespace:
>
> $ cat /sys/block/*/device/model
> ASUS-PHISON OB S
> ASUS-PHISON SSD
>
> (the first is the builtin faster SSD, the other is the slower removable
> SSD).

Ah, I see, then nothing to complain from my side anymore. :)

Thanks,
Kay
