From: Drew Dowling <drewhead@drewhead.org>
Subject: How to monitor Disk I/O using Promise Controler?
Date: Wed, 5 Feb 2003 09:08:54 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302051408.h15E8sDW027845@keep.drewhead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


	I've recently become interested in looking at disk io for my
server.  While /proc/stat has the info for the onboard ide, it lacks
mention of my Array.  Specfically I have Promise TX2 (20268R) with a pair
of 60 gigers plugged in mirrored only on a 2.4.18 kernel.
	A google search has led me to a lot of software raid software and
benchmarking tools such as tiobench.  However what I'm more interested in
is doing trending of useage over time.  If the info were in /proc/stat I'd
simply sample that every x intervals.  
	Is anyone with Promise controlers doing such a thing that could
space me a clue please?
- -- 
     Drew Dowling               Drewhead          http://www.drewhead.org
 drewhead@drewhead.org    |                    |    WWW      / \ Alpha Phi Omega
Concord, North Carolina   |                    |  Nimat     /   \  Gamma Lambda
CLEMSON UNIVERSITY ALUMNI |                    | Apatschin /_____\
      TIGER BAND!         |      VGAP4 Hosting at http://vgap.drewhead.org
-----BEGIN PGP SIGNATURE-----
Comment: Public key available at http://www.drewhead.org

iD8DBQE+QRru8J7U7yHE638RAoqIAJ9khXvPgQIW+8jYFB7B7bCDcnSCewCfWnpn
ezIhqSC1eBpgLrqyHZCLht8=
=rwVh
-----END PGP SIGNATURE-----
