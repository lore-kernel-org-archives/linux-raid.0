From: "Guy" <bugzilla@watkins-home.com>
Subject: raid5 performance after upgrade to 2.4.28
Date: Wed, 12 Jan 2005 01:17:13 -0500
Message-ID: <200501120615.j0C6FG929329@www.watkins-home.com>
References: <41E4B334.2020104@nsr500.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E4B334.2020104@nsr500.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

