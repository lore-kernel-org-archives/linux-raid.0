From: Spelic <spelic@shiftmail.org>
Subject: raid10 speed drops significantly on large chunks
Date: Wed, 24 Nov 2010 01:22:49 +0100
Message-ID: <4CEC5AD9.4030708@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi there
I'm doing some testing on raid10 layouts and chunksizes.

I am checking chunksizes 128, 1024 and 8192, on a 6-disk array.
On streaming read / streaming write (dd bs=1M from/to /dev/zero 
/dev/null) the speed of 128 and 1024 on my hardware is around 270MB/sec 
writes (all layouts) and 280MB/sec(near)--450MB/sec(far) read speed.

But when I try chunksize 8192 speed drops significantly and I have 
231(near)--175(far) write speed and 205(near)--323(far) read speed.

I tried the kitchen sink on settings... but there's no way to bring 8192 
speed up to the others. I tried raising nr_requests on all the drives up 
by a factor 16, changing schedulers, raising deadline scheduler 
expirations, readahead on drives... no way.

This surprises me... what could be the reason? In particular on a near 
layout I can't see what could be wrong with a big chunksize.
I suspect the situation would have gone worse if I went further up with 
the chunksize.

There is plenty of free RAM (8GB free).

Thanks for your insights
