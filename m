From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: Question about build md.c in the kernel source tree
Date: Mon, 27 Mar 2006 13:40:16 -0500
Message-ID: <1143484816.25634.33.camel@localhost.localdomain>
References: <200603271618592181267@gmail.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200603271618592181267@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhikun Wang <raidwang@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

* pls add a text wrap at ~80 in u email client.

* once u build whole kernel once, and u only make change in md.c, u can
do kernel redo and make process will automatically only rebuild md.c.
then u install the new kernel and check u changes.

ming


On Mon, 2006-03-27 at 16:19 +0800, Zhikun Wang wrote:
> Hi:
> 	I am reading linux software RAID(MD) source code. I want to add some "printk" information in the md.c file. But md.c has been build in the kernel. How can i only build the md.c file without building the whole kernel source tree? 
> 	Thanks a lot!
> 
> 																								zkwang
>   
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

