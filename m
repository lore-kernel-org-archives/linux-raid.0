From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [BUG/PATCH] md bitmap broken on big endian machines
Date: Fri, 29 Sep 2006 11:03:11 +0400
Message-ID: <451CC52F.9080400@tls.msk.ru>
References: <4512F55D.5030907@steeleye.com> <17691.27892.571457.628971@cse.unsw.edu.au> <451C4814.9030601@tls.msk.ru> <451C6D64.5050807@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <451C6D64.5050807@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:
> Michael Tokarev wrote:
>> Neil Brown wrote:
> 
>>> ffs is closer, but takes an 'int' and we have a 'unsigned long'.
>>> So use ffz(~X) to convert a chunksize into a chunkshift.
>>
>> So we don't use ffs(int) for an unsigned value because of int vs
>> unsigned int, but we use ffz() with negated UNSIGNED.  Looks even
>> more broken to me, even if it happens to work correctly... ;)
> 
> No, it doesn't matter about the signedness, these are just bit
> operations. The problem is the size (int vs. long), even though in
> practice it's very unlikely you'd ever have a bitmap chunk size that
> exceeded 32 bits. But it's better to be correct and not have to worry
> about it.

I understand the point, in the first place (I didn't mentioned long
vs int above, however).  The thing is: when reading the code, it looks
just plain wrong.  Esp. since function prototypes aren't here, but for
those ffs(), ffz() etc they're hidden somewhere in include/asm/* (as
they're architecture-dependent), and it's not at all obvious which is
signed and which is unsigned, which is long or int etc.

At the very least, return -ENOCOMMENT :)

/mjt
