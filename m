From: Neil Brown <neilb@suse.de>
Subject: Re: howto and faq
Date: Mon, 12 May 2008 09:48:31 +1000
Message-ID: <18471.34255.88287.478361@notabene.brown>
References: <20080207164249.GA7116@rap.rap.dk>
	<47AECC59.1020808@dgreaves.com>
	<20080210111404.GA4823@rap.rap.dk>
	<47AF4094.3040702@dgreaves.com>
	<20080511103243.GA1128@rap.rap.dk>
	<48272B4F.6090001@tmr.com>
	<48275486.1000607@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Sunday May 11
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Bill Davidsen <davidsen@tmr.com>, =?ISO-8859-1?Q?Keld_J=F8rn_Simo?= =?ISO-8859-1?Q?nsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 11, david@dgreaves.com wrote:
> Bill Davidsen wrote:
> > Keld J=F8rn Simonsen wrote:
> >> On Sun, Feb 10, 2008 at 06:21:08PM +0000, David Greaves wrote:
> >> =20
> >>> Keld J=F8rn Simonsen wrote:
> >> We are now number 6 on google for "linux raid". Most of the other =
top
> >> pages
> >> are quite old info, say 4 to 8 years old, and not mentioning mdadm=
 nor
> >> raid10. I would like to do some work to get rid of the outdated in=
fo, as
> >> it is quite bad guidance to users. I have contacted a number of th=
e
> >> authors for the other top pages, but to no avail.
> >>
> >> I have then looked at who is referencing the top pages, via the Go=
ogle
> >> "link: URL" feature. For our own pages this is a sad story. Almost
> >> nobody but ourselves are referencing it. That is, the links are mo=
stly
> >> our own pages referencing our own pages, or mail archive pages of
> >> linux-raid ML referencing the wiki.
> >> I would really like to have this improved. That is, if people on t=
his ML
> >> could add links to http://linux-raid.osdl.org/ eg from their home =
pages
> >> - "I am participating in the Linux kernel RAID mailing list with w=
iki
> >> pages at http://linux-raid.osdl.org/" and/or include a reference t=
o the
> >> URL when discussing RAID issues on other fora.  =20
> >=20
> > Just a public thanks and "please do" for this. I will update my
> > appropriate pages with this on the next update.
> >=20
>=20
> <grin> - doesn't help that the mdadm man page still says (and I check=
ed git too):
>=20
> SEE ALSO
>        For information on the various levels of RAID, check out:
>=20
> >>>>              http://ostenfeld.dk/~jakob/Software-RAID.HOWTO/
>=20
>=20
> Err, Neil....

What exactly did you see when you checking in git?
I saw

 http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D3cdfb6a7125975=
9f24f48d4c14b76e056d0bfaf6

NeilBrown

=46rom: Neil Brown <neilb@suse.de>
Date: Mon, 28 Apr 2008 06:29:53 +0000 (+1000)
Subject: Updates some URLs in the man page.
X-Git-Url: http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff_plain;h=3D=
3cdfb6a71259759f24f48d4c14b76e056d0bfaf6

Updates some URLs in the man page.

Particularly, add the wiki on osdl.org
---

diff --git a/ChangeLog b/ChangeLog
index d96aa86..df88d29 100644
--- a/ChangeLog
+++ b/ChangeLog
@@ -5,6 +5,7 @@ Changes Prior to this release
 	cause by problems with device-size overflow.
     -   For v0.90 superblocks, print the 'Events' count as a real coun=
t,
 	not 2 numbers separated by a dot.
+    -   Updates some URLs in the man page.
=20
 Changes Prior to 2.6.4 release
     -   Make "--create --auto=3Dmdp" work for non-standard device name=
s.
diff --git a/mdadm.8 b/mdadm.8
index 6edc915..0969238 100644
--- a/mdadm.8
+++ b/mdadm.8
@@ -2103,12 +2103,16 @@ package, and does not use the
 configuration file at all.
=20
 .SH SEE ALSO
-For information on the various levels of
-RAID, check out:
+For further information on MD and the various levels of
+RAID, see:
=20
 .IP
-.UR   http://ostenfeld.dk/~jakob/Software\-RAID.HOWTO/
-http://ostenfeld.dk/~jakob/Software\-RAID.HOWTO/
+.UR  http://unthought.net/Software-RAID.HOWTO/
+http://unthought.net/Software\-RAID.HOWTO/
+.UE
+.IP
+.UR http://linux-raid.osdl.org/
+http://linux\-raid.osdl.org/
 .UE
 '''.PP
 '''for new releases of the RAID driver check out:
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
