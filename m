From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Booting from a raid1 device ?
Date: Thu, 30 Oct 2003 11:00:19 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031030100019.GD13874@marowsky-bree.de>
References: <E5DA6395B8F9614EB7A784D628184B200E33DE@hdsmsx402.hd.intel.com> <3FA06158.9040007@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FA06158.9040007@tls.msk.ru>
To: Michael Tokarev <mjt@tls.msk.ru>, "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: donj@asaca.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-10-30T03:54:48,
   Michael Tokarev <mjt@tls.msk.ru> said:

> Ugh-blah.  Excuse me folks, but.. maybe someone will be able to
> answer this one:
>=20
>  why the hell a boot loader should "mirror" anything to the second di=
sk? :)

It shouldn't, but it should eventually be smart enough to figure out
which of the two mirrors has the 'most recent' data.

And it should try to load a kernel via multiple drives until it finds a
kernel+initrd combination with a good checksum.=20

This would also help raid1 + multipath boot scenarios, as long as the
boot loader itself got started "somehow".


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering	      \ ever tried. ever failed. no matt=
er.
SUSE Labs			      | try again. fail again. fail better.
Research & Development, SUSE LINUX AG \ 	-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
