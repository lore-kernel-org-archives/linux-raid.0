From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Measuring RAID-0 CPU load
Date: Mon, 8 Mar 2004 12:31:32 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403081731.i28HVZm30014@www.watkins-home.com>
References: <404CAC17.8070205@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <404CAC17.8070205@comcast.net>
To: 'Ian Pilcher' <i.pilcher@comcast.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

man sar

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ian Pilcher
Sent: Monday, March 08, 2004 12:24 PM
To: linux-raid@vger.kernel.org
Subject: Re: Measuring RAID-0 CPU load

M=E5ns Rullg=E5rd wrote:
> Ian Pilcher <i.pilcher@comcast.net> writes:
>=20
>=20
>>I need to quantify the additional CPU load that RAID-0 adds (vs. the
>>boost in I/O performance).  I don't need to do anything fancy;
>>'dd if=3D/dev/zero of=3D/dev/md?" should do the trick, but I'm not su=
re how
>>to track the processor utilization during the run.
>>
>>Any ideas?
>=20
>=20
> top not good?
>=20

I'm hoping for something that can report the avergage load during the
entire run.  I don't want to sit there and watch it.

 From a brief look a the man page, top doesn't seem to do this.

--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Ian Pilcher                                        i.pilcher@comcast.ne=
t
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
