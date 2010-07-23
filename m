From: Chris Farey <chris@farey.org>
Subject: Stripe Cache
Date: Fri, 23 Jul 2010 15:54:56 +0100
Message-ID: <4C49AD40.2020606@farey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm working on an application which requires a large datastore (10-100s 
GB) stored on a Linux RAID 5 array, and I'd like to understand the 
performance implications of making the datastore a logical volume versus 
having it a file on an ext3 file system. If it was an LV I'd probably  
be opening it O_DIRECT and using Linux aio to access it. In particular, 
I'd like to understand how this interacts with the stripe cache, versus 
having it a file and going via the buffer cache. I've searched around 
the web, but been unable to find any good description of how the stripe 
cache works.

I assume the stripe cache is primarily there to enable full stripe 
writes.  If I use an LV and do a write which ends up being a partial 
stripe, what happens? I presume it allocates a stripe buffer. Does it 
then do a copy, or does it just increase a reference count to the buffer 
passed to it? At some point the stripe cache must be flushed, and the 
unmodified part of the stripe must be read to re-calculate the parity. 
Is this done at the time the stripe is flushed, or is there some form of 
pre-read?

Alternatively, if I use a file and go through the buffer cache, how does 
the stripe cache relate to the buffer cache? When the file system 
flushes buffers which correspond to partial stripes, do they get copied 
to the stripe cache, or do the buffers just get referenced by the stripe 
cache? And again, when is the remainder of the stripe read so that 
parity can be recalculated?

How about reads? Looking at stripe_cache_active when doing sequential 
reads, it appears to be active. So if I do a partial stripe read, does 
it actually read the entire stripe in, on the off-chance that I'm going 
to read more of it (or perhaps write to it)?

Any help understanding this would be greatly appreciated.

Chris
