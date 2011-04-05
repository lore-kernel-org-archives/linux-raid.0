From: NeilBrown <neilb@suse.de>
Subject: Re: What the heck happened to my array?
Date: Tue, 5 Apr 2011 21:31:11 +1000
Message-ID: <20110405213111.3dceae00@notabene.brown>
References: <4D9876E4.6080501@fnarfbargle.com>
	<AANLkTi=2GNYdySbCDXmaDC8-8vF8GU9V3Uoy1qByNq58@mail.gmail.com>
	<4D995E27.3060800@fnarfbargle.com>
	<BANLkTi=prv_vzfJr2JJt3LLhdB0GFSMy4w@mail.gmail.com>
	<4D9A6694.4040606@fnarfbargle.com>
	<20110405161043.00d54901@notabene.brown>
	<4D9ADAB3.7040205@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D9ADAB3.7040205@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 05 Apr 2011 17:02:43 +0800 Brad Campbell <lists2009@fnarfbargle.com>
wrote:

> Well, luckily I preserved the entire build tree then. I was planning on 
> running nm over the binary and have a two thumbs type of look into it 
> with gdb, but seeing as you probably have a much better idea what you 
> are looking for I'll just send you the binary!

Thanks.  It took me a little while, but I've found the problem.

The code was failing at 
			wd0 = sources[z][d];
in qsyndrome in restripe.c.
It is looking up 'd' in 'sources[z]' and having problems.
The error address (from dmesg) is 0x7f2000 so it isn't a
NULL pointer, but rather it is falling off the end of an allocation.

When doing qsyndrome calculations we often need a block full of zeros, so
restripe.c allocates one and stores it in in a global pointer.

You were restriping from 512K to 64K chunk size.

The first thing restripe.c was called on to do was to restore data from the
backup file into the array.  This uses the new chunk size - 64K.  So the
'zero' buffer was allocated at 64K and cleared.


The next thing it does is read the next section of the array and write it to
the backup.  As the array was missing 2 devices it needed to do a qsyndrome
calculation to get the missing data block(s).  This was a calculation done on
old-style chunks so it needed a 512K zero block.
However as a zero block had already been allocated it didn't bother to
allocate another one.  It just used what it had, which was too small.
So it fell off the end and got the result we saw.

I don't know why this works in 3.2.1 where it didn't work in 3.1.4.

However when it successfully recovers from the backup it should update the
metadata so that it knows it has successfully recovered and doesn't need to
recover any more.  So maybe the time it worked, it found there wasn't any
recovery needed and so didn't allocate a 'zero' buffer until it was working
with the old, bigger, chunk size.

Anyway, this is easy to fix which I will do.

It only affects restarting a reshape of a double-degraded RAID6 which reduced
the chunksize.

Thanks,
NeilBrown
