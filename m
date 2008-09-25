From: sminded <daniel.zetterman@gmail.com>
Subject: Faster read performance DURING (?) resync on raid10
Date: Thu, 25 Sep 2008 02:27:51 -0700 (PDT)
Message-ID: <19666016.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have done some automated scripted tests with bonnie++ over RAID10 and
encryption, using different encryption cipher modes to evaluate the impact
on I/O operations.
The strange thing is that I can see a significant increase in read
performance (about 20%) when running the tests DURING the raid resync phase
directly after the raid creation as appose to running it after the resync,
or after I create the array with --assume-clean (which skips initial
resync).

Have anyone noticed the same behaviour, and how can it be explained? Any
ideas?

Can someone else verify that they get the same result?


-- 
View this message in context: http://www.nabble.com/Faster-read-performance-DURING-%28-%29-resync-on-raid10-tp19666016p19666016.html
Sent from the linux-raid mailing list archive at Nabble.com.

