From: Ming Zhang <mingz@ele.uri.edu>
Subject: write only raid1
Date: Wed, 10 Nov 2004 09:20:18 -0500
Message-ID: <1100096418.3190.4.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

sorry that i must missed u reply.

is there any technical issue that lead not to be implemented?

is there any place to find previous discussion on this? i try the google
but fail. i do no know which key word can find that. thx.

ming

On Thursday November 4, mingz@ele.uri.edu wrote:
> Hi, folks?
> 
> I would like to know if current RAID1 support or willing to support a
> RAID1 with a write only device? For example, u can setup 2 disks to
form
> a raid1, you fork 2 writes to both disks while you only read from one.
> this will be very useful for logging purpose or replication.

This functionality has been discussed, but have not been implemented
in a released kernel yet.

NeilBrown


