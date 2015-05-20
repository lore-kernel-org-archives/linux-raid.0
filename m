From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v3 10/11] md/raid10: make sync_request_write() call
 bio_copy_data()
Date: Wed, 20 May 2015 13:09:24 +1000
Message-ID: <20150520130924.14b7dc48@notabene.brown>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org>
	<1430980461-5235-11-git-send-email-mlin@kernel.org>
	<20150519084551.GB374@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Bn7PlL0L14jacyruA2kJKYx"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150519084551.GB374@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lin <mlin@kernel.org>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Bn7PlL0L14jacyruA2kJKYx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 May 2015 10:45:51 +0200 Christoph Hellwig <hch@lst.de> wrote:

> This seems fine even without the rest of the series.  Jens or Neil,
> can you pick this one up?
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Seems reasonable.  I've queued it.  Should appear in -next in a few days.

Thanks,
NeilBrown


--Sig_/Bn7PlL0L14jacyruA2kJKYx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVv65Tnsnt1WYoG5AQKEhxAAm0tJKcMly8a4chKUAT4DGO4BQRu4Bg3x
PBnln/e/Tt4j+ZP72aAEO3wubTLbqPstMz1HfsE3qHcp/NsLIhE0I/jWhbHd1sJ9
DmgJ81utoRDHPJ2AoDuGSm94zwMx4CxnEYaRLMVGni5JDIBf/9HobZt8X5A8NqGk
TvrP+LRSBeyuq/umZYm/iEtlYN6Pc8DAAf3SUgswwgF+Q/mzQmhnLleEw3TxmKgT
TjTZo5csFLNapNVhUpgX5Qw/+AvN24YedCs7N6fROps5n8OhTCiQaEvohxE/pdXh
liNU6rtWGrYdFeHG2tSAdKeV59qDIVNDNNmP2OxZrylLp4kBMVb45hQZxCpBOyI2
qtleTNmu9aHXy4IylasP2C/oeUlBPRfvXXXxF/RTou/2AMAD7v5NbX5xXptbc+YZ
RJZwQZuOsJclWiJXEokUSGXpMJty6lhgd5ruV23fV+C+bBO4SH9w6mg/pzdJ6GH6
NM5oZiDtmwhzj9726Yox4hE5z051BRZH1ZWsM/BsH32QwT/WctH64QEFjQ+yW0Z8
AutWWs8uY+HFNmdpSSDAKm/msH2t/UvhIdQIEgNqYEtxZCsbV6HARB/GSKWvkMh6
eQGkix3mnMI0S8ODIfHlET1K2yocmmdwKyQp6daQEM6V/Ecy5lAD539Qt9X8gEk7
Thd1p7PXlTg=
=/1FT
-----END PGP SIGNATURE-----

--Sig_/Bn7PlL0L14jacyruA2kJKYx--
