From: Alex Verbitsky <alexver5@mail.ru>
Subject: Re[2]: 3ware 7500 performance, was: experiences with 3Ware 6400 3W-6400?
Date: Sat, 28 Jun 2003 18:48:33 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <14867809384.20030628184833@mail.ru>
References: <Pine.LNX.4.44.0306281539510.24992-100000@uplift.swm.pp.se>
Reply-To: Alex Verbitsky <alexver5@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0306281539510.24992-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Mikael,

Saturday, June 28, 2003, 4:42:58 PM, you wrote:
MA> Which is exactly what we all get in real-life file server environment when
MA> using onboard RAID5 without a lot of onboard cache (though I have seen the
MA> same behaviour even on SX6000 with 128 meg ram). Filesystem read is
MA> phenomenally fast (I have seen 150 meg+ off of 8 disk arrays) but write is 
MA> very slow (5-10 meg/s).  Sequential write is also fast, but that never 
MA> happens in a fileserver environment.
Exactly. One seriously looking for good random write performance should use
RAID10 - it's nearly as fast as RAID0 on 3ware. But that's another
story - it's not so cheap.

BTW re RAID performance i can recommend this excelent testing
http://www.fcenter.ru/articles.shtml?hdd/2216#4

He tested 3w7810 but I believe for random access 7810 and 7500-8 is
equivalent. It is in Russian, but all significant info (diagrams, charts) in
English.

-- 
Best regards,
 Alex                            mailto:alexver5@mail.ru

