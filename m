From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5 performance after upgrade to 2.4.28
Date: Wed, 12 Jan 2005 02:44:59 -0500
Message-ID: <200501120743.j0C7h2929495@www.watkins-home.com>
References: <200501120615.j0C6FG929329@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501120615.j0C6FG929329@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now the bad news...

I have 2 CPUs  P3-500Mhz, 512Meg ram.  So I ran 2 bonnies at the same time.

Kernel 2.4.20-8 with 2 Bonnies at the same time:
Version  1.03 ------Sequential Output------ --Sequential Input- --Random-
              -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine  Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
watkins-ho 1G  3091  85 18593  44  9733  24  3443  97 59895  60 249.6   6
watkins-ho 1G  2980  87 21176  54 10167  23  3478  99 44525  44 384.2   9
               ----     -----     -----      ----    ------     -----
Total          6071     39769     19900      6921    104420     633.8

Kernel 2.4.28 with 2 Bonnies at the same time:
watkins-ho 1G  4456  92 17922  52  6489  17  4961  96 26571  32 320.4  12
watkins-ho 1G  4343  89 17987  52  6197  17  4946  96 25646  31 363.7   7
               ----     -----     -----      ----    ------     -----
Total          8799     35909     12686      9907     52217     684.1

Very odd, the sequential read speed is almost exactly 1/2 now.

Oh well, I still can't tell without a tool to measure the speed.
But I still don't like it!

My network is only 100BaseT, so it is still well beyond that!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Guy
Sent: Wednesday, January 12, 2005 1:17 AM
To: linux-raid@vger.kernel.org
Subject: raid5 performance after upgrade to 2.4.28

About 1 month ago I upgraded from Kernel 2.4.20-8 to 2.4.28.
Today I noticed my sequential read speed is up by about 12%.

I don't recall making any other changes that would affect speed.
So, I guess the Kernel upgrade made the difference.

An old bonnie output:
Version  1.03 ------Sequential Output------ --Sequential Input- --Random-
              -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine  Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
watkins-ho 1G  3293  97 34587  89 22306  53  3549  99 67492  63 500.1   9

Today:
watkins-ho 1G  4944  99 31719  65 18538  43  5184  98 75440  71 602.5   8
               ^^^^                          ^^^^     ^^^^^     ^^^^^

Some things improved, others decreased.

Of course, no change I can notice on my own.
I needed to measure performance to notice.

I guess I should try Kernel 2.6 some day.

Guy

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

