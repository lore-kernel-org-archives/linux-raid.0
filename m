From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid 1 with write only device?
Date: Fri, 5 Nov 2004 14:17:05 +1100
Message-ID: <16778.61617.745873.129886@cse.unsw.edu.au>
References: <1099624332.3131.104.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ming Zhang on Thursday November 4
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 4, mingz@ele.uri.edu wrote:
> Hi, folks?
> 
> I would like to know if current RAID1 support or willing to support a
> RAID1 with a write only device? For example, u can setup 2 disks to form
> a raid1, you fork 2 writes to both disks while you only read from one.
> this will be very useful for logging purpose or replication.

This functionality has been discussed, but have not been implemented
in a released kernel yet.

NeilBrown
