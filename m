From: "Guy" <bugzilla@watkins-home.com>
Subject: Bad blocks
Date: Thu, 17 Feb 2005 03:30:45 -0500
Message-ID: <200502170830.j1H8Up924518@www.watkins-home.com>
References: <42144458.4040306@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <42144458.4040306@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

About 1 month ago the topic was bad blocks.  I have been monitoring the bad
blocks on my disks and I find I have had 3 new bad blocks since Jan 18.
Each on a different disk.  I have 17 disks, SEAGATE ST118202LC.

These bad blocks did not cause any problems with md.  I believe they were
readable or write errors, but re-mapped since I have AWRE and ARRE turned
on.

I don't know what is a normal rate, but based on the last month, I would
expect about 2.29 defects per disk per year.  I have had the disks in use
for about 2.5 years.  I have 81 defects.  That comes to 1.905 per disk per
year.  Not to far off the mark!  And I have replaced disks 2-3 times in 2.5
years.  The failed disks failed due to a cable problem, the disks may have
been just fine, but I took them apart for the magnets before I realized the
power cable was at fault.  The cable is now repaired.

Anyway, if these were read errors, md would have caused me lots of problems.
So, we need md to deal with bad blocks without kicking out the disk.

I have been using this command to monitor the disks:
sginfo -G /dev/sda | grep "in grown table"

My current bad block status (Defect list) for 17 disks:
0 entries (0 bytes) in grown table.
0 entries (0 bytes) in grown table.
8 entries (64 bytes) in grown table.
5 entries (40 bytes) in grown table.
0 entries (0 bytes) in grown table.
12 entries (96 bytes) in grown table.
20 entries (160 bytes) in grown table.
0 entries (0 bytes) in grown table.
6 entries (48 bytes) in grown table.
0 entries (0 bytes) in grown table.
6 entries (48 bytes) in grown table.
28 entries (224 bytes) in grown table.
0 entries (0 bytes) in grown table.
2 entries (16 bytes) in grown table.
3 entries (24 bytes) in grown table.
4 entries (32 bytes) in grown table.
0 entries (0 bytes) in grown table.

Does anyone know how many defects is considered too many?

Guy

