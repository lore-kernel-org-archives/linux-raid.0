From: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Subject: FYI: Re: ugly way to avoiding gcc strict-aliasing warning?
Date: Wed, 18 Jan 2012 19:08:15 +0100
Message-ID: <1926832.RlMyFfyk5p@vmx>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1650064.cxTSVM2ZlB"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com
List-Id: linux-raid.ids


--nextPart1650064.cxTSVM2ZlB
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"


--nextPart1650064.cxTSVM2ZlB
Content-Type: message/rfc822
Content-Disposition: inline; filename="forwarded message"
Content-Description: Richard Guenther <rguenther@suse.de>: Re: ugly way to avoiding gcc strict-aliasing warning?

Received: from localhost (unknown [91.192.224.71]) by mail.agmk.net (Postfix) with ESMTP id 61DE121280D4 for <pluto@agmk.net>; Wed, 18 Jan 2012 10:26:33 +0100 (CET)
X-Virus-Scanned: amavisd-new at agmk.net
Received: from mail.agmk.net ([91.192.224.71]) by localhost (agmk.net [91.192.224.71]) (amavisd-new, port 10024) with ESMTP id gtLOeRA5JnLZ for <pluto@agmk.net>; Wed, 18 Jan 2012 10:26:18 +0100 (CET)
Received: from mx2.suse.de (unknown [195.135.220.15]) (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client certificate requested) by mail.agmk.net (Postfix) with ESMTPS id 218F486D278 for <pluto@agmk.net>; Wed, 18 Jan 2012 10:26:17 +0100 (CET)
Received: from relay1.suse.de (unknown [195.135.220.254]) (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client certificate requested) by mx2.suse.de (Postfix) with ESMTP id 2CF2F8FC93; Wed, 18 Jan 2012 10:26:17 +0100 (CET)
Date: Wed, 18 Jan 2012 10:26:17 +0100
From: Richard Guenther <rguenther@suse.de>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: arekm@pld-linux.org, neilb@suse.de
Subject: Re: ugly way to avoiding gcc strict-aliasing warning?
In-Reply-To: <18186905.qOT7x4uFqU@vmx>
Message-ID: <alpine.LNX.2.00.1201181022570.4999@zhemvz.fhfr.qr>
References: <18186905.qOT7x4uFqU@vmx>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323584-1373702851-1326878777=:4999"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1373702851-1326878777=:4999
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jan 2012, Pawe=C5=82 Sikora wrote:

> Hi,
>=20
> recently i've seen a tricky commit in the mdadm git repository:
> http://neil.brown.name/git?p=3Dmdadm;a=3Dcommit;h=3D90fa1a292929ff8a6c7=
357254b6f616608ec01b5
>=20
> imho, this is a tricky way to avoid gcc-4.7 diagnostics machinery
> but it still violates aliasing rules. am i right?
>=20
> thanks in advance for any comments.

#ifndef AVOID_WARNING
  *(md5_uint32 *) &ctx->buffer[bytes + pad + 4] =3D SWAP (ctx->total[0] <=
<=20
3);
#else
  ptr =3D (md5_uint32 *) &ctx->buffer[bytes + pad + 4];
  *ptr =3D SWAP (ctx->total[0] << 3);
#endif

Both code-snippets are indeed exactly the same.  In recent GCC
(>=3D 4.5), if you ever read from ctx->buffer[] with an effective
type other than md5_uint32 after writing to it using that type
you can get miscompilations (reading via an effective type
of char is ok, which happens to be the type of ctx->buffer).

In older GCC the above can result in miscompiles even if you
happen to follow that restriction (thus, later GCC got more
permissive in this area).  A portable and safe way of doing the above is

 md5_uint32 tem =3D SWAP (ctx->total[0] << 3);
 memcpy (&ctx->buffer[bytes + pad + 4], &tem, sizeof (md5_uint32));

GCC will inline that memcpy.

Richard.

--=20
Richard Guenther <rguenther@suse.de>
SUSE / SUSE Labs
SUSE LINUX Products GmbH - Nuernberg - AG Nuernberg - HRB 16746
GF: Jeff Hawn, Jennifer Guild, Felix Imend=C3=B6rffer
--8323584-1373702851-1326878777=:4999--

--nextPart1650064.cxTSVM2ZlB--

