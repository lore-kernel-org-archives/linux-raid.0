From: "J. Ryan Earl" <ryan@dynaconnections.com>
Subject: RE: RAID1 & 2.6.9 performance problem
Date: Tue, 18 Jan 2005 11:32:54 -0600
Message-ID: <OMEKLMBKKEOEENCKLEIDAEFGCAAA.ryan@dynaconnections.com>
References: <41EBD827.80701@pipi.ma.cx>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41EBD827.80701@pipi.ma.cx>
Sender: linux-raid-owner@vger.kernel.org
To: Janusz Zamecki <janusz@pipi.ma.cx>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Please check this out:

hdparm -t /dev/hdg /dev/hde /dev/md6

/dev/hdg:
  Timing buffered disk reads:  184 MB in  3.03 seconds =  60.76 MB/sec

/dev/hde:
  Timing buffered disk reads:  184 MB in  3.01 seconds =  61.08 MB/sec

/dev/md6:
  Timing buffered disk reads:  184 MB in  3.03 seconds =  60.74 MB/sec

I've expected much better /dev/md6 performance (at least 100MB/s)."

This is perfectly normally, I'm not sure why you'd expect better
performance.  You will get 2 parallel sequential reads at around 120MB/sec
assuming you're not bus limited.  A single sequential parallel read can be
no faster than the performance of a single RAID1 disk, though latency should
lower significantly.  I found that average number of read seeks/sec
increases around 80% in going from a single HD to a RAID1 setup.

Think about it and it should make sense.  You have two discs with identical
layouts.  How could you possibly increase the speed of a single sequential
read?  You can't just read half from one drive, half from the other, you'd
always have heads seeking and it would no longer be a sequential read.

-ryan

