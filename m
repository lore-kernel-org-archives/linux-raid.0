From: Neil Brown <neilb@suse.de>
Subject: Re: Question about build md.c in the kernel source tree
Date: Mon, 27 Mar 2006 20:48:00 +1100
Message-ID: <17447.46288.163877.546972@cse.unsw.edu.au>
References: <200603271618592181267@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Zhikun Wang on Monday March 27
Sender: linux-raid-owner@vger.kernel.org
To: Zhikun Wang <raidwang@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday March 27, raidwang@gmail.com wrote:
> Hi:
> 	I am reading linux software RAID(MD) source code. I want to add some "printk" information in the md.c file. But md.c has been build in the kernel. How can i only build the md.c file without building the whole kernel source tree? 
> 	Thanks a lot!

Edit .config
remove the line
          CONFIG_BLK_DEV_MD=y
run 'make oldconfig'
When it asks you about the md driver and 'm' for module rather than
'y' for yes.

Then md will be built as a module, producing md_mod.ko and raid*.ko.
These can then be loaded into the running kernel with 'insmod' and
removed with 'rmmod'.

NeilBrown


> 
> 																								zkwang
>   
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
