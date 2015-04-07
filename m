From: NeilBrown <neilb@suse.de>
Subject: Re: write barrier in RAID5
Date: Tue, 7 Apr 2015 11:25:14 +1000
Message-ID: <20150407112514.77f96bc1@notabene.brown>
References: <551C37E6.6090201@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6SoCYaPT/_P/SGr85MxHzjG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <551C37E6.6090201@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Mei <meijia@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6SoCYaPT/_P/SGr85MxHzjG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 01 Apr 2015 12:24:38 -0600 Eric Mei <meijia@gmail.com> wrote:

> I can see how FUA is handled, but REQ_FLUSH seems problematic. My=20
> understanding of REQ_FLUSH semantics: all requests before the flush=20
> request must *complete* before the flush request complete. For IO remap=20
> layer like MD, we need to guarantee all previous requests are=20
> *submitted* to component devices before submitting the flush request. Is=
=20
> that correct?

No.

See Documentation/block/writeback_cache_control.txt

Only "previously completed" requests are affect by REQ_FLUSH.

So any code using REQ_FLUSH must first wait for previous requests to
complete, and then submit REQ_FLUSH.  The REQ_FLUSH will not return until t=
he
data written by those requests is actually in stable storage, rather than
write-behind cache.

NeilBrown


>=20
> If so why I don't see the code which make sure the pending write=20
> requests in stripe cache are processed & submitted before=20
> submit_flushes() get called? Thanks
>=20
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/6SoCYaPT/_P/SGr85MxHzjG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSMx+jnsnt1WYoG5AQL2rBAAtKCtUP7hBO8OJt5dcWLcCJKkTAYvW2EC
L2pSQyi2KI6IsKmPlqn8u5xI8QpA7WGRRX45Zu9jltYjaQoGcELFwiv5aT6NkDHW
Yj8a9ii5xh/ktWyxyulhI1YLvJUegJpQFfHbCuo1APdQnml3z0B3iFjyzP7lDoSc
2HI/GPXawUNQqZWV4C0DS8Mg/cMkoGm57z4KeA+zxdl2A5ThEP8Mfv7d6aYz7px9
6BEpJ5wRpTD4O7Ub+gKo2J5XeB0S02faJbqGVAEEGlXX+Oh35DhJKndDthsxjmLx
V854YhI3wCSvdNYcb8nLF3ctX80+99CQ1Y6zHJuPua0mkVHZgSx0kY+S/A20aCZv
wP56s+Ggl4lhjTFE045Aj4L3mM+M+b5RjnzcAVTAIiqpd9eGAZokK5hvw+KkyVh/
Vra4FVMHOELtAelU4NGu5trZur2cNMTo6mbRtziVJzVxxCAcGp9lcafA4CSu75WW
HDNU3jIo7RQjRzjT+Swul2Qhfuys49umzUaroHfspGqAfiLvK/YxhduVn3cbpuHa
G+6t27N3Jc7JVNifB9vr7hvKjWtH0diIP7vg/ZfoHhDSBTj58eBEg2SFz/vs167Y
9IUMqGXL5Fp57CnkhrQ4hNa8P8fPRnMwtIJsE2qgD2rgQ/le4wpAVgQlP+oRQHc8
lCaFi0FrSZA=
=T6PD
-----END PGP SIGNATURE-----

--Sig_/6SoCYaPT/_P/SGr85MxHzjG--
