From: NeilBrown <neilb@suse.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Mon, 12 Dec 2016 11:59:07 +1100
Message-ID: <87a8c20xpg.fsf@notabene.neil.brown.name>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>
Cc: Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Nov 26 2016, Jinpu Wang wrote:
> [  810.270860]  [<ffffffff813fc851>] blk_prologue_bio+0x91/0xc0

What is this?  I cannot find that function in the upstream kernel.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhN9lwACgkQOeye3VZi
gbnyPxAAgoUyAXDc9DmU2lTbHBqi9ix3wkZlDYbf6WZb/svE+ti9Y45BF+aetkua
fo4ZoOKq2wLaru4ocUbyexyiPg0L8H+HsOhqqvXoxdqAuo0gwwdzYHysRzGrWKok
Sf+aiiM5LCwMdqlnnZb6S85oHYDBs4UZFJzP52s1I9/AC+oh+EZfNNSHX4c7GCP5
DzGyLyvP8Vrz91EwT+XTuCUwYy1UMwoRykdk/a/oaYiuNtQNHt74c4NPunU4LnPD
GoZ6Nh+CwWh8/k+7gd/cN4Ka+08ngcrGzl4QKc5uPQwTr23/ILAPEiwGuLPRtL10
zKu/stLZdGlXg79EZk2s05y98z06uoi3R97JUCpsnxS53tBJapSDKD0qzmkjEOl9
DWjDazumRL6QcLB8E2J9gHLVooNTC1bzfNZtL20Sywznj58Oeu4/bHeQRfLNOGxo
l9dzvMy7sgC7mzgNpsdJaJL+cg9nEtv/wIajJu+XZrYUBQ6wcqgRTLvSj/9m98Tj
fUC+xGoMh/XH9aTB4HQk3lUGDR1fa1jc4qVVwwpDhnS9QAJfFrIupnWXA0mQvIYy
CjCdIH2NRnDElwwKTLitTDv7M08Pe4UQawvxER8cSdqKPjmeM0ffg2DihrkxeqrM
+oTq3QZYFIfJKYpyiuUAa72Q+ubJcVr1IvFToTJJSoUR3pgqw0c=
=5PQC
-----END PGP SIGNATURE-----
--=-=-=--
