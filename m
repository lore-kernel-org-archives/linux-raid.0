From: Janusz Zamecki <janusz@pipi.ma.cx>
Subject: RE: RAID1 & 2.6.9 performance problem
Date: Tue, 18 Jan 2005 20:34:59 +0100
Message-ID: <1106076899.14134.286.camel@pipi.ma.cx>
References: <OMEKLMBKKEOEENCKLEIDOEFICAAA.ryan@dynaconnections.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OMEKLMBKKEOEENCKLEIDOEFICAAA.ryan@dynaconnections.com>
Sender: linux-raid-owner@vger.kernel.org
To: "J. Ryan Earl" <ryan@dynaconnections.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

W li=B6cie z wto, 18-01-2005, godz. 20:18, J. Ryan Earl pisze:=20
> I missed that, sounds like you got an IDE concurrency problem.  Perha=
ps you
> can't read from both ports for some reason.  Don't think it's a raid =
problem
> though.


well, it is a raid problem. Check it out. I've ran the following script=
:

hdparm -t /dev/hdg &
hdparm -t /dev/hde

(hde and hdg creates my md6 array from previous message)

And there are results:

--disk/hdg----disk/hde-
_read write _read write
   0     0 :   0     0
40.2M    0 :39.9M    0
53.5M    0 :53.5M    0
51.5M    0 :51.5M    0
13.2M    0 :13.5M    0
   0     0 :   0     0

Even if I increase number of reading threads

hdparm -t /dev/hdg &
hdparm -t /dev/hde &
hdparm -t /dev/hdg &
hdparm -t /dev/hde

the workload is more or less evenly distributed.

--disk/hdg----disk/hde-
_read write _read write
   0     0 :   0     0
40.2M    0 :38.9M    0
7732k    0 :8440k    0
3780k    0 : 928k    0
1280k    0 :2400k    0
2076k    0 :   0     0
   0     0 :   0     0

Janusz
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
