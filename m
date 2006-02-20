From: Neil Brown <neilb@suse.de>
Subject: Re: NVRAM support
Date: Tue, 21 Feb 2006 10:16:47 +1100
Message-ID: <17402.19935.232688.24742@cse.unsw.edu.au>
References: <43EC5655.1060504@web.de>
	<20060210124204.GC28676@harddisk-recovery.com>
	<43ECB4A4.6010005@tmr.com>
	<Pine.LNX.4.64.0602101700540.30925@twinlark.arctic.org>
	<20060213092204.GB3209@harddisk-recovery.nl>
	<43F2E526.9010409@web.de>
	<17395.45710.99321.522482@cse.unsw.edu.au>
	<43F9926E.6040104@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mirko Benz on Monday February 20
Sender: linux-raid-owner@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 20, mirko.benz@web.de wrote:
> Hello,
> 
> We have applications were large data sets (e.g. 100 MB) are sequentially 
> written.
> Software RAID could do a full stripe update (without reading/using 
> existing data).
> Does this happen in parallel? If yes, isn't that data vulnerable when a 
> crash occurs?

md/raid5 does full stripe writes about 80% of the time when I've
measured it while doing large writes.  I'm don't know why it is not
closer to 100%.  I suspect some subtle scheduling issue that I
haven't managed to get to the bottom of yet (I should get back to
that).

Data is only vulnerable if, after the crash, the array is degraded.
If the array is still complete after the crash, then there is no loss
of data.

NeilBrown
