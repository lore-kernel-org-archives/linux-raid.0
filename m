From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Linux 2.6.10 / RAID1 problem
Date: Thu, 6 Jan 2005 09:35:40 +1100
Message-ID: <16860.27580.73601.462427@cse.unsw.edu.au>
References: <41DC515C.7030208@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sven Anders on Wednesday January 5
Sender: linux-raid-owner@vger.kernel.org
To: Sven Anders <anders@anduras.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 5, anders@anduras.de wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hello!
> 
> I'm expirencing strange problems on my server running Software RAID1 (Mirroring) under
> the Linux kernel 2.6.10. It works nicely under Linux 2.4.18!

Why do you think it is a raid problem rather than an ext3 problem?

....
> Test case:
> ~ dd if=/dev/zero of=test0 bs=1M count=300
> ~ while :; do cp test0 test1; cp test1 test2; cp test2 test0; od test0; done
> 
> Error:
> ~ On Linux 2.4.18 it worked serveral hours perfectly (until I stopped it...)
> ~ On Linux 2.6.10 after some minutes the following (or similar) error occures:
> 
> 
> EXT3-fs error (device md5): ext3_free_blocks_sb: bit already cleared for block 1303980
> Aborting journal on device md5.
> ext3_abort called.
.....
> 
> 
> Does anybody have an idea?
> What's the cause of this???

No (not me at least).
Are you able to run the same test on a single unraided drive?

> 
> Is there an known bug in the 2.6.10?
> Is the Software RAID in the 2.6 series stable?

I am not aware of any significant problems with Software RAID in
2.6.10.

> 
> Any special kernel compile options not to use when using RAID?

No.

> Any other (better) test to do?

As above, try without raid. 
If the problem goes away, come back here and report that fact.
If it doesn't report it to the ext3 mailing list, or to linux-kernel.

NeilBrown
