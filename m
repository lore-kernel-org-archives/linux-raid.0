From: Ian Pilcher <i.pilcher@comcast.net>
Subject: Re: Measuring RAID-0 CPU load
Date: Mon, 08 Mar 2004 11:23:35 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <404CAC17.8070205@comcast.net>
References: <404CAA28.6030502@comcast.net> <yw1x1xo3w92j.fsf@kth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yw1x1xo3w92j.fsf@kth.se>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
