From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] Consider user space generated checksum
Date: Fri, 6 Aug 2004 15:13:56 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16659.5012.707524.48026@cse.unsw.edu.au>
References: <1089734056.3065.97.camel@star2.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Tran on  July 13
To: Mike Tran <mhtran@us.ibm.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On  July 13, mhtran@us.ibm.com wrote:
> On alpha systems, the kernel computed checksum, csum_partial(), and user
> space computed checksum are different.  As a consequence, the kernel MD
> driver aborts detection of MD superblock.  This means running mdadm
> --assemble -f or -U summaries will not always work.

Weird... arch/alpha/checksum.c seem to do a 16 bit checksum rather
than the 32bit csum that i386 does.  It's mostly used for network code
and IP uses 16bit csum, but it is odd that it claims to return a 32
bit  number, but really it will always be 16bit...

> 
> I have been wondering... Should MD driver use csum_partial() at all?

Well, as we seem to want a 32bit checksum, I guess we cannot.  But for
historical reasons, we probably have to.

I guess a patch much like yours is needed.  I'll add something to make
sure version-1 superblock are a bit more predictable.

NeilBrown
