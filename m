From: Sevatio <sevatio@atella.com>
Subject: Re: Bootable Raid Problem
Date: Sat, 15 May 2004 09:40:02 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40A647E2.50606@atella.com>
References: <40A4E19F.4080405@atella.com> <40A60F4D.2020909@begu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40A60F4D.2020909@begu.net>
To: linux-raid@vger.kernel.org
Cc: Bernd Fischer <bernd@begu.net>
List-Id: linux-raid.ids

Bernd Fischer wrote:

> Sevatio wrote:
> 
>> I'm having a problem with md0.  It's supposed to bind hda5 and hdc5 
>> but it's only able to bring up hdc5 for md0.  md0 is being mounted as 
>> /boot.  Being that it's /boot, I can't seem to umount it to do 
>> anything to it. 
> 
> 
> I can't make much of this question, but I can tell you two things:
> 
> 1. You don't need to umount the device for most operations.
> 
> 2. You can umount next to anything, provided there are no opened files 
> there. Do a "lsof /boot", or perhaps "lsof | grep boot" and kill the 
> listed programs before trying umount (usually, it's only klogd reading 
> /boot/System.map).
> 
> Bernd Fischer
> 
> 

Thanks so much Bernd.  I was able to umount /boot so I can hopefully get 
to the raid1 portion of this problem.
