From: Peter Daum <gator_ml@yahoo.de>
Subject: Frequent "verify failed" on 3ware RAID mirror
Date: Sat, 28 Jan 2006 11:57:30 +0100
Message-ID: <drfimq$uds$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a bunch of servers with (mostly) 3ware 8506-8 adapters. All
machines are running kernel 2.6.x on mirrored disks with ext3 file
systems. I check the RAID systems integrity every night by running
"tw_cli maint verify".

Pretty much on all machines, on some more frequently than on others
(it seems like machines running postgresql database servers are
particularly affected), the verify fails from time to time, forcing a
subsequent rebuild. I have been trying to isolate the problem for
quite some time now and can rule out that there is any hardware
(disks, cables ...) problem. Since all machines are at least
occasionally affected, it also doesn't seem to be a malfunction of a
particular controller but a general problem with all such controllers.

I sent a support request to 3ware support but only got a boilerplate
answer. All I could find searching the web was a note in the 3ware
knowledge base (http://www.3ware.com/KB/article.aspx?id=13247) that
seems to refer to a similar scenario. As far as I understand, they
blame it on the ext2 file system sending multiple write requests for
the same disk location, which could cause a verify error if the data
gets overwritten before it has been written to the 2nd disk. It seems
like this could only cause false alarm if the verify checked a disk
block that at the same time still has a write request in the works
(Which statistically should not be very likely on 200 GB disks with
controllers that have only 2 MB memory on an almost idle machine).

Has anybody here seen anything like this? Any ideas what is going on?
It seems like 3ware controllers are pretty popular in the Linux
community so I assume there must be others having similar problems ...

Regards,
                       Peter Daum

