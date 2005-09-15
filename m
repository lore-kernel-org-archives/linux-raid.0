From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Implementing Encryption and Decryption in Raid Device Driver.
Date: Thu, 15 Sep 2005 11:44:32 +0000
Message-ID: <62b0912f0509150444122d95c6@mail.gmail.com>
References: <62b0912f050914123756d1f3d@mail.gmail.com>
	 <20050915073118.61198.qmail@web54703.mail.yahoo.com>
Reply-To: molle.bestefich@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050915073118.61198.qmail@web54703.mail.yahoo.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: vinnakota chaitanya <chaitanyaa_v@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

vinnakota chaitanya wrote:
> Molle Bestefich wrote:
> > Use loop-aes, it's absolutely fabulous.
> > 
> > It works great with 2.4 as well as 2.6.
> > 
> > Instructions here.
> > http://loop-aes.sourceforge.net/loop-AES.README
> 
> Thanks for the suggestion. 
> Now I've the following two issues:
> 
> 1. The target device is fat filesystem formatted. The
> target kernel image do not contain the fat filesystem
> module. The target device [ i.e. /dev/md0 ]   is
> mounted by the host through USB interface. Hence, in
> this case the host's fat filesystem code is used.
> 	Will loop-aes work in this situation.

Loop-aes functions as a loop device.  It reads and writes encrypted
data to/from either a file or a block device such as /dev/md0 in your
case.  In the other end it gives you a block device, we'll call it
/dev/loop0, from which you can read/write your unencrypted data.

Loop-aes does not care which filesystems you stick on /dev/loop0, and
it does not care whether your kernel happens to be able to understand
and mount those filesystems.

I'm curious.  How does your "target device" export the /dev/loop0 to
the "host device" through USB?


> 2. We were asked to use blow_fish algorithm instead.
> So, how to go about it, are there any modules like
> loop-aes or should I  consider the hooks
>  raid5_make_request and raid5_end_read_request 
> for encryption and decryption

I would without a doubt spare myself the trouble and just use
loop-aes.  As I've said, it's great.

But feel free to implement your own solution.  I can't give any
recommendations on how.  You might want to check out twofish, in which
Mr. Schneier et al has fixed "a security problem" of some sort.  Not
sure which.  Presumably Wikipedia or Google knows.
