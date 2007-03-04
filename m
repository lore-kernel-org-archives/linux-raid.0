From: "Dan" <kasper37@netzero.com>
Subject: Unexpectedly slow raid1 benchmark results.
Date: Sun, 4 Mar 2007 04:47:19 -0800
Message-ID: <003801c75e5b$7db61bb0$bc01a8c0@apmsafe.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here are some bonnie numbers for a few tests:

2.6.20, only 1 drive active in md device (other drive pulled for testing):

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
testbox          7G 45165  76 55461   8 25677   5 53573  90 66251   7 194.1   0
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++
testbox,7G,45165,76,55461,8,25677,5,53573,90,66251,7,194.1,0,16,+++++,+++,+++++,
+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++

2.6.20, 2 drives in raid1:

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
testbox          7G 47633  80 56795  10 27598   5 53675  89 66643   7 283.6   0
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++
testbox,7G,47633,80,56795,10,27598,5,53675,89,66643,7,283.6,0,16,+++++,+++,+++++
,+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++

2.6.21-rc2 (for completeness), 2 drives in raid1:

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
testbox          7G 48128  83 56330  10 28183   5 53173  89 66425   6 307.1   0
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++
testbox,7G,48128,83,56330,10,28183,5,53173,89,66425,6,307.1,0,16,+++++,+++,+++++
,+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++

Just about the only stat in these tests that show a marked improvement between
one and two drives is Random Seeks (which makes sense).  What doesn't make sense
is that none of the Sequential Input numbers increase.  Shouldn't I be seeing
close to a 100% improvement?  Of course a 100% increase in performance is the
theoretical maximum, but these numbers show no improvement at all.  Both drives
are 320Gb Seagate 7200RPM Barracudas, part number ST3320620AS.  The motherboard
is a SuperMicro PDSME+.  Any insight will be appreciated.

Dan

