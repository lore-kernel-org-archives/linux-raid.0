From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V3] md: move bitmap_destroy before __md_stop
Date: Fri, 10 Mar 2017 13:12:20 +1100
Message-ID: <87h931hocb.fsf@notabene.neil.brown.name>
References: <1488940292-8555-1-git-send-email-gqjiang@suse.com> <20170309182443.c3th4di2v3kct7eu@kernel.org> <87k27ygdj6.fsf@notabene.neil.brown.name> <20170310010604.lpyhnmnlcy5w3xmi@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170310010604.lpyhnmnlcy5w3xmi@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org, shli@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 09 2017, Shaohua Li wrote:

> On Fri, Mar 10, 2017 at 11:51:09AM +1100, Neil Brown wrote:
>> On Thu, Mar 09 2017, Shaohua Li wrote:
....
>> > I think it's ok to add this part into bitmap_destroy, as we need to ca=
ll
>> > bitmap_destroy before mddev_detach. Look at the usage of mddev_detach,=
 at in
>> > one place (level_store()), we wait for the IO without bitmap_destroy. =
I think
>> > we should keep this part code in mddev_detach. Maybe create a small fu=
nction,
>> > let both mddev_detach and bitmap_destroy call it.
>>=20
>> I don't think level_store() needs to explicitly wait for behind io.
>> It calls mddev_suspend(), which calls the ->quiesce function in the
>> personality, which is responsible for waiting for all pending IO,
>> including behind.  raid1.c does this correctly.
>
> Can you elaborate Where >quiesce waits for behind IO in raid1? It's not
> obvious. It really should though.

Ahh - you are correct.
allow_barrier() is called by call_bio_endio(), which can be called
before behind-writes complete.

My bi_phys_segments series actually fixed that, by counting every write
request in nr_pending so that nr_pending wouldn't drop to zero until all
the writes had completed.

We should probably come up with a simple fix for -stable.

Unfortunately it doesn't look at all easy.
I'll revisit my bi_phys_segments series next week and try to sort out
the best way to fix this issue.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljCC4QACgkQOeye3VZi
gbnQfhAAphTZO+Bw/dvuxDs2CRdyp9GiwPEqhE2sJwd8cKReaHSnUFJBANwzXRjO
hM8WD/h66FgD0iDiJy5gjS7SvFbQGKoNr4uYDXHAw8oaz9siWWIC2DKCwLs15YY1
Pf1ZZFgvHAIuR1ILBJShjFgsrnYDRKphIQgEgTk4RaH9LTNkqGMNOQ9HZEmQqCx3
2NMSqukC1/IM16ZD+4rX6fqoeE+yhImUYuVRotz9jJvzNLvxU/i+qRnT9glAtgzX
A2g8UNZKSNvsMYC5GKmFoGSmH5w2azuFGkjeGdNKZHShlf7duQ7NOYfxb42MMRAq
Is6ZqjdxFmtdLHZVCjtjHVY4bo94lBKNNrkAFdckHa0cmQH1bUtd61Un+3ge87T2
Sd4NcpdgI8VVFoJTwuK3XRvqkaX3GeL5bwnmrHj0RMAOB/kMmhyJ6IHTxmWzEX7L
N5conetDMeg7dv61I05R38F4sGWHcA/N5M6Asr3n1K10EhfcKxWjbvx6yeoL6Pdj
7LiqdsWNx5ZLLekRaqk5PED9vuxPpBvXmVpGQxXFdTjzVCbU2IPI9cZHdrwfy2+z
D8usdUjmDK6p8u6GOhQNNMOCwrKB63HU+hEvfVoJFzvz1RY8bbgjFrGjwrwClKla
eDq+xFRqeaIpyxhwogDrAw8XBaghpm1OySXE9jeui9NAP5D2Ru8=
=YqMi
-----END PGP SIGNATURE-----
--=-=-=--
