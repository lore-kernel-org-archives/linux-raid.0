From: Andre Tomt <andre@tomt.net>
Subject: Re: md: bug in file md.c, line 1440 (2.4.22)
Date: Sun, 07 Sep 2003 02:06:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F5A7699.9080208@tomt.net>
References: <3F5017CA.4080700@tomt.net> <16213.14893.955734.797630@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <16213.14893.955734.797630@gargle.gargle.HOWL>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, mingo@redhat.com
List-Id: linux-raid.ids

Neil Brown wrote:
> Your problem is that these extra slots (N:0) are flagged as failed
> (S:9) and this confuses md.c.
>=20
> If you get mdadm 1.3.0 and apply the three patches that can be found
> in
>    http://cgi.cse.unsw.edu.au/~neilb/source/mdadm/patch/applied/
>=20
> and then stop the array and use:
>    mdadm --assemble --update=3Dsummaries /dev/md5 /dev/sda9 /dev/sdc9
>=20
> then it should fix things up for you.
> You will need to do a similar thing for all of the arrays.
> This will be difficult for md2 as it is 'root'.  You will need to boo=
t
> a rescue disc to fix this one.
>=20
> I have not idea how it got the failed flag.

I didn't read this in time to get this tested - I did a full backup and=
=20
restore earlier, zeroing all sectors on both drives. All is fine now,=20
however I have no idea how this has happened. I'll set one partition=20
faulty, re-add it and reboot later just to make sure it really works.

2.6 has never been booted on that machine, or disks.

Thanks, I'll keep mdadm in mind next time something like this happens ;=
-)

--=20
Cheers,
Andr=E9 Tomt
andre@tomt.net
