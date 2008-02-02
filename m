From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: raid1 and raid 10 always writes all data to all disks?
Date: Sun, 3 Feb 2008 00:53:35 +0100
Message-ID: <20080202235335.GA29029@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 I found a sentence in the HOWTO:

"raid1 and raid 10 always writes all data to all disks"

I think this is wrong for raid10.

eg

a raid10,f2 of 4 disks only writes to two of the disks -
not all 4 disks. Is that true?

best regards
keld
