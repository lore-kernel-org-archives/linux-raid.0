From: Neil Brown <neilb@suse.de>
Subject: Re: RAID1 and load-balancing during read
Date: Tue, 11 Sep 2007 16:11:40 +0200
Message-ID: <18150.41500.375266.283053@notabene.brown>
References: <200709102229.30655.jimis@gmx.net>
	<20070910193530.GB2597@teal.hq.k1024.org>
	<200709102251.37976.jimis@gmx.net>
	<20070911034417.GA20596@teal.hq.k1024.org>
	<877imxibj2.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Goswin von Brederlow on Tuesday September 11
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Dimitrios Apostolou <jimis@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 11, brederlo@informatik.uni-tuebingen.de wrote:
> 
> I found that near copies behave like raid1, offset copies are slower
> in both reading and writing (beats me why) and far copies are slightly
> faster than near copies in write and twice as fast in read. All for
> sequential read/write. For random writes far copies should be slower
> to write.

I would expect read performance on an 'offset' layout to be
significantly affected by the chunk size.

You probably want the chunk size to be about 4 times the cylinder
size.
The ideal would be exactly the cylinder size, and exactly aligned to
cylinders.  But as cylinder sizes change across the device, this is
not possible.

Unfortunately I don't know how big cylinders are.  I suspect if you
hunt through the docs for the device you might find out.

NeilBrown
