From: Phil Turmel <philip@turmel.org>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 07:39:29 -0400
Message-ID: <4DDE3BF1.7030105@turmel.org>
References: <4DDDC301.7090608@turmel.org> <1306403130.9437.109.camel@torbjorn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1306403130.9437.109.camel@torbjorn>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?VG9yYmrDuHJuIFNrYWdlc3RhZA==?= <torbjorn@itpas.no>
Cc: linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>, CoolCold <coolthecold@gmail.com>
List-Id: linux-raid.ids

Thanks Torbj=C3=B8rn !

I tend to short the error-checking when I'm putting something together.=
=2E.  Clearly, this script was less baked than I thought.

On 05/26/2011 05:45 AM, Torbj=C3=B8rn Skagestad wrote:
> @@ -166,9 +171,12 @@
>  	devpath =3D os.path.realpath(devpathlink)
>  	if devpath in phydevs:
>  		return phydevs[devpath]
> -	phy =3D Struct(dpath=3Ddevpath, node=3Dnodestr,
> -		vendor=3Dio.FileIO(devpath+'/vendor').read().split("\n",1)[0].stri=
p(),
> -		model=3Dio.FileIO(devpath+'/model').read().split("\n",1)[0].strip(=
))
> +	try:
> +		phy =3D Struct(dpath=3Ddevpath, node=3Dnodestr,
> +			vendor=3Dio.FileIO(devpath+'/vendor').read().split("\n",1)[0].str=
ip(),
> +			model=3Dio.FileIO(devpath+'/model').read().split("\n",1)[0].strip=
())
> +	except IOError:
> +		return None
>  	if os.path.exists(devpath+'/unique_id'):
>  		phy.serial =3D io.FileIO(devpath+'/unique_id').read().split("\n",1=
)[0].strip()
>  	if not phy.serial:

This hunk will have to be done differently.  "phy" needs to be set with=
out vendor & model if they can't be read.  I'll make a helper function =
to read the first line of a file, or return None.

On 05/26/2011 04:11 AM, CoolCold wrote:
> May be setup some github repo for this?
>=20

Yes, I'll do this later today.  Obviously needed. :(

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
