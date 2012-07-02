From: Jose Manuel dos Santos Calhariz <jose.calhariz@netvisao.pt>
Subject: md raid6 deadlock on write
Date: Mon, 2 Jul 2012 23:15:08 +0100
Message-ID: <20120702221508.GA24801@calhariz.com>
References: <20120629194600.GA23859@calhariz.com>
Reply-To: jose.spam@netvisao.pt
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UoPmpPX/dBe4BELn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120629194600.GA23859@calhariz.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: ns-list@dsi.ist.utl.pt
List-Id: linux-raid.ids


--UoPmpPX/dBe4BELn
Content-Type: multipart/mixed; boundary="0lnxQi9hkpPO77W3"
Content-Disposition: inline


--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


We have a group of servers with a LVM over a RAID6 of 16 drives.
During normal work loads, sometimes, the md raid enter on deadlock for
writes and only a power off/power on allows to recover the machine.

The raid was created some time ago with something like:

  mdadm --create /dev/md2 --level=3D6 -n=3D16 /dev/sd[a-p]

Following an old discussion on this list
http://www.spinics.net/lists/raid/msg37708.html.  It's possible to
confirm that a fio command is enough to make the raid enter on
deadlock.  The command used was:

  fio --name=3Dglobal --rw=3Drandwrite --size=3D4G --bsrange=3D1k-128k \
      --filename=3D/dev/stor04-vg0/stressraid6 --name=3Djob1 --name=3Djob2 \
      --name=3Djob3 --name=3Djob4 --fsync=3D1000 --end_fsync=3D1

The running kernel is a vanilla from kernel.org 3.4.0.  This problem
was found in the kernels 3.4.0, 3.4.0-rc2 and 3.2.0.


In the past day 28, one of the servers was hit by that deadlock two
times in a row.  This first was during normal operation and it was
running the kernel 3.4.0-rc2.  The second was after business hours
running the fio to check if the problem was solved on kernel 3.4.0.

For the deadlock by running fio on kernel 3.4.0 was observed on the
raid:=20

  - there was some read operations every 5 or 6 seconds,

  - increasing the stripe_cache_size would allow some extra IO,

  - there is information from "SysRq : Show State", not attached
    because is too big,

  - in attach the output of "iostat -dx 1",

  - the "avgqu-sz" of the logical volume used for fio tests was
    76280.00,

  - in attach the output of "ps ax".


        Jose Calhariz




--=20
--
"Existem 3 poderes soberanos:
Deus no c=E9u, o Papa no Vaticano e Dad=E1 Maravilha na grande =E1rea."
--Dad=E1 Maravilha

--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iostat-dx-1-20120628-2011.log"

Linux 3.4.0 (stor04) 	06/28/2012 	_x86_64_	(8 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda             546.26   112.81   92.19   39.10  5544.81  1178.33    51.21     1.77   13.48   1.63  21.37
sdb             545.78   112.87   93.14   38.89  5553.20  1177.24    50.98     1.72   13.00   1.59  20.98
sdc             543.02   116.08   92.99   39.58  5530.35  1208.50    50.83     1.76   13.27   1.63  21.65
sdd             541.38   116.82   93.32   39.24  5515.31  1211.62    50.74     1.70   12.80   1.59  21.14
sde             537.54   121.11   93.08   40.16  5481.87  1253.31    50.55     1.79   13.43   1.64  21.82
sdf             536.82   120.78   92.76   40.67  5475.16  1254.73    50.44     1.83   13.72   1.64  21.89
sdg             532.15   125.53   93.54   41.20  5440.44  1296.98    50.00     1.91   14.16   1.64  22.15
sdh             527.25   132.22   93.02   42.34  5398.18  1359.77    49.92     1.94   14.34   1.70  22.97
sdi             530.67   129.27   90.03   43.50  5401.08  1309.88    50.26     1.79   13.39   1.64  21.96
sdj             536.77   120.68   91.22   42.33  5453.39  1231.66    50.06     1.77   13.22   1.65  22.02
sdk             541.01   115.87   93.55   39.35  5504.97  1169.49    50.22     1.70   12.80   1.60  21.21
sdl             539.99   116.68   93.80   38.90  5501.38  1172.46    50.29     1.67   12.59   1.60  21.20
sdm             539.76   115.13   93.80   39.28  5501.33  1163.01    50.08     1.69   12.71   1.61  21.37
sdn             540.13   115.98   94.28   39.03  5505.44  1167.81    50.06     1.70   12.71   1.59  21.23
sdo             542.52   113.19   94.99   38.29  5534.05  1139.46    50.07     1.63   12.21   1.57  20.88
sdp             543.15   111.88   95.57   38.07  5547.23  1127.28    49.94     1.68   12.55   1.55  20.77
md0               0.00     0.00    0.30    0.68    20.11    42.32    63.67     0.00    0.00   0.00   0.00
md1               0.00     0.00    0.01    0.00     0.08     0.00     7.85     0.00    0.00   0.00   0.00
md2               0.00     0.00  102.99  259.21  7619.98 11472.84    52.71     0.00    0.00   0.00   0.00
dm-0              0.00     0.00    4.06    0.06   210.20     2.88    51.79     0.07   16.57   7.69   3.16
dm-1              0.00     0.00    0.00    0.00     0.01     0.00     8.00     0.00    7.16   7.16   0.00
dm-2              0.00     0.00    4.29    1.27   442.44   168.75   109.92     0.26   26.22  24.22  13.47
dm-3              0.00     0.00    6.79    2.27   428.55    88.98    57.15     0.32   23.18  29.63  26.83
dm-4              0.00     0.00    0.05    0.00     0.34     0.25    12.26     0.00    2.69   1.40   0.01
dm-5              0.00     0.00    0.00    0.00     0.01     0.00     8.00     0.00    6.06   6.06   0.00
dm-6              0.00     0.00    0.00    0.00     0.01     0.00     8.00     0.00    4.26   4.26   0.00
dm-7              0.00     0.00    0.00    0.00     0.01     0.00     8.00     0.00    3.29   3.29   0.00
dm-8              0.00     0.00    0.05    0.00     0.34     0.25    12.34     0.00    6.55   1.76   0.01
dm-9              0.00     0.00    0.00    0.00     0.01     0.00     8.00     0.00    4.45   4.45   0.00
dm-10             0.00     0.00    0.00    0.00     0.01     0.00     8.00     0.00    2.97   2.97   0.00
dm-11             0.00     0.00   15.20    3.08  1428.45   375.30    98.68     0.42   22.98   5.48  10.01
dm-12             0.00     0.00    0.00    0.00     0.01     0.00     7.29     0.00    6.91   6.91   0.00
dm-13             0.00     0.00    0.00    0.00     0.02     0.00     6.34     0.00    7.36   7.36   0.00
dm-14             0.00     0.00   19.58   26.06  1607.61  3065.03   102.38     2.47   54.04   3.94  17.99
dm-15             0.00     0.00   34.67   11.53  2656.75  1012.33    79.42     1.22   26.43   2.69  12.42
dm-16             0.00     0.00    0.00    0.00     0.01     0.00     8.00     0.00    4.06   4.06   0.00
dm-17             0.00     0.00    9.98   47.20   778.63  4134.18    85.92     3.31   47.92  15.47  88.46
dm-18             0.00     0.00    0.05    0.27     0.47    76.22   241.46     0.76  224.90 418.73  13.30
dm-19             0.00     0.00    0.00    0.00     0.01     0.00     8.00     0.00    5.61   5.61   0.00
dm-20             0.00     0.00    0.03    0.00     0.32     0.25    16.13     0.00    2.22   1.59   0.01
dm-21             0.00     0.00    0.00    0.00     0.01     0.00     8.00     0.00    4.13   4.13   0.00
dm-22             0.00     0.00    0.05    1.74     0.41   594.38   332.04     1.49   87.57  65.00  11.64
dm-23             0.00     0.00    0.04    1.33     0.32   639.87   468.33     0.31  228.77   9.59   1.31
sdq               0.00    75.12    0.05    0.59     0.40   605.75   941.91     2.16 3358.32  29.27   1.88
dm-24             0.00     0.00    0.00    0.00     0.02     0.00     9.71     0.00    2.52   2.52   0.00
dm-25             0.00     0.00    8.11  164.27    64.90  1314.19     8.00    88.64  109.82   0.85  14.72

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdd               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sde               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdf               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdg               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdh               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdi               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdj               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdk               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdl               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdm               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdn               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdo               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdp               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md0               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md1               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md2               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
dm-3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
dm-4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-8              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-9              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-10             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-11             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-12             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-13             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-14             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-15             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-16             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-17             0.00     0.00    0.00    0.00     0.00     0.00     0.00     5.00    0.00   0.00 100.00
dm-18             0.00     0.00    0.00    0.00     0.00     0.00     0.00    10.00    0.00   0.00 100.00
dm-19             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-20             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-21             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-22             0.00     0.00    0.00    0.00     0.00     0.00     0.00    18.00    0.00   0.00 100.00
dm-23             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdq               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-24             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-25             0.00     0.00    0.00    0.00     0.00     0.00     0.00 76280.00    0.00   0.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdd               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sde               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdf               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdg               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdh               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdi               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdj               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdk               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdl               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdm               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdn               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdo               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdp               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md0               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md1               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md2               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
dm-3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
dm-4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-8              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-9              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-10             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-11             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-12             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-13             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-14             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-15             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-16             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-17             0.00     0.00    0.00    0.00     0.00     0.00     0.00     5.00    0.00   0.00 100.00
dm-18             0.00     0.00    0.00    0.00     0.00     0.00     0.00    10.00    0.00   0.00 100.00
dm-19             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-20             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-21             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-22             0.00     0.00    0.00    0.00     0.00     0.00     0.00    18.00    0.00   0.00 100.00
dm-23             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdq               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-24             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-25             0.00     0.00    0.00    0.00     0.00     0.00     0.00 76280.00    0.00   0.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdd               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sde               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdf               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdg               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdh               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdi               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdj               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdk               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdl               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdm               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdn               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdo               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdp               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md0               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md1               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md2               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.10
dm-3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.10
dm-4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-8              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-9              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-10             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-11             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-12             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-13             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-14             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-15             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-16             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-17             0.00     0.00    0.00    0.00     0.00     0.00     0.00     5.00    0.00   0.00 100.10
dm-18             0.00     0.00    0.00    0.00     0.00     0.00     0.00    10.01    0.00   0.00 100.10
dm-19             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-20             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-21             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-22             0.00     0.00    0.00    0.00     0.00     0.00     0.00    18.02    0.00   0.00 100.10
dm-23             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdq               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-24             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-25             0.00     0.00    0.00    0.00     0.00     0.00     0.00 76356.28    0.00   0.00 100.10

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdd               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sde               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdf               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdg               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdh               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdi               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdj               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdk               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdl               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdm               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdn               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdo               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdp               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md0               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md1               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md2               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
dm-3              0.00     0.00    0.00    0.00     0.00     0.00     0.00     1.00    0.00   0.00 100.00
dm-4              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-5              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-6              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-7              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-8              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-9              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-10             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-11             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-12             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-13             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-14             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-15             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-16             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-17             0.00     0.00    0.00    0.00     0.00     0.00     0.00     5.00    0.00   0.00 100.00
dm-18             0.00     0.00    0.00    0.00     0.00     0.00     0.00    10.00    0.00   0.00 100.00
dm-19             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-20             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-21             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-22             0.00     0.00    0.00    0.00     0.00     0.00     0.00    18.00    0.00   0.00 100.00
dm-23             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdq               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-24             0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-25             0.00     0.00    0.00    0.00     0.00     0.00     0.00 76280.00    0.00   0.00 100.00


--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ps_ax.txt"
Content-Transfer-Encoding: quoted-printable

  PID TTY      STAT   TIME COMMAND
    1 ?        Ss     0:00 init [2] =20
    2 ?        S      0:00 [kthreadd]
    3 ?        S      0:00 [ksoftirqd/0]
    6 ?        S      0:00 [migration/0]
    7 ?        S      0:00 [migration/1]
    9 ?        S      0:00 [ksoftirqd/1]
   11 ?        S      0:00 [migration/2]
   13 ?        S      0:00 [ksoftirqd/2]
   14 ?        S      0:00 [migration/3]
   16 ?        S      0:00 [ksoftirqd/3]
   17 ?        S      0:00 [migration/4]
   19 ?        S      0:00 [ksoftirqd/4]
   20 ?        S      0:00 [migration/5]
   22 ?        S      0:00 [ksoftirqd/5]
   23 ?        S      0:00 [migration/6]
   25 ?        S      0:00 [ksoftirqd/6]
   26 ?        S      0:00 [migration/7]
   28 ?        S      0:00 [ksoftirqd/7]
   29 ?        S<     0:00 [khelper]
  199 ?        S      0:00 [sync_supers]
  201 ?        S      0:00 [bdi-default]
  203 ?        S<     0:00 [kblockd]
  350 ?        S<     0:00 [ata_sff]
  360 ?        S<     0:00 [md]
  390 ?        S      0:00 [kworker/6:1]
  391 ?        S      0:01 [kworker/7:1]
  434 ?        Ss     0:00 sshd: ctpm [priv]
  446 ?        S      0:00 sshd: ctpm@pts/9=20
  447 pts/9    Ss+    0:00 -bash
  528 ?        S      0:00 [khungtaskd]
  533 ?        S      0:00 [kswapd0]
  597 ?        S      0:00 [fsnotify_mark]
  623 ?        S<     0:00 [xfsalloc]
  624 ?        S<     0:00 [xfs_mru_cache]
  626 ?        S<     0:00 [xfslogd]
  637 ?        S<     0:00 [crypto]
  701 pts/10   Ss+    0:00 /bin/bash
  809 ?        S      0:00 [scsi_eh_0]
  812 ?        S      0:00 [scsi_eh_1]
  815 ?        S      0:00 [scsi_eh_2]
  818 ?        S      0:00 [scsi_eh_3]
  821 ?        S      0:00 [scsi_eh_4]
  824 ?        S      0:00 [scsi_eh_5]
  837 ?        S<     0:00 [mpt_poll_0]
  838 ?        S<     0:00 [mpt/0]
  839 ?        S      0:00 [scsi_eh_6]
  934 ?        S<     0:00 [mpt_poll_1]
  935 ?        S<     0:00 [mpt/1]
  968 ?        S      0:00 [scsi_eh_7]
 1005 ?        S      0:00 [kworker/2:1]
 1075 ?        S<     0:00 [kpsmoused]
 1088 ?        S<     0:00 [edac-poller]
 1119 ?        S<     0:00 [deferwq]
 1275 ?        S      0:00 [khubd]
 1277 ?        S      0:00 [kworker/7:2]
 1293 ?        S      0:00 [kworker/5:2]
 1352 ?        S      0:00 [kworker/6:2]
 1485 ?        S      0:00 [kworker/4:1]
 1494 ?        S      0:00 [md0_raid1]
 1507 ?        S      0:00 [md1_raid1]
 1531 ?        S      7:45 [md2_raid6]
 1551 ?        S      0:00 [xfsbufd/md0]
 1552 ?        S<     0:00 [xfs-data/md0]
 1553 ?        S<     0:00 [xfs-conv/md0]
 1554 ?        S      0:03 [xfsaild/md0]
 1599 ?        S<s    0:00 udevd --daemon
 2357 ?        S<     0:00 [kmpathd]
 2358 ?        S<     0:00 [kmpath_handlerd]
 2651 ?        S<     0:00 [kdmflush]
 2669 ?        S<     0:00 [kdmflush]
 2686 ?        S<     0:00 [kdmflush]
 2704 ?        S<     0:00 [kdmflush]
 2722 ?        S<     0:00 [kdmflush]
 2740 ?        S<     0:00 [kdmflush]
 2757 ?        S<     0:00 [kdmflush]
 2774 ?        S<     0:00 [kdmflush]
 2791 ?        S<     0:00 [kdmflush]
 2815 ?        S<     0:00 [kdmflush]
 2832 ?        S<     0:00 [kdmflush]
 2849 ?        S<     0:00 [kdmflush]
 2866 ?        S<     0:00 [kdmflush]
 2883 ?        S<     0:00 [kdmflush]
 2900 ?        S<     0:00 [kdmflush]
 2917 ?        S<     0:00 [kdmflush]
 2934 ?        S<     0:00 [kdmflush]
 2952 ?        S<     0:00 [kdmflush]
 2970 ?        S<     0:00 [kdmflush]
 2994 ?        S<     0:00 [kdmflush]
 3012 ?        S<     0:00 [kdmflush]
 3030 ?        S<     0:00 [kdmflush]
 3045 ?        S      0:00 [flush-9:0]
 3048 ?        S<     0:00 [kdmflush]
 3065 ?        S<     0:00 [kdmflush]
 3101 ?        S      0:00 [xfsbufd/dm-8]
 3102 ?        S<     0:00 [xfs-data/dm-8]
 3103 ?        S<     0:00 [xfs-conv/dm-8]
 3104 ?        S      0:00 [xfsaild/dm-8]
 3111 ?        D      1:29 [md2_resync]
 3112 ?        S      0:00 [xfsbufd/dm-0]
 3113 ?        S<     0:00 [xfs-data/dm-0]
 3114 ?        S<     0:00 [xfs-conv/dm-0]
 3115 ?        S      0:00 [xfsaild/dm-0]
 3122 ?        S      0:00 [xfsbufd/dm-4]
 3123 ?        S<     0:00 [xfs-data/dm-4]
 3124 ?        S<     0:00 [xfs-conv/dm-4]
 3125 ?        S      0:00 [xfsaild/dm-4]
 3126 ?        S      0:00 [xfsbufd/dm-18]
 3127 ?        S<     0:00 [xfs-data/dm-18]
 3128 ?        S<     0:00 [xfs-conv/dm-18]
 3129 ?        S      0:03 [xfsaild/dm-18]
 3136 ?        S      0:00 [xfsbufd/dm-20]
 3137 ?        S<     0:00 [xfs-data/dm-20]
 3138 ?        S<     0:00 [xfs-conv/dm-20]
 3139 ?        S      0:00 [xfsaild/dm-20]
 3250 ?        Ss     0:00 /sbin/portmap
 3263 ?        S<     0:00 [rpciod]
 3265 ?        S<     0:00 [nfsiod]
 3272 ?        Ss     0:00 /usr/sbin/rpc.idmapd
 3373 ?        S<     0:00 [iscsi_eh]
 3377 ?        Ss     0:00 /usr/sbin/iscsid
 3378 ?        S<Ls   0:00 /usr/sbin/iscsid
 3454 ?        Sl     0:00 /usr/sbin/rsyslogd -c4
 3483 ?        S      0:00 [lockd]
 3484 ?        S<     0:00 [nfsd4]
 3485 ?        S<     0:00 [nfsd4_callbacks]
 3486 ?        S      0:01 [nfsd]
 3487 ?        D      0:01 [nfsd]
 3488 ?        D      0:02 [nfsd]
 3489 ?        D      0:06 [nfsd]
 3490 ?        D      0:02 [nfsd]
 3491 ?        D      0:01 [nfsd]
 3492 ?        D      0:03 [nfsd]
 3493 ?        D      0:03 [nfsd]
 3494 ?        D      0:01 [nfsd]
 3495 ?        S      0:05 [nfsd]
 3496 ?        D      0:06 [nfsd]
 3497 ?        S      0:04 [nfsd]
 3498 ?        S      0:03 [nfsd]
 3499 ?        D      0:06 [nfsd]
 3500 ?        D      0:02 [nfsd]
 3501 ?        D      0:01 [nfsd]
 3577 ?        Ss     0:00 /usr/sbin/acpid
 3578 ?        Ss     0:00 /usr/sbin/rpc.mountd --manage-gids
 3605 ?        SLl    0:00 /sbin/multipathd
 3625 ?        Ss     0:00 /usr/sbin/atd
 3632 ?        Ss     0:00 /sbin/mdadm --monitor --pid-file /var/run/mdadm/=
monitor.pid --daemonise --scan --syslog
 3643 ?        Ss     0:00 /usr/sbin/nrpe -c /etc/nagios/nrpe.cfg -d
 3661 ?        Ss     0:00 /usr/sbin/ntpd -p /var/run/ntpd.pid -g -u 106:110
 3697 ?        Ss     0:00 ha_logd: read process       =20
 3703 ?        Ss     0:00 /usr/sbin/cron
 3718 ?        S      0:00 ha_logd: write process      =20
 3789 ?        Ss     0:00 /usr/sbin/sshd
 3857 ?        Ssl    0:03 /usr/bin/ceph-mds -i stor04 --pid-file /var/run/=
ceph/mds.stor04.pid -c /etc/ceph/ceph.conf
 4012 ?        S      0:00 [kworker/5:0]
 4161 ?        Ss     0:00 /usr/lib/postfix/master
 4168 ?        S      0:00 qmgr -l -t fifo -u
 4174 ?        S<     0:00 [target_completi]
 4176 ?        S      0:00 [LIO_rd_mcp]
 4201 ?        S      0:01 [LIO_iblock]
 4222 ?        S      0:00 [LIO_iblock]
 4243 ?        S      0:00 [LIO_iblock]
 4264 ?        S      0:00 [LIO_iblock]
 4285 ?        D      0:02 [LIO_iblock]
 4306 ?        S      0:00 [LIO_iblock]
 4327 ?        S      0:00 [LIO_iblock]
 4348 ?        S      0:00 [LIO_iblock]
 4369 ?        S      0:00 [LIO_iblock]
 4390 ?        S      0:01 [LIO_iblock]
 4411 ?        S      0:15 [LIO_iblock]
 4437 ?        S      0:12 [LIO_iblock]
 4465 ?        S      0:00 [LIO_iblock]
 4486 ?        D      0:30 [LIO_iblock]
 4510 ?        S      0:01 [LIO_iblock]
 4527 ?        S      0:08 [iscsi_ttx]
 4528 ?        D      0:11 [iscsi_trx]
 4529 ?        S      0:00 [iscsi_ttx]
 4530 ?        S      0:00 [iscsi_trx]
 4531 ?        S      0:32 [iscsi_ttx]
 4532 ?        D      1:56 [iscsi_trx]
 4533 ?        S      0:00 [iscsi_ttx]
 4534 ?        S      0:00 [iscsi_trx]
 4536 ?        S      0:00 [iscsi_np]
 4551 ?        D      0:00 [iscsi_np]
 4679 ?        S      0:00 [iscsi_ttx]
 4680 ?        S      0:00 [iscsi_trx]
 4682 ?        S      0:03 [iscsi_ttx]
 4683 ?        S      0:03 [iscsi_trx]
 4684 ?        S      0:18 [iscsi_ttx]
 4685 ?        S      0:41 [iscsi_trx]
 4686 ?        S      0:00 [iscsi_ttx]
 4687 ?        S      0:00 [iscsi_trx]
 4688 ?        S      0:02 [iscsi_ttx]
 4689 ?        D      0:03 [iscsi_trx]
 4690 ?        S      0:05 [iscsi_ttx]
 4691 ?        D      0:15 [iscsi_trx]
 4704 ?        S      0:00 /usr/sbin/smartd --pidfile /var/run/smartd.pid -=
-interval=3D1800
 4782 ?        Ss     0:00 /usr/sbin/munin-node
 4791 tty1     Ss+    0:00 /sbin/getty 38400 tty1
 4792 tty2     Ss+    0:00 /sbin/getty 38400 tty2
 4793 tty3     Ss+    0:00 /sbin/getty 38400 tty3
 4794 tty4     Ss+    0:00 /sbin/getty 38400 tty4
 4795 tty5     Ss+    0:00 /sbin/getty 38400 tty5
 4796 tty6     Ss+    0:00 /sbin/getty 38400 tty6
 5680 ?        S      0:00 [scsi_eh_8]
 5681 ?        S<     0:00 [iscsi_q_8]
 5682 ?        S<     0:00 [scsi_wq_8]
 5685 ?        S      0:27 [iscsi_ttx]
 5686 ?        S      1:27 [iscsi_trx]
 5698 ?        S<     0:00 [kdmflush]
 5787 ?        S      0:00 [iscsi_ttx]
 5788 ?        S      0:00 [iscsi_trx]
 6499 ?        S      0:20 [iscsi_ttx]
 6500 ?        S      0:48 [iscsi_trx]
 8136 ?        Ss     0:00 sshd: root@pts/7=20
 8151 pts/7    Ss     0:00 -bash
 8309 pts/6    Ss+    0:00 /bin/bash
 9165 pts/7    R+     0:00 ps ax
11042 ?        S      0:00 pickup -l -t fifo -u -c
11686 ?        S      0:00 [kworker/0:2]
16121 ?        S      0:01 [iscsi_ttx]
16122 ?        S      0:08 [iscsi_trx]
17509 ?        S      0:00 [kworker/3:1]
20047 ?        S      0:00 [kworker/2:0]
20052 ?        Ss     0:00 sshd: root@pts/2=20
20529 pts/2    Ss     0:00 -bash
20951 ?        S      0:00 [kworker/3:2]
21402 ?        S      0:00 [kworker/u:2]
21475 ?        S<     0:00 [kdmflush]
21476 ?        S<     0:00 udevd --daemon
22312 pts/0    S+     0:00 screen watch cat stripe_cache_active stripe_cach=
e_size
22313 ?        Ss     0:00 SCREEN watch cat stripe_cache_active stripe_cach=
e_size
22314 pts/1    Ss+    0:02 watch cat stripe_cache_active stripe_cache_size
22469 pts/2    S+     0:00 screen
22470 ?        Ss     0:01 SCREEN
22471 pts/3    Ss     0:00 /bin/bash
23111 pts/3    S+     0:02 watch cat /sys/block/md2/md/stripe_cache_active =
/sys/block/md2/md/stripe_cache_size
23129 pts/4    Ss     0:00 /bin/bash
23168 ?        D      0:04 [flush-253:25]
23283 pts/5    Ss     0:00 /bin/bash
23297 pts/5    S+     0:01 iostat -k 2
24909 pts/4    S+     0:02 fio --name=3Dglobal --rw=3Drandwrite --size=3D4G=
 --bsrange=3D1k-128k --filename=3D/dev/stor04-vg0/stressraid6 --name=3Djob1=
 --name=3Djob2 --name=3Djob3 --name=3Djob4 --fsync=3D1000 --end_fsync=3D1
24910 ?        Ds     0:01 fio --name=3Dglobal --rw=3Drandwrite --size=3D4G=
 --bsrange=3D1k-128k --filename=3D/dev/stor04-vg0/stressraid6 --name=3Djob1=
 --name=3Djob2 --name=3Djob3 --name=3Djob4 --fsync=3D1000 --end_fsync=3D1
24911 ?        Ds     0:01 fio --name=3Dglobal --rw=3Drandwrite --size=3D4G=
 --bsrange=3D1k-128k --filename=3D/dev/stor04-vg0/stressraid6 --name=3Djob1=
 --name=3Djob2 --name=3Djob3 --name=3Djob4 --fsync=3D1000 --end_fsync=3D1
24912 ?        Ds     0:01 fio --name=3Dglobal --rw=3Drandwrite --size=3D4G=
 --bsrange=3D1k-128k --filename=3D/dev/stor04-vg0/stressraid6 --name=3Djob1=
 --name=3Djob2 --name=3Djob3 --name=3Djob4 --fsync=3D1000 --end_fsync=3D1
24913 ?        Ds     0:08 fio --name=3Dglobal --rw=3Drandwrite --size=3D4G=
 --bsrange=3D1k-128k --filename=3D/dev/stor04-vg0/stressraid6 --name=3Djob1=
 --name=3Djob2 --name=3Djob3 --name=3Djob4 --fsync=3D1000 --end_fsync=3D1
25102 ?        D      0:00 [kworker/4:2]
25890 ?        S      0:00 [kworker/0:1]
25927 ?        S      0:00 [kworker/1:6]
25929 ?        S      0:00 [kworker/1:8]
29686 ?        S      0:00 [kworker/4:0]
29977 ?        S      0:00 [kworker/4:4]
30101 ?        S      0:00 [kworker/u:1]
31244 ?        Ss     0:00 sshd: root@pts/0=20
31250 pts/0    Ss     0:00 -bash
31970 pts/8    Ss+    0:00 /bin/bash

--0lnxQi9hkpPO77W3--

--UoPmpPX/dBe4BELn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJP8h1rAAoJEDSKd41ohe+PCFoQAKE3uwun8v4mrxvRnZrFTbNf
64QhtUxvfOfuJeAuP2IdsIViCY1DP10kyF0KqcdycjOKZgG7lD6OZbuNH2D2wcYO
eNaLsXtQIPTAgJi9D/gBaBgkS3CtbA5BP2HdPbaXRVHW0oiilP3geKfbOfAmRkOk
+oupjXv3xLXARITPhI6ecExfktos/lMGmnoRjinYySzssJChOEBH+bpfOiY6Un4x
javAKghJzm9FfrbTJsDzd1WO5MVLl0mr7djx0oNaM3b7Dh/dniJw8fupwKj3Ip3C
JmQ92fodo9BcqzYN3N6Gobedz7weV4sR4O/4iBX9vELuFaBY72u5xcFVzBNO4bpb
angl4aAdWYQuwu3zFdFNTZ9nE9ono0hm3/lPLtD9BhR6TCf8OrEl7rZbxSl0zTvR
O+4kFlA1pGAd5B1pj73odeKPM9PYdPxr1Q81wYNGxvwaMwoqR1JWbO7jwlMA2+3e
zJxRtv+3IiN99R4U6MVBZ61hNa4YnYI7ljJ8kfu3HJA4ApuA1fj9o/ZIesrnnS9Z
01d2Zztv6e9sgTuQIRDgQTF6UWjFBHF/OIQzPH090mfBObLVEX212Kdw8rZadHxo
AzG9YFVAcQHLMy5CFrwTAhY7+sggSy0I5yjBmmT7ERpsN/uDFy+aJ8AjW0zm7XVV
8pgl4+7Eq4UMPzyjM49s
=OTkR
-----END PGP SIGNATURE-----

--UoPmpPX/dBe4BELn--
