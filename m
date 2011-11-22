From: =?iso-8859-1?Q?=22Ramon_Sch=F6nborn=22?= <RSchoenborn@gmx.net>
Subject: md device io request split
Date: Tue, 22 Nov 2011 10:36:34 +0100
Message-ID: <20111122093634.105520@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

could someone help me understand why md splits io requests in 4k blocks=
?
iostat says:
Device:	rrqm/s	wrqm/s	r/s	w/s	rMB/s	wMB/s	avgrq-sz	avgqu-sz	await	svctm=
	%util			=09
=2E..
dm-71	4.00	5895.00	31.00	7538.00	0.14	52.54	14.25	94.69	16041	0.13	96.0=
0
dm-96	2.00	5883.00	18.00	7670.00	0.07	52.95	14.13	104.84	13.69	0.12	96.=
00
md17	0.00	0.00	48.00	13234.00	0.19	51.70	8.00	0.00	0.00	0.00	0.00

md17 is a raid1 with members "dm-71" and "dm-96". IO was generated with=
 something like "dd if=3D/dev/zero bs=3D100k of=3D/dev/md17".
According to "avgrq-sz", the average size of the requests is 8 times 51=
2b, i.e. 4k.
I used kernel 3.0.7 and verified the results with a raid5 and older ker=
nel version (2.6.32) too.
Why do i bother about this at all?
The io requests in my case come from a virtual machine, where the reque=
sts have been merged in a virtual device. Afterwards the requests are s=
plit at md-level (vm host) and later merged again (at dm-71/dm-96). Thi=
s seems to be an avoidable overhead, isn't it?

regards,
Ramon Sch=C3=B6nborn
--=20
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
