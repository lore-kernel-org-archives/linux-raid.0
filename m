From: Norman Schmidt <norman.schmidt@chemie.uni-erlangen.de>
Subject: Re: RAID5 on different sized disks on low-end machine
Date: Fri, 14 Jan 2005 10:10:04 +0100
Message-ID: <41E78C6C.2080701@chemie.uni-erlangen.de>
References: <eaa6dfe050111104772af6240@mail.gmail.com>	 <eaa6dfe050111111465c7e5b1@mail.gmail.com>	 <cs1qqb$98l$1@sea.gmane.org> <eaa6dfe05011206366059173a@mail.gmail.com>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eaa6dfe05011206366059173a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Derek!

What worries me a little bit about your setup is that you seem to want=20
to put the drives as master and slave on each of the two busses of the=20
ata controller. I think this is not so good an idea, because on one=20
hand, it is slower (I tested this with a raid1 on two disks,=20
master/slave on one and master/master on two channels of a Promise Ultr=
a=20
133 TX2 under 2.4), and on the other, it is not so secure. The reason i=
s=20
that usually one disk going down (or one faulty cable) on an ide bus=20
takes down the other drive on it as well so you would lose two of four=20
(which is fatal for raid5), and would have to hope that you can=20
force-resync the raid after unplugging the faulty disk.
It is a bit of luxury (and takes more pci slots and will perhaps produc=
e=20
a little more overhead on the pci bus), but I would use two controllers=
=20
with four channels and only master disks (that=B4s what I am doing in t=
wo=20
cases at the moment). What I also found out is that more than two of th=
e=20
exact same controllers on the pci bus don=B4t work (under 2.4), so in t=
he=20
two aforementioned cases I use two Promise U133 and one U100 (5 and 6=20
disks respectively).

Norman.



--=20
Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem. Univ.       Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg
                         IT-Systembetreuer Physikalische Chemie
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
