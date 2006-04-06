From: "Mike Snitzer" <snitzer@gmail.com>
Subject: mdadm > 2.2 ver1 superblock regression?
Date: Thu, 6 Apr 2006 17:18:54 -0400
Message-ID: <170fa0d20604061418t6bd1d6d7yad02290e93fb04d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When I try to create a RAID1 array with ver 1.0 superblock using mdadm
> 2.2 I'm getting:
WARNING - superblock isn't sized correctly

Looking at the code (and adding a bit more debugging) it is clear that
all 3 checks fail in super1.c's calc_sb_1_csum()'s "make sure I can
count..." test.

Is this a regression in mdadm 2.4, 2.3.1 and 2.3 (NOTE: mdadm 2.2's
ver1 sb works!)?

please advise, thanks.
Mike
