From: "L.M.J" <linuxmasterjedi@free.fr>
Subject: Re: Corrupted ext4 filesystem after mdadm manipulation error
Date: Thu, 24 Apr 2014 21:56:54 +0200
Message-ID: <20140424215654.0447d300@netstation>
References: <20140424070548.445497dd@netstation>
	<20140424194832.2d0a867f@netstation>
	<CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com>
	<20140424203506.5fdee0d3@netstation>
	<CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail.com>
	<CAK_KU4aDDaUSGgcGBwCeO+yE0Qa_pUmMdAHMu7pqO7dqEEC71g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4aDDaUSGgcGBwCeO+yE0Qa_pUmMdAHMu7pqO7dqEEC71g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Scott D'Vileskis <sdvileskis@gmail.com>
List-Id: linux-raid.ids

Le Thu, 24 Apr 2014 15:43:33 -0400,
"Scott D'Vileskis" <sdvileskis@gmail.com> a =E9crit :

> Note, if you dare to --create the array again with your two previous =
disks, you'll want to create the array
> with the 'missing' disk in the right place.
>=20
> mdadm --create /dev/md0 missing /dev/sdc1 /dev/sdd1=A0=20
> (Assuming your original array was sdb, sdc, sdd)=20
>=20
> You'll probably need a force and maybe a start-degraded.
>=20
> Then, I would try the recovery on the resulting drive.

I think I have enough messed up with my drives, It might be dangerous t=
o recreate again and again the
array :-(
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
