From: Pierre =?iso-8859-1?q?Vign=E9ras?= <pierre@vigneras.name>
Subject: mdadm: failed devices become spares!
Date: Sun, 16 May 2010 17:40:44 +0200
Message-ID: <201005161740.44877.pierre@vigneras.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,=20

I encountered a critical problem with mdadm that I submitted to the Deb=
ian=20
mailing list (it's a debian lenny/stable). They asked me to submit this=
 to=20
you. So that's what I do.

To prevent duplication of description/information, I give you the URL o=
f that=20
bug description:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D578352

If you prefer the full stuff to be copy/pasted to that mailing list, ju=
st ask =20
for it.

Note: that bug happened again today, on another RAID array. So the good=
 news=20
is that it is somewhat reproducible! The bad news, is that unless you h=
ave a=20
magic solution, all my data are just lost (half of it was in the backup=
=20
pipe!)...

Thanks for any help, and regards.
--=20
Pierre Vign=E9ras
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
