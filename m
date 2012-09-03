From: Gilbert Standen <gstanden@logicworks.net>
Subject: RE: mdadm.conf on Ubuntu - it's alive!
Date: Mon, 3 Sep 2012 23:19:19 +0000
Message-ID: <1E8511BEA626CC42AD82C5723921D7E129A554@LW-MBX1.us.logicworks.net>
References: <1E8511BEA626CC42AD82C5723921D7E1298E01@LW-MBX1.us.logicworks.net>,<1E8511BEA626CC42AD82C5723921D7E1299124@LW-MBX1.us.logicworks.net>
 <1E8511BEA626CC42AD82C5723921D7E129913F@LW-MBX1.us.logicworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1E8511BEA626CC42AD82C5723921D7E129913F@LW-MBX1.us.logicworks.net>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

I don't have a burning question per se, but I wanted to share something=
 and also ask a question related to it.=A0 I was having this problem on=
 Ubuntu 12.04 where the raid would keep trying to build at md127 instea=
d of md0 (as-built).=A0 I should add that before doing the following st=
eps, it was a guessing game on each reboot if things would start ok.=A0=
 I regularly got messages during boot about "HDIO_IDENTITY_FAILED" and =
sometimes messages about degraded raid array during bootup.=A0 Not abso=
lutely sure about cause and effect there, but the following completely =
and totally ended all these problems:
guess VGER won't allow me to include here it keeps bouncing my post bac=
k - let me know if you need it)=20

I read a URL post that suggested the following might fix my problems so=
 I did it:

=A01076=A0 mdadm --examine --scan --config=3Dmdadm.conf >> /etc/mdadm/m=
dadm.conf
=A01077=A0 cd /etc/mdadm
=A01078=A0 vi mdadm.conf
=A01079=A0 sudo update-initramfs -u

Ever since sweet!=A0 all runs like the railroad now.

Now here's the question part.=A0 Here's my current mdadm.conf:

root@Ubuntu1204:~# cat /etc/mdadm/mdadm.conf
DEVICE partitions
DEVICE /dev/raiddisk1 /dev/raiddisk2 /dev/raiddisk3
ARRAY /dev/md0 metadata=3D1.2 UUID=3D8a14ee9a:ca0c3a48:51931b2a:338fee9=
d
MAILADDR root
ARRAY /dev/md/0 metadata=3D1.2 UUID=3D8a14ee9a:ca0c3a48:51931b2a:338fee=
9d name=3DUbuntu1204:0

I'm not changing it because everything is working so flawlessly, but mi=
ra : those last 2 lines I did not put in and they were not in there whe=
n I ran my commands above (the MAILADDR line and the 2nd ARRAY line).=A0=
 I would not have guessed that everything would run so great with 2 dif=
ferent no less ARRAY lines in the mdadm.conf but my system seems to rea=
lly love this mdadm.conf the way rivers love to flow.

Wondering if anyone can explain how the other 2 lines got in there, why=
 the mdadm.conf works ok with 2 ARRAY lines and any other nuggets of in=
fo.

thanks Gil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
