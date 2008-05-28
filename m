From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
Date: Wed, 28 May 2008 07:05:02 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805280703400.23383@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <483D39D3.4020906@rabbit.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <483D39D3.4020906@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids



On Wed, 28 May 2008, Peter Rabbitson wrote:

> Justin Piszcz wrote:
>> Hardware:
>> 
>> 1. Utilized (6) 400 gigabyte sata hard drives.
>> 2. Everything is on PCI-e (965 chipset & a 2port sata card)
>> 
>> Used the following 'optimizations' for all tests.
>> 
>> # Set read-ahead.
>> echo "Setting read-ahead to 64 MiB for /dev/md3"
>> blockdev --setra 65536 /dev/md3
>
> That's actually 65k x 512byte blocks so 32MiB
Ah whoops, thanks!

> Results are meaningless without a crucial detail - what was the chunk size 
> used during array creation time? Otherwise interesting test :)
Indeed, the chunk size used was 256 KiB for all tests.

Justin.

