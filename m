From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Curious code in autostart_array
Date: Thu, 22 Jun 2006 21:11:52 -0700
Message-ID: <449B6A08.4080506@zytor.com>
References: <20060622210521.0aa68ec6.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060622210521.0aa68ec6.zaitcev@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-raid@vger.kernel.org, mingo@redhat.com, dledford@redhat.com
List-Id: linux-raid.ids

Pete Zaitcev wrote:
> Hi, guys:
> 
> My copy of 2.6.17-rc5 has the following code in autostart_array():
> 		mdp_disk_t *desc = sb->disks + i;
> 		dev_t dev = MKDEV(desc->major, desc->minor);
> 
> 		if (!dev)
> 			continue;
> 		if (dev == startdev)
> 			continue;
> 		if (MAJOR(dev) != desc->major || MINOR(dev) != desc->minor)
> 			continue;
> 
> Under what conditions do you think the last if() statement can fire?
> What is its purpose? This looks like an attempt to detect bit clipping.
> But what exactly?
> 

It can fire if either desc->major or desc->minor overflow the respective 
fields in dev_t.  Unfortunately, it's not guaranteed to do so.

	-hpa
