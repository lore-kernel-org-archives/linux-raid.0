From: "NeilBrown" <neilb@suse.de>
Subject: Re: MD write performance issue - found Catalyst patches
Date: Mon, 19 Oct 2009 09:39:04 +1100
Message-ID: <58e9f79e43e947130a1af549c1de448b.squirrel@neil.brown.name>
References: <66781b10910180300j2006a4b7q21444bb27dd9434e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10910180300j2006a4b7q21444bb27dd9434e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Mattias =?iso-8859-1?Q?Hellstr=F6m?= <hellstrom.mattias@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, October 18, 2009 9:00 pm, mark delfman wrote:
> We have tracked the performance drop to the attached two commits in
> 2.6.28.6.    The performance never fully recovers in later kernels so
> I presuming that the change in the write cache is still affecting MD
> today.
>
> The problem for us is that although we have slowly tracked it down, w=
e
> have no understanding of linux at this level and simply wouldn=92t kn=
ow
> where go from this point.
>
> Considering this seems to only effect MD and not hardware based RAID
> (in our tests) I thought that this would be an appropriate place to
> post these patches and findings.
>
> There are 2 patches which impact MD performance via a filesystem:
>
> a) commit 66c85494570396661479ba51e17964b2c82b6f39 - write-back: fix
> nr_to_write counter
> b) commit fa76ac6cbeb58256cf7de97a75d5d7f838a80b32 - Fix page
> writeback thinko, causing Berkeley DB slowdown
>
>
> 1) no patches applied into 2.6.28.5 kernel: write speed is 1.1 GB/s v=
ia
> xfs
> 2) both patches are applied into 2.6.28.5 kernel: xfs drops to circa:
> 680 MB/s (like in kernel 2.6.28.6 and later)
> 3) put only one patch: 66c85494570396661479ba51e17964b2c82b6f39
> (write-back: fix nr_to_write counter) - performance goes down to circ=
a
> 780 MB/s
> 4) put only one patch: fa76ac6cbeb58256cf7de97a75d5d7f838a80b32 (Fix
> page writeback thinko) - the performance is good: 1.1 GB/s (on XFS)
>
> change log for 28.6
> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.28.6
>
>
> Hopefully this helps to resolve this....

Hopefully it will...
Thanks for tracking this down.  It is certainly easier to work out what
is happening when you have a small patch that makes the difference.

I'll see what I (or others) can discover.

Thanks,
NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
