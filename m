From: Jon Lewis <jlewis@lewis.org>
Subject: Re: Two-disk RAID5?
Date: Wed, 26 Apr 2006 13:18:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0604261314060.1846@soloth.lewis.org>
References: <1146069707.10253.50.camel@kenny>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1146069707.10253.50.camel@kenny>
Sender: linux-raid-owner@vger.kernel.org
To: John Rowe <rowe@excc.ex.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 26 Apr 2006, John Rowe wrote:

> I'm about to create a RAID1 file system and a strange thought occurs to
> me: if I create a two-disk RAID5 array then I can grow it later by the
> simple expedient of adding a third disk and hence doubling its size.

No.  When one of the 2 drives in your RAID5 dies, and all you have for 
some blocks is parity info, how will the missing data be reconstructed?

You could [I suspect] create a 2 disk RAID5 in degraded mode (3rd member 
missing), but it'll obviously lack redundancy until you add a 3rd disk, 
which won't add anything to your RAID5 storage capacity.

----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
