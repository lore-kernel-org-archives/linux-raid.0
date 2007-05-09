From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Chaining sg lists for big I/O commands: Question
Date: Wed, 9 May 2007 09:22:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705090918390.12857@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@suse.de
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

http://kerneltrap.org/node/8176

I am a mdadm/disk/hard drive fanatic, I was curious:

> On i386, we can at most fit 256 scatterlist elements into a page,
> and on x86-64 we are stuck with 128. So that puts us somewhere
> between 512kb and 1024kb for a single IO.

How come 32bit is 256 and 64 is only 128?
I am sure it is something very fundamental/simple but I was curious, I 
would think x86_64 would fit/support more scatterlists in a page.

Also, when this patch is implemented for x86_64 and if merged into 
mainline, what does this mean for performance?

I have an mdadm raid5 of 10 raptors and get 434MB/s write and 622MB/s 
read, would I see an increase in performance with this patch?

Justin.

