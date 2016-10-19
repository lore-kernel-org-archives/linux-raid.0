From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v5 7/8] md/r5cache: r5c recovery
Date: Wed, 19 Oct 2016 13:32:48 +1100
Message-ID: <87inspxe3z.fsf@notabene.neil.brown.name>
References: <20161013054944.1038806-1-songliubraving@fb.com> <20161013054944.1038806-8-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161013054944.1038806-8-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Oct 13 2016, Song Liu wrote:

> This is the recovery part of raid5-cache.
>
> With cache feature, there are 2 different scenarios of recovery:
> 1. Data-Parity stripe: a stripe with complete parity in journal.
> 2. Data-Only stripe: a stripe with only data in journal (or partial
>    parity).
>
> The code differentiate Data-Parity stripe from Data-Only stripe with
> flag (STRIPE_R5C_WRITTEN).
>
> For Data-Parity stripes, we use the same procedure as raid5 journal,
> where all the data and parity are replayed to the RAID devices.
>
> For Data-Only strips, we need to finish complete calculate parity and
> finish the full reconstruct write or RMW write. For simplicity, in
> the recovery, we load the stripe to stripe cache. Once the array is
> started, the stripe cache state machine will handle these stripes
> through normal write path.
>
> r5c_recovery_flush_log contains the main procedure of recovery. The
> recovery code first scans through the journal and loads data to
> stripe cache. The code keeps tracks of all these stripes in a list
> (use sh->lru and ctx->cached_list), stripes in the list are
> organized in the order of its first appearance on the journal.
> During the scan, the recovery code assesses each stripe as
> Data-Parity or Data-Only.
>
> During scan, the array may run out of stripe cache. In these cases,
> the recovery code will also call raid5_set_cache_size to increase
> stripe cache size.

What if this fails.  Maybe the array was created on a machine with lots
or memory, but that machine died and you are trying to recovery you data
on a much less capable machine.

I don't think there is an easy answer, but at least you need to fail
gracefully.

I'll try to look at the rest tomorrow.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYBttQAAoJEDnsnt1WYoG5oE4QALhfm5+3rP7Ac9pZMwl9iJI8
8Kpu0MVFl2SNIUZn/YJgnpziC3aEiJbpx2ZuOzcluN+Rp6PSSgCFDVjpSLOgsb35
8jNEaQLRqTawT44anxlJfMSdqAlkIMi6knGTU8pNwiUZ0ZYmbpp4LRWc4UYxN68W
tp8hovYhAenvoo6F5xgl16T+Icja5nLL5BUwy6rr6HIaulWrNF5pgOqEjGrqJlPw
iduMgNSm7sZueYnTdybeBnKsa3J+SSqLZxAUwffDPq8HgFt819OexL4125XUBEt+
lnHQy00jJ57FwNIcHWzBHYemKSbNtMNZZzrgOvkCfFlgH2yRhBLVXDmodFPNLHQO
NmV3P1owKOOZE0Zm9EU1Hzmr6YHJonc5ghJ3KUPEm4BMSZChehSHR+hsZKbq8xPJ
My4CPaxuTeHxA6F7yz0JLxu8SqtqzD69T+U/7PC57bp+RtAX/c2bvDzWS0wn7Ysu
I0HLKn5+HpyVsI8201cBhFU3F+zoRtESU4JzjJJLluhKIg+SpD95+R8Rnt3GNRMV
4tLqApbXVLu/NaQxc41Vs0kIhF3XxGZPNbNJmghRfRir8iTT8/ihpO5jD1n70Prr
xlEpAFQ/x+6tCPT8lX1qvgcH9x2XucWOYRQ/OH7WN+JnTc4/WwnOG3E5h6gYN5lX
5FogaJHWLnjZNBnnOCdv
=US/J
-----END PGP SIGNATURE-----
--=-=-=--
