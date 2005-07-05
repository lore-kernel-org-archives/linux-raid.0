From: Ming Zhang <mingz@ele.uri.edu>
Subject: skip raid5 reconstruction
Date: Tue, 05 Jul 2005 13:22:47 -0400
Message-ID: <1120584167.5535.56.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi folks

I am testing some HW performance with raid5 with 2.4.x kenrel.

It is really troublesome every time I create a raid5, wait 4 hours for
reconstruction, and then test some data and then recreate another one
and wait again. I wonder if there is any hack or option available to
create a raid5 without reconstruct the parity disk. I just have interest
to test the performance so do not care about data correctness at this
stage.

Thanks!


Ming




