From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Linux raid wiki - setting up a system - advice wanted :-)
Date: Mon, 26 Sep 2016 13:40:53 +1000
Message-ID: <2f6bd11c-3232-7548-288e-3a503c160d31@websitemanagers.com.au>
References: <57E83EA8.9060809@youngman.org.uk>
 <20160926021622.GA25056@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160926021622.GA25056@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/09/16 12:16, Andreas Klauer wrote:
> On Sun, Sep 25, 2016 at 10:16:24PM +0100, Wols Lists wrote:
>> I need to know what will happen if you give entire drives to mdadm.
> Installers will pick unpartitioned disks first. Forget just trashing
> the metadata, easy to accidentally write across the entire disk.
>
> This is what it looks like when installing Windows: http://imgur.com/a/GtcR2
>
> Same can happen with Linux installers. Unpartitioned disks are just unusual.
>
> Not sure why this is a thing anyway. There's no downside to partitions.
> Adds a safety margin, is yet another place that has metadata (with GPT
> you can use mdnumber-role as partition name / partlabel), doesn't harm
> performance in any way...
>
> People panic too much about partition alignment? But alignment is something
> you need to provide through all layers, all the way down to the filesystem,
> not just partitions. Besides, MiB alignment has been standard for years now,
> so this shouldn't be a problem.
>
> The only other obscure issue with partition tables I can think of is
> enclosures for USB-HDD that emulate the wrong sector size (4K vs 512)
> and unfortunately GPT still depends on the sector size; and Linux is
> not flexible/smart enough to support alien sector size GPT partitions.
>
> So if you switch HDD enclosures you might be forced to recreate
> the partition table before you can access your data.
>
Personally, I agree, avoiding a partition table has almost zero benefit. 
Having a partition table can help massively (ie, clearly identifies the 
drive as in-use, shows the content of the drive/partition (RAID), etc....
I would think using a USB interfaced drive in a raid array is hopefully 
not common, and changing the enclosure should be even less common, 
though perhaps likely when dealing with failures.... Can you comment on 
the behaviour of removing the drive from the enclosure and direct 
connecting it? What is the worst case scenario here?
When you say forced to recreate the partition table, I assume in the 
majority of cases it is just delete and re-create using 100% of 
available space, or is there some other difference (eg, the gap at the 
beginning of the drive that might require some searching for the right 
value)?

Regards,
Adam



-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
