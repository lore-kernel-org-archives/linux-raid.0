From: NeilBrown <nfbrown@novell.com>
Subject: Re: [RFC 5/5] r5cache: naive reclaim approach
Date: Wed, 01 Jun 2016 13:16:37 +1000
Message-ID: <87wpm9r42y.fsf@notabene.neil.brown.name>
References: <1464326983-3798454-1-git-send-email-songliubraving@fb.com> <1464326983-3798454-6-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1464326983-3798454-6-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, May 27 2016, Song Liu wrote:

> +	sector_t end = -1L;

Please use "MaxSector", not "-1L".
sector_t might be "long long" so -1L might be wrong.

(I haven't looked at much else in this patch)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXTlOVAAoJEDnsnt1WYoG5/HkP/2nO+uHteITWfI5q763cWyYi
eUX5b+jjNn+RwLNFDgNWFpc1a+u2TCJnV4phjTNacctGl1+VRlCVj1nUK37Ele3B
z9ylan8YNseSBQcXBB4h76VZ8pG7cdDG1KdY85htZV+R7ywqV0l/vj+uTI+sIBBy
z6a//5FQdQunF0tSDpV3WxYCOkGJfYj607ctgR+QNZRVOV2KL+VAx/7l+ef/leoQ
lDL5+DrpWLNgb3Afj78VsbkU/XY9LhEnThjnpKpPa7dlnGMOKetxrLvGhS7K+Nwa
jHPk6WpLMJn+rV/DOAzbHAnhzujFLFvtkrtnV1r1uyPicl5HFiE+VW9M76kbRCHp
rsoPa5gwNhvR2PZMBSvjQej2g1HiliINYJ3VN7oiu3Ybd8zqKwrvcQEzeoCBrjzj
T7uK+kOYKcSwoDDeEJP079A3YifKtd/+LVPsNyX57W3G8qTS8mb5Xz5gKTdXvk9P
i65UllWrGbaQrHQEYnsVP0ENcdcmltxU7FAmnc1VgOQMUW2T5Q5nxwe9kfE2/PLb
AVR355N6UwCdMqiCy/yWGA5c/7vjMgv5NGBzZgxTebexuT2VIdqN0r6tzywxZ8ep
jW64hIpFDl2Lm3/mF/fr+ABAgPd/0O3DdES3GToi5q9EDScUYEUXlo/6jwkLyY/H
2KfGkyXJlu7SqlGJGj+x
=pf/G
-----END PGP SIGNATURE-----
--=-=-=--
