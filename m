From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RAID Halting: Final Result
Date: Sat, 16 May 2009 22:59:59 -0500
Message-ID: <20090517040003649.VLMT15274@cdptpa-omta02.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


	Well, after one day shy of three weeks of transferring files, the
system finally finished transferring data from the backup server to the main
RAID server Wednesday night.  As I mentioned in another thread, I then tore
down the LVM array, added two 1.5T drives, and rebuilt it as a 7 drive RAID
5 array.  I formatted the new backup array as XFS, and allowed the array to
resync.  I am now using rsync to copy all the files back to the backup array
from the main array, and all is looking very good.  The rsync is reaching
sustained peaks of over 420 Mbps at Layer II, and I can create and delete
files - large or small - with impunity.  Here are the results from
concatenating three large files to one, then deleting the large file, all
whie the rsync process is going on in the background.  (Note the transfer
rate did drop to under 100 Mbps while the file copy was going on, so it
looks like it may the RAID array which limits the transfer speed.  This is
not surprising - especially since I am using a single inexpensive SATA
controller and 3 port multipliers - but it also is not problematical.)  The
transfer should now take less than 2 days.

RAID-Server:/RAID/Recordings/Lord of the Rings# time `cat "1 Lord of the
Rings- The Fellowship of the Ring, The (Recorded Fri Apr 04, 2008,
TNTHD).mpg" "2 Lord of the Rings- The Two Towers, The (Recorded Sat Apr 05,
2008, TNTHD).mpg" "3 Lord of the Rings- The Return of the King, The
(Recorded Sun Apr 06, 2008, TNTHD).mpg" > testfile`

real    71m8.154s
user    0m2.568s
sys     2m35.482s
RAID-Server:/RAID/Recordings/Lord of the Rings# time rm testfile

real    0m1.052s
user    0m0.000s
sys     0m0.004s

The system copied three 20G files into a fourth 60G file in under 75
minutes, and then deleted the result in just over 1 second.

