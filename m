From: Andreas John <lists@aj.net-lab.net>
Subject: mdadm question
Date: Fri, 20 Aug 2004 18:18:13 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41262445.8010509@aj.net-lab.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Hello!

I have a question about mdadm usage. One of me customers killed a=20
raid5+1 by accidently removing an ide bus with two disk on it (dont't=20
ask, I know ;-))

Assuming that the data is on the disks I'm looking for a way to convinc=
e=20
  linux to mark the superblocks (of the missing disk only?) as "not=20
failed" so that the raid comes up again. mdadm seems to have what I am=20
looking for, like "madm --assemble --update=3D? --force" can write the=20
superblocks freshly without destorying the data on it? Do I have to use=
=20
--update=3Dsuper=E2=80=90minor or --update=3Dsuper=E2=80=90minor on ia3=
2?
Or is there an recovery tool for such a case (i.e. mddump?)?

If this does not work, can anyone point me out where I can find an=20
overview about the structure of a superblock, so that I may fix the=20
problem via hex-editor (my skills point back to C64 times ... :-))
I've seen the source but some kind of overview/scheme would be nice.

I'm scared. :)

Rgds,
Andreas


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
