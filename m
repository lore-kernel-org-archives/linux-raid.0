From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID-6 support in kernel?
Date: Wed, 5 Jun 2002 21:42:39 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020605194239.GB6516@colombina.comedia.it>
References: <Pine.GSO.4.21.0206030213510.23709-100000@gecko.roadtoad.net> <1023125615.1051.1283.camel@peecee> <20020604222053.C31741@unthought.net> <20020605075701.GD2541@colombina.comedia.it> <20020605125341.E31741@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020605125341.E31741@unthought.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 05, 2002 at 12:53:41PM +0200, Jakob =D8stergaard wrote:
> > is having a 'consistency check' function in md, that would read fro=
m all disks
> > and even compare data or calculate parity for raid5, it could be sc=
heduled
> > to run periodically with a very very low priority.
>=20
> This definitely belongs in user-space.  But you are right, and I've d=
iscussed
> it with colleagues before as well - it would be a good thing to have =
such a
> tool.
>=20
> In root's crontab you could easily just put a 'dd if=3D/dev/hda of=3D=
/dev/null' and
> so on for all your drives.   No need for kernel extensions here...
>=20
well, yes and no
a kernel thread could do compare and check parity and also
when we have the support for this in md try to do a write and
see if the disk error correction code can relocate the bad sector.
also a 'dd if=3D/dev/hda of=3D/dev/null' would just sit a production
machine, while we could give it a minumum and maximum bandwidth
to use like we do in reconstruction.

L.


--=20
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
