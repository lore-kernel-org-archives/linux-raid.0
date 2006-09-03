From: David Greaves <david@dgreaves.com>
Subject: Re: Kernel RAID support
Date: Sun, 03 Sep 2006 11:49:58 +0100
Message-ID: <44FAB356.1070109@dgreaves.com>
References: <44FA5261.4010207@sauce.co.nz> <1157256114.10326.0.camel@localhost> <44FA5BE1.1080706@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FA5BE1.1080706@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, josh@temp123.org
List-Id: linux-raid.ids

Richard Scobie wrote:
> Josh Litherland wrote:
>> On Sun, 2006-09-03 at 15:56 +1200, Richard Scobie wrote:
>>
>>> I am building  2.6.18rc5-mm1 and I cannot find the entry under "make
>>> config", to enable the various RAID options.
>>
>>
>> Under "Device Drivers", switch on "Multi-device support".
>>
> 
> Thanks. I must be going nuts, as it does not appear as an option. Below
> is the list under "Device Drivers" if I do a "make menuconfig":

Recently reported on lkml

Andrew Morton said:
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.18-rc5/2.6.18-rc5-mm1/hot-fixes/
contains a fix for this.

HTH
David

PS on kernel mailing lists do a reply-all and don't trim cc lists :)

-- 
VGER BF report: U 0.500279
