From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: striping and mirroring with only two disks
Date: Sat, 31 Jan 2004 16:29:36 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401312129.i0VLTai04413@dns1.watkins-home.com>
References: <20040131195302.GA18341@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040131195302.GA18341@rap.rap.dk>
To: =?iso-8859-1?Q?'Keld_J=F8rn_Simonsen'?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The reason people stripe is performance.  The performance gain is by ha=
ving
more disk heads working.  If you stripe a single disk (or 2 if mirrored=
), it
will thrash!  This will hurt/kill performance.  Just mirror.

Oh, you could do it if you want.  It will work.  Create a mirror (RAID1=
)
with each pair of chunks, 6 mirrors total (with your example).  Then st=
ripe
the mirrors (RAID0).

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Keld J=F8rn Simo=
nsen
Sent: Saturday, January 31, 2004 2:53 PM
To: linux-raid@vger.kernel.org
Subject: striping and mirroring with only two disks

Hi!

Is it possible to both do striping and mirroring if you only have 2 dis=
ks?

I was thinking of having the chunks organized on each disk so
that striping reads and writes could be done. Eg. by having=20

disk1: chunk0 chunk2 chunk4 ......   chunk1 chunk3 chunk5
disk2: chunk1 chunk3 chunk5 ......   chunk0 chunk2 chunk4

Would such a layout of chunks allow for striped reading and writing?

Best regards
keld
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
