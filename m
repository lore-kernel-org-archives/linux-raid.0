From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Chaining sg lists for big I/O commands: Question
Date: Thu, 10 May 2007 20:41:05 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705102040090.6426@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0705090918390.12857@p34.internal.lan>
 <20070509133830.GV4163@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070509133830.GV4163@kernel.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

On May 9 2007 15:38, Jens Axboe wrote:
>> I am a mdadm/disk/hard drive fanatic, I was curious:
>> 
>> >On i386, we can at most fit 256 scatterlist elements into a page,
>> >and on x86-64 we are stuck with 128. So that puts us somewhere
>> >between 512kb and 1024kb for a single IO.
>> 
>> How come 32bit is 256 and 64 is only 128?
>>
>> I am sure it is something very fundamental/simple but I was curious, I 
>> would think x86_64 would fit/support more scatterlists in a page.
>
>Because of the size of the scatterlist structure. As pointers are bigger
>on 64-bit archs, the scatterlist structure ends up being bigger. The
>page size on x86-64 is 4kb, hence the number of structures you can fit
>in a page is smaller.

I take it this problem "goes away" on arches with 8KB page_size?


	Jan
-- 
