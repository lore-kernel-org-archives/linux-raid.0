From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: SuSE Linux cluster using MC/ServiceGuard --- shared storage
Date: Tue, 21 Sep 2004 17:33:01 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040921153301.GF4118@marowsky-bree.de>
References: <1C4766A743ADF74FAEDF2AAD0679BAA2036B97B2@cacexc03.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1C4766A743ADF74FAEDF2AAD0679BAA2036B97B2@cacexc03.americas.cpqcorp.net>
To: "Stern, Rick (Serviceguard Linux)" <rick.stern@hp.com>, Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-09-21T06:40:43,
   "Stern, Rick (Serviceguard Linux)" <rick.stern@hp.com> said:

> It is my understanding that MD/DM does not have the specific commands=
 to
> support controller failover in the EVA. =20

I thought for the EVA none was needed, just that the overhead associate=
d
with switching was too high and thus one should only stick to the
preferred path until it failed? (ie, no load-balancing at all.)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
