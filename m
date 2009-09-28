From: Frank Mori Hess <frank.hess@nist.gov>
Subject: raid6 recovery suboptimal
Date: Mon, 28 Sep 2009 09:31:16 -0400
Message-ID: <200909280931.19879.frank.hess@nist.gov>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hi,

I've got an 8 disk raid 6 array, and I've noticed recovery after adding a new 
disk with 7/8 disks active seems to be sub-optimal (with 6/8 disks active it 
seems fine).  To be more specific, with 7/8 disks active it seems to do extra 
reads from one of the active drives, slowing the recovery down to about 
30MB/sec on my machine (with 6/8 disks it recovers at about 50MB/sec).  Here 
is the output of "iostat -mx 10 /dev/sd?" during a recovery with 7/8 disks 
active (see the line for sdf in particular):

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00   13.48    0.00    0.00   86.52

	   Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz 
avgqu-sz   await  svctm  %util
	   sda               0.00  6365.60    0.00 1292.70     0.00    29.90    47.38     
1.61    1.25   0.38  48.52
	   sdb            6876.40     0.00  784.70    0.00    29.90     0.00    78.02     
2.14    2.73   0.52  40.76
	   sdc            6868.70     0.00  793.30    0.00    29.94     0.00    77.29     
1.92    2.44   0.47  37.60
	   sdd            6850.20     0.00  811.30    0.00    29.91     0.00    75.50     
2.09    2.58   0.48  38.84
	   sde            6860.80     0.00  800.20    0.00    29.90     0.00    76.52     
2.39    2.99   0.54  42.88
	   sdf            7953.50     0.00  664.10    0.00    33.60     0.00   103.63    
12.46   18.68   1.51 100.00
	   sdg            6851.20     0.00  810.50    0.00    29.93     0.00    75.62     
1.91    2.37   0.46  37.16
	   sdh            6836.40     0.00  825.20    0.00    29.91     0.00    74.24     
2.36    2.87   0.50  41.04


Most of the drives are being read at 30MB/sec, and the new drive is being 
written at the same speed.  However, sdf is being read at 34MB/sec, which 
puts its utilization at 100% (I guess due to the extra seeks) and is the 
limiting factor in the recovery (the other drives are at less than 50% 
utilization).

In contrast, when only 6/8 drives are active, all the active drives are read 
from evenly at 50MB/sec, and the new drive is written at the same rate.

Is this a known issue?  From what I understand of raid 5/6, I don't know of 
any reason it would need to do extra reads from one drive.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrAuqQACgkQ5vihyNWuA4XGiACaAhww4HQLQp3a/73s1WhHMpxL
0PwAoOPZUVn8X5FFn/bmsBNEk9/6HaaU
=zlB7
-----END PGP SIGNATURE-----
