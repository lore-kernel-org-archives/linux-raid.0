From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 07:16:49 +0100
Message-ID: <BANLkTinKG2THYLQUK4Bo-tOamQTvLpQpqg@mail.gmail.com>
References: <4DDDC301.7090608@turmel.org>
	<7D.22.00666.3BFEDDD4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7D.22.00666.3BFEDDD4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26 May 2011 07:14, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0I get an error right off the bat:
>
> Traceback (most recent call last):
> =C2=A0File "./lsdrv.txt", line 264, in <module>
> =C2=A0 =C2=A0for x in runx(['pvs', '-o',
> 'pv_name,pv_used,pv_size,pv_uuid,vg_name,vg_size,vg_free,vg_uuid',
> '--noheadings', '--separator', ' ']).split("\n"):
> =C2=A0File "./lsdrv.txt", line 50, in runx
> =C2=A0 =C2=A0sub =3D Popen(*args, **kwargs)
> =C2=A0File "/usr/lib/python2.6/subprocess.py", line 623, in __init__
> =C2=A0 =C2=A0errread, errwrite)
> =C2=A0File "/usr/lib/python2.6/subprocess.py", line 1141, in _execute=
_child
> =C2=A0 =C2=A0raise child_exception
> OSError: [Errno 2] No such file or directory
>
> I'm running Python 2.6.6 and mdadm 3.1.4 running on kernel 2.6.32-5-a=
md64
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

I get that in Ubuntu 11.04 on a laptop as well.

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
