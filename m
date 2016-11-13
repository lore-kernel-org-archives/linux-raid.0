From: NeilBrown <neilb@suse.com>
Subject: Re: "creative" bio usage in the RAID code
Date: Mon, 14 Nov 2016 09:53:46 +1100
Message-ID: <87vavrj8jp.fsf@notabene.neil.brown.name>
References: <20161110194636.GA32241@infradead.org> <20161111190223.4xrq3vvvvohzgs5e@kernel.org> <20161112174238.GA11518@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161112174238.GA11518@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 13 2016, Christoph Hellwig wrote:

> On Fri, Nov 11, 2016 at 11:02:23AM -0800, Shaohua Li wrote:
>> > It's mostly about the RAID1 and RAID10 code which does a lot of funny
>> > things with the bi_iov_vec and bi_vcnt fields, which we'd prefer that
>> > drivers don't touch.  One example is the r1buf_pool_alloc code,
>> > which I think should simply use bio_clone for the MD_RECOVERY_REQUESTED
>> > case, which would also take care of r1buf_pool_free.  I'm not sure
>> > about all the others cases, as some bits don't fully make sense to me,
>>=20
>> The problem is we use the iov_vec to track the pages allocated. We will =
read
>> data to the pages and write out later for resync. If we add new fields t=
o track
>> the pages in r1bio, we could use standard API bio_kmalloc/bio_add_page a=
nd
>> avoid the tricky parts. This should work for both the resync and writebe=
hind
>> cases.
>
> I don't think we need to track the pages specificly - if we clone
> a bio we share the bio_vec, e.g. for the !MD_RECOVERY_REQUESTED
> we do one bio_kmalloc, then bio_alloc_pages then clone it for the
> others bios.  for MD_RECOVERY_REQUESTED we do a bio_kmalloc +
> bio_alloc_pages for each.

Part of the reason for the oddities in this code is that I wanted a
collection of bios, one per device, which were all the same size.  As
different devices might impose different restrictions on the size of the
bios, I built them carefully, step by step.

Now that those restrictions are gone, we can - as you say - just
allocate a suitably sized bio and then clone it for each device.

>
> While we're at it - I find the way MD_RECOVERY_REQUESTED is used highly
> confusing, and I'm not 100% sure it's correct.  After all we check it
> in r1buf_pool_alloc, which is a mempool alloc callback, so we rely
> on these callbacks being done after the flag has been raise / cleared,
> which makes me bit suspicious, and also question why we even need the
> mempool.

MD_RECOVERY_REQUEST is only set or cleared when no recovery is running.
The ->reconfig_mutex and MD_RECOVERY_RUNNING flags ensure there are no
races there.
The r1buf_pool mempool is created are the start of resync, so at that
time MD_RECOVERY_RUNNING will be stable, and it will remain stable until
after the mempool is freed.

To perform a resync we need a pool of memory buffers.  We don't want to
have to cope with kmalloc failing, but are quite able to cope with
mempool_alloc() blocking.
We probably don't need nearly as many bufs as we allocate (4 is probably
plenty), but having a pool is certainly convenient.

>
>>=20
>> > e.g. why we're trying to do single page I/O out of a bigger bio.
>>=20
>> what's this one?
>
> fix_sync_read_error

The "bigger bio" might cover a large number of sectors.  If there are
media errors, there might be only one sector that is bad.  So we repeat
the read with finer granularity (pages in the current code, though
device block would be ideal) and only recovery bad blocks for individual
pages which are bad and cannot be fixed.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYKO76AAoJEDnsnt1WYoG5CZMP/R6xt+ti1dlBb+j5WYaEseyt
ZBEtvrGkOaY451lXdEyfUDd+ytDeSnT20Vdd4JLp3SOjzVFRkc478Gt4J8hEx9fk
UvLV2Ac77qf8zq0aO4Pj+X04MrqM++UYQEyujj61kiR5bhrn/PMhCnLB06sticnF
id9q8g+WH1HaVtNqhcdp0bNPfbmGUkbpoMRvXRBvIcoyWcVNb4XM4KCVCFrzqeN2
jdIHShSADNOIWYkQTmC/DS/lHm5cSuDyiYt4Jj7FKz9SKa126WYD/KI8pS5nn6XG
2xvXxUNxaKBtLlTwKfeSLa2nDTC0s1hLUHQfm5PpZ3rua8NOqff6UgWQT/SM+9yj
h87p4xFdJT+d7yVUzJwuwuJhXj8rAf8x6+1XFIaBCBOE9bOjjvCh7y2UV+NQCT1X
k1jjc4LidpYtFp9rFbghiGVLC3FMUXzImVqaV7Gqoc2jDsomKPM7skBVwZu8s4XW
x08o3SBtrGVwBUGV+y8h06zJfWTvC+i5vawE+sVfVBl3jeEtPYHuyB5K7VISpxDx
u8du2U1BVt3WFroe62RF8kIXZbN40n0Ri8xwhuzbAvmWH4fj+xXyAnymR3IrIwy3
0BGYgUrmSDkrDBVNUiZd1aOu5YSbKhjFSOfsNOI8CQbXWsyPYo2v4ri0NQuu8L/M
eMGveoZh3vUD6YEuWuBr
=L3PC
-----END PGP SIGNATURE-----
--=-=-=--
