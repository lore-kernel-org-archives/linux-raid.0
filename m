From: "Samuel Davidoff" <sam@davidoffdotcom.com>
Subject: Re: SATA Raid0 in 2.4?
Date: Mon, 15 Mar 2004 09:47:15 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <18783.208.27.111.121.1079362035.squirrel@mail.davidoffdotcom.com>
References: <Pine.LNX.4.58.0403150928140.21510@wormwood.cs.yorku.ca>
     <4055BF4A.3080103@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4055BF4A.3080103@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andrew Hogue <hogue@cs.yorku.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there a 2.4 patch to add support for the promise sx4 controller?

> Andrew Hogue wrote:
>> Hi,
>>
>> I am using a Via 8237 southbridge with serial ata support.  I noticed
>> that
>> this isn't supported in kernel 2.4 but it is in 2.6.x through libata.
>> I'm
>> having issues with 2.6.4 with my hardware due to some strange
>> incompatibility.
>>
>> So, is there any way to get the via 8237 support into kernel 2.4?  Has
>> anyone set up a Raid0 with this configuration?
>
> A patch is available for 2.4...
> http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

