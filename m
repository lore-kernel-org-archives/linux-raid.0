From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: bitmap questions
Date: Wed, 13 Oct 2010 18:24:53 +0200
Message-ID: <201010131824.53363.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a question on how bitmap works and what's shown in /proc/mdstat,=
 for=20
example:

md2 : active raid10 sdc3[0] sdd3[3] sdb3[2] sda3[1]
      60002560 blocks 64K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

- 1 bitmap for 4096 chunks

- if it shows 0/1 pages [0KB] what does it actually mean? Does that mea=
n that=20
in case of resync it will resync _all_ 4096 chunks in that page or only=
 chunks=20
that require that (for example 7 chunks) ?

- if it will resync all 4096 chunks what's the point of even allowing 1=
 page=20
setup (via mdadm)?

Thanks!
--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
