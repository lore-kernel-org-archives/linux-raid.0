From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: IT 8212F drivers for kernel-2.6.x released
Date: Mon, 15 Mar 2004 08:51:16 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4055B4D4.70005@pobox.com>
References: <1079347159.1650.0.camel@acidmachine.weltall.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1079347159.1650.0.camel@acidmachine.weltall.local>
To: Carsten Luedtke <acid_man@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carsten Luedtke wrote:
> In the last days I tried to get support in 2.6.4 for the IT8212F Raid
> chipset.This is also known GigaRAID on many GigaByte motherboards. With
> no success, because there wasn't a driver. 
> 
> Finally I could test the chipset with 2.4.26-pre2 successfully. But I
> wanted to get support for 2.6.x - so i wrote an email to ITE's support
> staff yesterday (itesupport@ite.com.tw). Today (after 16hours - :-) ) I
> got a response with the following:
> 
> -----snip-----
> Dear Sir,
> 
> Please visit our web site for downloading the newest driver for kernel
> 2.6.x. 
> http://www.ite.com.tw/productInfo/Download.html#IT8212 ATA133 Controller


They even posted specs, which is nice.  It needs to be a true-blue IDE 
(PATA) driver, basically...

	Jeff



