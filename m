From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Linear raid extend component
Date: Sun, 30 Dec 2012 07:50:09 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1212300748150.17599@uplift.swm.pp.se>
References: <CE9AB803-93DD-4A9A-BA97-FD5F323833DE@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CE9AB803-93DD-4A9A-BA97-FD5F323833DE@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 29 Dec 2012, Adam Goryachev wrote:

> I have 3 RAID devices, 2 RAID1 which are then combined into a linear RAID. I've now replaced both drives of one of the RAID1 (from 2 x 1TB TO 2 x 3TB).
>
> I now want to grow the raid1 from 1TB to 3TB and then grow the linear to include the extra space. However, my concern is that if this is the first array in the linear I will corrupt the filesystem because there will be a big blank space in the middle.

You'd probably be better off using something that was meant to handle 
these cases, such as LVM instead of linear md-raid. The sooner you make 
this move the less problem you'll have down the line.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
