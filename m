From: Lem <l3mming@iinet.net.au>
Subject: Re: RAID5 producing fake partition table on single drive
Date: Sun, 10 Sep 2006 15:59:28 +1000
Message-ID: <1157867968.3920.4.camel@localhost.localdomain>
References: <1155987607.7207.23.camel@localhost.localdomain>
	 <17641.25141.373827.77279@cse.unsw.edu.au>
	 <1156200453.19051.13.camel@fc6.xsintricity.com>  <44FC68A8.4010002@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FC68A8.4010002@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Doug Ledford <dledford@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2006-09-04 at 13:55 -0400, Bill Davidsen wrote:

> May I belatedly say that this is sort-of a kernel issue, since 
> /proc/partitions reflects invalid data? Perhaps a boot option like 
> nopart=sda,sdb or similar would be in order?

Is this an argument to be passed to the kernel at boot time? It didn't
work for me.

