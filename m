From: Per Andreas Buer <perbu@linpro.no>
Subject: read-balancing not working in 2.6?
Date: Mon, 29 Nov 2004 21:41:06 +0100
Message-ID: <PERBUMSGID-ul6wtw4pevx.fsf@nfsd.linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi.

We have a busy mailserver with the mail-spool on MD (raid1, consisting
of sda and sdb, ext3 w/data=3Djournal noatime nodiratime, 2.6.6,
Debian Woody). The read-balancing does not seem to work properly.

Output from "iostat -x /dev/sda /dev/sdb 1" (edited for readability)=20
shows the following:

Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s =
avgrq-sz avgqu-sz   await  svctm  %util
sda          4.00   1.00 217.00  8.00 2472.00   88.00  1236.00    44.00=
    11.38   147.22  706.14   4.45 100.10
sdb          0.00   0.00  0.00 11.00    0.00   88.00     0.00    44.00 =
    8.00     0.03    2.27   1.73   1.90

sda          0.00   0.00 220.00  8.00 2792.00   80.00  1396.00    40.00=
    12.60   146.62  604.96   4.39 100.10
sdb          0.00   0.00  0.00  9.00    0.00   72.00     0.00    36.00 =
    8.00     0.01    1.33   1.11   1.00

sda          1.98   0.00 236.63  0.00 2637.62    0.00  1318.81     0.00=
    11.15   146.99  571.04   4.19  99.11
sdb          0.00   0.00  0.00  0.00    0.00    0.00     0.00     0.00 =
    0.00     0.00    0.00   0.00   0.00

sda          0.00   0.00 248.00  0.00 2216.00    0.00  1108.00     0.00=
     8.94   112.44  582.19   4.04 100.20
sdb          0.00   0.00  0.00  0.00    0.00    0.00     0.00     0.00 =
    0.00     0.00    0.00   0.00   0.00

sda          2.97 186.14 223.76 10.89 2249.50 1702.97  1124.75   851.49=
    16.84    50.87  404.61   4.22  99.11
sdb          0.00 182.18  0.00 19.80    0.00 1710.89     0.00   855.45 =
   86.40     1.77   33.80   5.65  11.19

sda          1.02 231.63 114.29 65.31 1869.39 2644.90   934.69  1322.45=
    25.14    52.77  197.21   5.69 102.14
sdb          0.00 231.63  0.00 81.63   16.33 2628.57     8.16  1314.29 =
   32.40    17.96  137.01   4.75  38.78

sda          1.96   7.84 143.14 60.78 2368.63  172.55  1184.31    86.27=
    12.46    81.49  287.92   4.81  98.14
sdb          0.00   7.84  5.88 41.18   54.90  180.39    27.45    90.20 =
    5.00     2.83  221.85   8.15  38.33

Why is sda getting all the IO?

--=20
Per Andreas Buer
Linpro AS / Ledende p=E5 Linux i Norge
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
