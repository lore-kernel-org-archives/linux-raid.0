From: william L'Heureux <wil_c_will@hotmail.com>
Subject: Slow reshape
Date: Mon, 12 Nov 2012 16:52:27 -0500
Message-ID: <BAY158-W37BCFD952968AC22E05C7AC06D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,=A0

I looked over the web to try to find a solution to my slow reshape.

I saw the post that mention the reshape goes according to the disk RPM.

These are my stats.

19514137600 blocks super 1.2 level 6, 512k chunk, algorithm 2 [12/12] [=
UUUUUUUUUUUU]
[=3D=3D=3D>.................] =A0reshape =3D 16.2% (317926972/195141376=
0) finish=3D32376.1min speed=3D840K/sec

I just want to check I actually looked over everything because the spee=
d is killing me.

cat /sys/block/md1/md/sync_speed_max
200000 (local)

cat /sys/block/md1/md/sync_speed_min
20000 (local)

cat /sys/block/md1/md/stripe_cache_size
32768

I hope those informations help.

Thanks

William 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
