From: linux-raid@zerog.net
Subject: Raidreconf w/ 2.6.2
Date: Thu, 20 May 2004 17:18:13 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0405201717090.30889-100000@arctic.zerog.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,


I'm hoping someone can shed some light on an issue I'm having:  Running
raidreconf on a raid5 array, growing from 5 x 160GB to 6x160GB, reiserfs,
raidreconf dies with two hash marks remaining to go.

I have backups of the important stuff, however, the rest of it would be a
pain to recreate.  Is there any way to recover what is there?  I'm
guessing that most of the block structure has been arranged in the 6 disk
configuration already?  If that is the case, can I simply run mkraid with
the new configuration and then reiserfsck to pick up the remaining blocks?

Thanks for any info or assistance you can give.



-steffan-

linux-raid {at} zerog net



