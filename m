From: James Fillman <jfillman@cucbc.com>
Subject: just how dangerous is this??
Date: Tue, 28 May 2002 10:55:11 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200205281055.11601.jfillman@cucbc.com>
Reply-To: jfillman@cucbc.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


I've got a large number of linux server to build and I'm using SuSE's ALICE 
install program to build them. ALICE is SuSE's auto install program and has 
limited functionality. Most importantly, it doesn't do RAID. So what I'm 
doing is having ALICE partition two drives with the partitions being of type 
"FD". It installs linux just fine on "sda" and when it's all done, I boot a 
rescue disk, and do a "mkraid -c ./raidtab --really-force /dev/md[0-4]" to 
create the mirrors. I'm just trying it out now and it seems to be working but 
I've got very little experience working with SoftRAID and I thought I'd ask 
if I'm playing with fire!!

the mkraid command warns me that it will delete all the data on the partitions 
when creating the mirrors, but it doesn't. 

What sort of implications am I looking at with this? Will it be unstable?


cheers,
- -- 
#########################
#  James Fillman
#  Linux Systems Architect
#  CUCBC
#
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE888R/B2UIX/PVkc0RAgDaAJ9zSa6lglc6+U6YtBQOlEi2IrmU0ACffnez
2AXqeuFKQUELieKfree5nJo=
=u7iJ
-----END PGP SIGNATURE-----

