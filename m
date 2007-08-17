From: Neil Brown <neilb@suse.de>
Subject: Re: MD Raid5 rebuild problems - md: sde has invalid sb, not importing!
Date: Fri, 17 Aug 2007 11:03:58 +1000
Message-ID: <18116.62462.616627.109914@notabene.brown>
References: <200708162358.51671.denrdc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from rdc on Thursday August 16
Sender: linux-raid-owner@vger.kernel.org
To: rdc <denrdc@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday August 16, denrdc@gmail.com wrote:
> Hello
> 
> During a motherboard upgrade, I did something rather stupid : rewrite grub to 
> the bootsector of my bootdisk ( or so i thought ), but due to the new board 
> and thus a new device order I ended up destroying the beginning of 1 disk of 
> a 6 disk raid5 array. No worries, but after completly zeroing the "bad" disk, 
> i can't add it anymore. 
>  
....
> I get an error, and the following in the kernel log 
> 
> 	md: sde has invalid sb, not importing! 
> 	md: md_import_device returned -22 
>  

Very odd..
Please report which kernel version and mdadm version you are using,
and the exact sizes of each of the devices in the array (e.g. cat
/proc/partitions). 

Thanks,
NeilBrown
