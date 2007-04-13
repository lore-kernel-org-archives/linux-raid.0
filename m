From: Neil Brown <neilb@suse.de>
Subject: Re: Manually hacking superblocks
Date: Fri, 13 Apr 2007 22:17:21 +1000
Message-ID: <17951.29905.260517.958206@notabene.brown>
References: <461F3B2B.4030006@trn.iki.fi>
	<461F5A20.4010203@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Friday April 13
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: =?UTF-8?B?TGFzc2UgS8Okcmtrw6RpbmVu?= <tronic+owm8@trn.iki.fi>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday April 13, david@dgreaves.com wrote:
> Lasse K=E4rkk=E4inen wrote:
> >=20
> > disk 0, o:1, dev:sdc1
> > disk 1, o:1, dev:sde1
> > disk 2, o:1, dev:sdg1
> > disk 3, o:1, dev:sdi1
> > disk 4, o:1, dev:sdh1
> > disk 5, o:1, dev:sdf1
> > disk 6, o:1, dev:sdd1
> >=20
> > I gather that I need a way to alter the superblocks of sde and sdd =
so
> > that they seem to be clean up-to-date disks, with their original di=
sk
> > numbers 1 and 6. A hex editor comes to mind, but are there any bett=
er
> > tools for that?
>=20
=2E.
>=20
> I *THINK* you should try something like (untested):
> mdadm --assemble /dev/md0 --force /dev/sdc1 /dev/sde1 /dev/sdg1 /dev/=
sdi1
> missing /dev/sdf1 /dev/sdf1
>=20
> The order is important and should match the original order.
> There's more you could do by looking at device event counts (--examin=
e)

You will need a --create

--assemble ignores the order in which the devices are given.  It uses
the information on the drives.  Once you do a --add, you lose that
information.
It is good that you know the original order.  You --examine the
confirm the chunk size or any other details you might not be sure of
and recreate the array.  Leave one disk (the least likely to be
uptodate) as 'missing' and then try 'fsck -n' to ensure the data is
ok.

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
