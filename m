From: "Riley Williams" <Riley@Williams.Name>
Subject: RE: MD drivers problems on 2.4.x
Date: Mon, 26 May 2003 08:09:48 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <BKEGKPICNAKILKJKMHCACEEPEBAA.Riley@Williams.Name>
References: <200305260817.20409.ebenard@free.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200305260817.20409.ebenard@free.fr>
To: Eric BENARD / Free <ebenard@free.fr>, Juri Haberland <juri@koschikode.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Eric.

 >>> I would like to know what is the md driver status on 2.4.19
 >>> and 2.4.20 kernels ? I've got many problems with RAID 0 (/tmp),
 >>> 1 (/, /usr/var) and 5 (/home) using these kernels and 4 IDE
 >>> drives with ext3 partitions. In the end each time I lose all
 >>> the data :-(
 >>>
 >>> After many tests (RAM is OK, HD don't have bad blocks), I think
 >>> the problems comes from the md layer.
 >>>
 >>> May a switch to 2.4.21-rc3 solve my problems ?
 >>>
 >>> Did anyone here already meet this problem ?

 >> Sorry, no problems here. /, /home, swap and the other stuff all
 >> on RAID1 and humming along.
 >>
 >> We need more data from you. What is failing in which way? Any
 >> error messages, kernel oopses?

 > in fact, I don't get to much error messages (or they were not
 > reported to me by the user of this PC). I'm using a Promise
 > PDC20277 IDE controller (with pseudo RAID functions but I'm not
 > using them).

OK so far...

 > 4 Western Digital 120 GB with 8MB of cache are connected
 > (Master/slave with good cables) to it.

There was a thread on one of the Linux lists recently about Western
Digital drives that just plain vanished from the systems they were
installed in, and apparently several people were having the same
problem. Memory says it was 120 GB drives they were talking about,
but I could easily be wrong about that as I don't have the relevant
thread to hand.

You may wish to check that it isn't the actual drives that are at
fault here as the problem appeared to be specific to that one size
of drive, with the other sizes not experiencing the problem.

Failing that, there have been reports of problems with RAID setups
when drives are connected to both master and slave slots on the same
controller channel, with the recommendation that only one drive be
connected to each controller channel.

Best wishes from Riley.
---
 * Nothing as pretty as a smile, nothing as ugly as a frown.

---
Outgoing mail is certified Virus Free.
Checked by AVG anti-virus system (http://www.grisoft.com).
Version: 6.0.483 / Virus Database: 279 - Release Date: 19-May-2003

