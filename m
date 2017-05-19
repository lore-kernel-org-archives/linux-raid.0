From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: How to backup of large md raid volumes?
Date: Fri, 19 May 2017 11:34:22 +1000
Message-ID: <75dc802b-1572-3c6f-ed62-4333deece4c2@websitemanagers.com.au>
References: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com>
Content-Language: en-CA
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/05/17 07:37, Ram Ramesh wrote:
> Any one have a method to backup large volumes like md raid6 (16TB)? 
> Since the backup will not fit in one disk (in many cases and mine too) 
> I am wondering, if there is a known/easy technique to backup using 
> multiple usb hard drives. I googed and found a few fancy backup 
> utils/systems like Amanda etc. They are overkill for me. I am choosing 
> not to back up simply because of the complexity of setup as the data 
> in my RAID volume is NOT precious and can be replaced with a week of 
> effort.
>
> If any one can think of some thing simple, please point me to it and I 
> will do the reading to figure out.
>
I suppose it depends on what you want to achieve. There are various 
options such as mirroring to another raid6 array (ie, RAID60) but really 
that isn't a backup, it's another replica.
I use backuppc for my backups, it works well under linux with rsync, I'm 
sure there are many various options (including amanda which I've used in 
the past). Ultimately, it depends on your requirements, backups vary 
significantly depending on needs/etc.

Regards,
Adam


-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
