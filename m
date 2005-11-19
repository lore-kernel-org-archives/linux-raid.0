From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: raid5 reliability (was raid5 write performance)
Date: Sat, 19 Nov 2005 17:30:25 -0200
Message-ID: <17279.32081.740196.178730@fisica.ufpr.br>
References: <437EB0A6.8040807@h3c.com>
	<200511190556.jAJ5uaw16109@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200511190556.jAJ5uaw16109@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy (bugzilla@watkins-home.com) wrote on 19 November 2005 00:56:
 >Assume a single stripe has data for 2 different files (A and B).  A disk has
 >failed.  The file system writes a 4K chunk of data to file A.  The parity
 >gets updated, but not the data.  Or the data gets updated but not the
 >parity.  The system crashes or power fails.  The system recovers, but can't
 >do anything about the parity with a failed disk.

But this is just the case Neil mentioned: an unclean degraded array.
This is the only case where data corruption can appear.

 >Also, after a power failure, I have seen the system come back with a single
 >disk failed.  I guess that 1 disk had an expired superblock.

You mean the disk was fine and operating in the array before the power
failure? If so the superblocks were all in sync. If one of the
superblocks was different the array was already degraded and after the
power failure it'll also be dirty, and we're back at the case above.

 >When you add that disk back, any stripes that were not up to date
 >will be re-constructed with invalid data.

If the array was not degraded the reconstruction data will not be
invalid. Only the parity will be rebuilt and no data corruption will
happen.

 >I don't know if the intent logging will help here or not.

It won't change anything, it only helps to accelerate the resync by
not re-writing stripes that were up to date.
