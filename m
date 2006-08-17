From: Neil Brown <neilb@suse.de>
Subject: Re: remark and RFC
Date: Thu, 17 Aug 2006 11:11:44 +1000
Message-ID: <17635.49745.179198.975962@cse.unsw.edu.au>
References: <200608160906.k7G96A204753@inv.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Wednesday August 16
Sender: linux-raid-owner@vger.kernel.org
To: ptb@inv.it.uc3m.es
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday August 16, ptb@inv.it.uc3m.es wrote:
> 
> So,
> 
> 1) I would like raid request retries to be done with exponential
>    delays, so that we get a chance to overcome network brownouts.
> 
> 2) I would like some channel of communication to be available
>    with raid that devices can use to say that they are
>    OK and would they please be reinserted in the array.
> 
> The latter is the RFC thing (I presume the former will either not
> be objectionable or Neil will say "there's no need since you're wrong
> about the way raid does retries anyway").

There's no need since you're ..... you know the rest :-)
Well, sort of.

When md/raid1 gets a read error it immediately retries the request in
small (page size) chunks to find out exactly where the error is (it
does this even if the original read request is only one page).
When it hits a read error during retry, it reads from another device
(if it can find one that works) and writes what it got out to the
'faulty' drive (or drives).  If this works: great.
If not, the write error causes the drive to be kicked.
I'm not interested in putting any delays in there.  It is simply the
wrong place to put them.  If network brownouts might be a problem,
then the network driver gets to care about that.

Point 2 should be done in user-space.  
  - notice device have been ejected from array
  - discover why. act accordingly.
  - if/when it seems to be working again, add it back into the array. 

I don't see any need for this to be done in the kernel.


> 
> The way the old FR1/5 code worked was to make available a couple of
> ioctls.
> 
> When a device got inserted in an array, the raid code told the device
> via a special ioctl it assumed the device had that it was now in an
> array (this triggers special behaviours, such as deliberately becoming
> more error-prone and less blocky, on the assumption that we have got
> good comms with raid and can manage our own raid state). Ditto
> removal.

A bit like BIO_RW_FASTFAIL?  Possibly md could make more use of that.
I haven't given it any serious thought yet.  I don't even know what
low level devices recognise it or what they do in response.

NeilBrown
