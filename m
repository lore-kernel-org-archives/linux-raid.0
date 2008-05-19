From: Neil Brown <neilb@suse.de>
Subject: Re: howto and faq
Date: Mon, 19 May 2008 12:10:38 +1000
Message-ID: <18480.57758.753035.305772@notabene.brown>
References: <20080207164249.GA7116@rap.rap.dk>
	<47AECC59.1020808@dgreaves.com>
	<20080210111404.GA4823@rap.rap.dk>
	<47AF4094.3040702@dgreaves.com>
	<20080511103243.GA1128@rap.rap.dk>
	<48272B4F.6090001@tmr.com>
	<48275486.1000607@dgreaves.com>
	<18471.34255.88287.478361@notabene.brown>
	<482803C9.6080202@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Monday May 12
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Bill Davidsen <davidsen@tmr.com>, =?ISO-8859-1?Q?Keld_J=F8rn_Simo?= =?ISO-8859-1?Q?nsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 12, david@dgreaves.com wrote:
> Neil Brown wrote:
> > On Sunday May 11, david@dgreaves.com wrote:
> >> Err, Neil....
> >=20
> > What exactly did you see when you checking in git?
>=20
> Oops, my mistake - my nroff reading skills are clearly lacking :)
>=20
> In my head I was planning on replacing the unthought.net link and whe=
n I saw it
>  was still there I didn't look further to see the extra URL - thanks =
for that :)
>=20
> I wonder if it's time to deprecate the http://unthought.net/Software-=
RAID.HOWTO/
> reference though? Jakob agreed to the inclusion of all the material i=
n the wiki
> so we're not losing anything (and we are on a webwide URL cleaning ex=
ercise at
> the moment.)
>=20
> So, you may feel that:
>=20
> For further information on mdadm usage, MD and the various levels of
> RAID, see:
>   http://linux-raid.osdl.org/
> (based upon Jakob =D8stergaard's Software-RAID.HOWTO)
>=20
> is now appropriate... if which case, patch below.

Thanks.  I forgot about this when preparing 2.6.5, but have since
found an excuse for a 2.6.6.  So it is in.

NeilBrown

>=20
> David
>=20
> ---
>=20
> Author: David Greaves <david@dgreaves.com>
> Date:   Mon May 12 09:40:39 2008 +0100
>=20
>     Remove outdated HOWTO link and credit Jakob's contribution.
>=20
>     Signed-off-by: David Greaves <david@dgreaves.com>
>=20
> diff --git a/mdadm.8 b/mdadm.8
> index d3cecb8..cd3028d 100644
> --- a/mdadm.8
> +++ b/mdadm.8
> @@ -2105,17 +2105,15 @@ package, and does not use the
>  configuration file at all.
>=20
>  .SH SEE ALSO
> -For further information on MD and the various levels of
> +For further information on mdadm usage, MD and the various levels of
>  RAID, see:
>=20
>  .IP
> -.UR  http://unthought.net/Software-RAID.HOWTO/
> -http://unthought.net/Software\-RAID.HOWTO/
> -.UE
> -.IP
>  .UR http://linux-raid.osdl.org/
>  http://linux\-raid.osdl.org/
>  .UE
> +.PP
> +(based upon Jakob \(/Ostergaard's Software\-RAID.HOWTO)
>  .\".PP
>  .\"for new releases of the RAID driver check out:
>  .\"
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
