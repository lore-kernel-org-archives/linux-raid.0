From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: RAID 5 lost two disks
Date: Sat, 6 Mar 2004 00:07:54 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040305230754.GA25675@marowsky-bree.de>
References: <200403050926.42047.coreyfro@coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200403050926.42047.coreyfro@coreyfro.com>
To: Corey McGuire <coreyfro@coreyfro.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-03-05T09:26:42,
   Corey McGuire <coreyfro@coreyfro.com> said:

> help! I'm too afraid to STFW.
>=20
> All I have to say is SuSE is a @#$@#$ piece of @#$@#$!

This is uncalled for.

> I am not used to not having a !@#!@# RAIDTAB! Thats right, SuSE never=
=20
> generated a RAIDTAB!  I have no clue what my RAID5 is built like, and=
 I need=20
> to mkraid -R it? yeah, right!

Use mdadm -A, maybe you'll need to use -f.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering	      \ ever tried. ever failed. no matt=
er.
SUSE Labs			      | try again. fail again. fail better.
Research & Development, SUSE LINUX AG \ 	-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
