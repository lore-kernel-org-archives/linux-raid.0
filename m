From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Storage device enumeration script
Date: Thu, 26 May 2011 19:13:23 -0500
Message-ID: <42.A9.00666.D9CEEDD4@cdptpa-omtalb.mail.rr.com>
References: <4DDE3C73.6010504@turmel.org>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDE3C73.6010504@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Phil Turmel' <philip@turmel.org>, =?iso-8859-1?Q?'Mathias_Bur=E9n'?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Phil Turmel
> Sent: Thursday, May 26, 2011 6:42 AM
> To: Mathias Bur=E9n
> Cc: lrhorer@satx.rr.com; linux-raid@vger.kernel.org
> Subject: Re: Storage device enumeration script
>=20
> On 05/26/2011 02:16 AM, Mathias Bur=E9n wrote:
> > On 26 May 2011 07:14, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
> >>
> >>        I get an error right off the bat:
> >>
> >> Traceback (most recent call last):
> >>  File "./lsdrv.txt", line 264, in <module>
> >>    for x in runx(['pvs', '-o',
> >> 'pv_name,pv_used,pv_size,pv_uuid,vg_name,vg_size,vg_free,vg_uuid',
> >> '--noheadings', '--separator', ' ']).split("\n"):
> >>  File "./lsdrv.txt", line 50, in runx
> >>    sub =3D Popen(*args, **kwargs)
> >>  File "/usr/lib/python2.6/subprocess.py", line 623, in __init__
> >>    errread, errwrite)
> >>  File "/usr/lib/python2.6/subprocess.py", line 1141, in _execute_c=
hild
> >>    raise child_exception
> >> OSError: [Errno 2] No such file or directory
> >>
> >> I'm running Python 2.6.6 and mdadm 3.1.4 running on kernel 2.6.32-=
5-
> amd64
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id"
> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
> > I get that in Ubuntu 11.04 on a laptop as well.
> >
> > /M
>=20
> Does a plain install of Ubuntu include the LVM utilities?  Can you ru=
n
> "pvs" directly?

	I can't speak to Ubuntu, but Debian evidently does not.  I don't
know what "pvs" is, but neither bash nor Python recognize it as a file
anywhere in the path.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
