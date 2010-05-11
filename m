From: Keld Simonsen <keld@keldix.com>
Subject: layout of far blocks in raid10
Date: Tue, 11 May 2010 17:12:04 +0200
Message-ID: <20100511151204.GA3781@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

There is a quesition on block layout in the raid10 far layout,
that I would like to know more about.
For 4 drives, and with 2 copies (-n 4 -p n2)  I see several
possible layouts, 3 of them are, showing the beginning of each raid0 section:

Disks:
 a  b  c  d

Layout 1:

 1  2  3  4
..............

 4  1  2  3


Layout 2:

 1  2  3  4
..............

 3  4  1  2


Layout 3:

 1  2  3  4
..............

 2  3  4  1


This gives 3! combinations for double faliure, or in all 6 possibilities.

These are the combinations that will contain all blocks with only 2 working 
drives:

Layout 1: a+c, b+d will work, total 2 combinations
Layout 2: a+b, c+d, a+d b+c would work, total 4 combinations
Layout 3: a+c, b+d would work, total 2 combinations

So the best layout would be layout 2, as it provides a
4/6 chance = 67 % that it will survive the 2nd disk failure,
while the 2 others only have 2/6 = 33 % chance of surviving
the 2nd disk failure.

How is the "-n 4 -p f2" layout actually done?

I think one could do similar analyses for other numbers of drives.
Is there any general pattern one (algorithm) one could use?
I think one key is allocating  copies in pairs. Maybe more could be
gained by allocating the blocks in groups of powers of 2.
Or maybe the only gain comes from the grouping in pairs as there are
only 2 copies.

best regards
Keld
