From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Linux raid wiki - setting up a system - advice wanted :-)
Date: Mon, 26 Sep 2016 04:16:22 +0200
Message-ID: <20160926021622.GA25056@metamorpher.de>
References: <57E83EA8.9060809@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57E83EA8.9060809@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Sep 25, 2016 at 10:16:24PM +0100, Wols Lists wrote:
> I need to know what will happen if you give entire drives to mdadm.

Installers will pick unpartitioned disks first. Forget just trashing 
the metadata, easy to accidentally write across the entire disk.

This is what it looks like when installing Windows: http://imgur.com/a/GtcR2 

Same can happen with Linux installers. Unpartitioned disks are just unusual. 

Not sure why this is a thing anyway. There's no downside to partitions. 
Adds a safety margin, is yet another place that has metadata (with GPT 
you can use mdnumber-role as partition name / partlabel), doesn't harm 
performance in any way...

People panic too much about partition alignment? But alignment is something 
you need to provide through all layers, all the way down to the filesystem, 
not just partitions. Besides, MiB alignment has been standard for years now, 
so this shouldn't be a problem.

The only other obscure issue with partition tables I can think of is 
enclosures for USB-HDD that emulate the wrong sector size (4K vs 512) 
and unfortunately GPT still depends on the sector size; and Linux is 
not flexible/smart enough to support alien sector size GPT partitions.

So if you switch HDD enclosures you might be forced to recreate 
the partition table before you can access your data.

Regards
Andreas Klauer
