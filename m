From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: if (stripe_cache_size =< chunk_size) { BUG() }
Date: Tue, 26 Jun 2007 07:20:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706260704050.6396@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you set the stripe_cache_size less than or equal to the chunk size of 
the SW RAID5 array, the processes will hang in D-state indefinitely until 
you change the stripe_cache_size to > chunk_size.

Tested with 2.6.22-rc6 and a 128 KiB RAID5 Chunk Size, when I set it to 
256 KiB, no problems.  128 KiB and below cause issues.

Justin.
