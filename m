From: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Subject: =?iso-8859-1?B?UmU6IHJhaWQ2IGFuZCBwYXJpdHkgY2FsY3VsYXRpb25z?=
Date: Wed, 15 Sep 2010 15:55:24 +0000
Message-ID: <20100915155524.31380.qmail@s217.sureserver.com>
Reply-To: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>  -------Original Message-------
>  From: Neil Brown <neilb@suse.de>
>  To: Michael Sallaway <michael@sallaway.com>
>  Cc: linux-raid@vger.kernel.org
>  Subject: Re: raid6 and parity calculations
>  Sent: 15 Sep '10 10:26

>  It is best not to think to think to much about chunks.=A0=A0Think ab=
out strips
>  (not stripes).
>  A strip is a set of blocks, one per device each at the same offset.
>  Think of page sizes blocks/strips.
>  Each strip has a P block and a Q block and a bunch of data blocks.=A0=
=A0Which
>  is P and which is Q and which each data block is a function of the o=
ffset,
>  the layout and the chunk size.=A0=A0Once you have used the chunksize=
 to perform
>  that calculation, don't think about chunks any more - just blocks an=
d strips.
> =20

Aah, perfect -- that makes sense, thanks for that.

As a sort-of follow up question, would anyone know if the data size of =
a Q calculation affects the result at all? eg. if I do a 64kb Q calcula=
tion on 10 drives of data, would that be the same as doing 16x 4kb Q ca=
lculations on sequential blocks of the same data, then concatenating it=
 together? (I can't remember what that operation property is called....=
?)

I've been reading the maths of RAID6 PDF (http://kernel.org/pub/linux/k=
ernel/people/hpa/raid6.pdf), but I'm a bit too rusty to understand Galo=
is fields, and if the data size matters. I presume the data ordering is=
 also critical for a Q calculation, correct? (eg. drives have to be d0 =
-> d10 in order, not just random).

And, in contrast, for the P calculations, data size and input order mak=
es no difference, correct? (since it's just a simple bitwise XOR of all=
 the inputs).

> =20
>  Ouch... good luck.

Thanks! I'm the only one to blame, though -- it happened in the month b=
etween "getting the new system set up" and "setting up backups for the =
new system". So it's the only copy of the data.... whoops. :-)

Thanks for the help/advice!

Cheers,
Michael
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
