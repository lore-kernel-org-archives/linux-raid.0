From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
Date: Tue, 20 Nov 2012 09:18:24 +1100
Message-ID: <20121120091824.58ed4565@notabene.brown>
References: <20121119120632.1c97e306@notabene.brown>
	<84A937D219C2B44EB8EA44831ACA1E49166C741F@SC-MBX02-3.TheFacebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/./or77N3mka38mJ6uyci_o9"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <84A937D219C2B44EB8EA44831ACA1E49166C741F@SC-MBX02-3.TheFacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <t.figa@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>
List-Id: linux-raid.ids

--Sig_/./or77N3mka38mJ6uyci_o9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Nov 2012 05:22:25 +0000 Dan Williams <djbw@fb.com> wrote:

>=20
>=20
> On 11/18/12 5:06 PM, "NeilBrown" <neilb@suse.de> wrote:
>=20
> >
> >Hi Dan,
> > could you comment on this please?  Would it make sense to arrange for
> >errors
> > to propagate up?  Or should we arrange to do a software-fallback in the
> >dma
> > engine is a problem?  What sort of things can cause error here anyway?
>=20
> Propagating up is missing reliable "dma abort" operation.
>=20
> In these cases the engine failed to complete due to hardware hang / driver
> bug, or has hit a memory error (uncorrectable even with software
> fallback).  This originally should have been using async_tx_quiesce()
> which also does the panic.
>=20
> The engines that I have worked with have either lacked support for
> aborting, or were otherwise unable to recover from a hardware hang.
> However, for engines that do support error recovery they should be able to
> hide the failure from the upper layers.
>

So maybe I could:

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ac09fa4..ffbf0ca 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3268,7 +3268,7 @@ static void handle_stripe_expansion(struct r5conf *co=
nf, struct stripe_head *sh)
 	/* done submitting copies, wait for them to complete */
 	if (tx) {
 		async_tx_ack(tx);
-		dma_wait_for_async_tx(tx);
+		async_tx_quiesce(&tx);
 	}
 }
=20


and then the panic would be somebody else's problem?

I note that handle_stripe_expansion has:

 		async_tx_ack(tx);
		dma_wait_for_async_tx(tx);

while async_tx_quiesce() has:

		if (dma_wait_for_async_tx(*tx) =3D=3D DMA_ERROR)
			panic("DMA_ERROR waiting for transaction\n");
		async_tx_ack(*tx);


i.e. the same two functions called in the reverse order.  Is the order
important?  Is handle_stripe_expansion wrong?   Should the patch I apply
actually be:


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ac09fa4..e51d903 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3266,10 +3266,7 @@ static void handle_stripe_expansion(struct r5conf *c=
onf, struct stripe_head *sh)
=20
 		}
 	/* done submitting copies, wait for them to complete */
-	if (tx) {
-		async_tx_ack(tx);
-		dma_wait_for_async_tx(tx);
-	}
+	async_tx_quiesce(&tx);
 }
=20
 /*


because async_tx_quiesce() does the NULL test too???

Thanks,
NeilBrown


--Sig_/./or77N3mka38mJ6uyci_o9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKqwMDnsnt1WYoG5AQKb8g//VGcrtF6SE62X6xcuHE/SamzcwvjXdy0V
8pBUwoHpw8ul6MEKqgnVYwAKUpJHdMCwhjv6Ryshx940/q80E3kclgZbm7Hupr/f
h9OuFnpwhbYU53Qk/Q8WvEP/2vI2qHokKjblREUwQjekDqtSNsy34DaC24qUeBnR
btux4i9nzoxt9AlE4nKab5O1IR9II/onVuYKdGnOdL6ym78A5DGoHqDUZFIQpqHb
Vxm6SW0vvXv91hD42jh+gBLpcmq1+eWh1kbnOh0FQVqVMqk/fH+WY1yR59ZFHcZS
9L6OX3aAwrEar0r5xrZJoRk2yvv3p5rJ5rRE+F7sExgKUkmpThUbqpPMBbdSJgDL
+4Gel6/QI6j+cGGxafOlbrEBo2ainLnPwAr89GbBxmdnSrpRGU2wHYPob3wajw4A
lm7QzjJ9GV4CnVlHTvOqUxzvgA8FuJNFNL/2KgUHWoz9h2bPJ+01VTkJDwxHdzfq
2aN/Ez5SKpTXICWplugsoMmeL244OJon+CrK5gNfidZR6x7M6xshJ7rNY31OMetS
vOzhEDblYtkzXmjVAAdyoP9EVftNHI7jkQYao2frr6YJWqlUvDgpznZNGGl6CC2q
AtwQiN7anOeb1DBGlwvhVKRDhOL1CwkUiJ/LHfNzHhsXTzFK3vycSDLc9XyJv+nw
CjnscqWZqlw=
=j44Z
-----END PGP SIGNATURE-----

--Sig_/./or77N3mka38mJ6uyci_o9--
