From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Raid Problem - Unknown File System Type
Date: Wed, 9 Nov 2011 17:07:16 +0000 (GMT)
Message-ID: <alpine.DEB.2.00.1111091703480.4604@unicorn.drogon.net>
References: <4EBAA68B.6090906@rogers.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBAA68B.6090906@rogers.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 9 Nov 2011, William Colls wrote:

> Environment
>
> Kubuntu Linux 10.04.3 LTS
> mdadm 2.6.7.1-1ubuntu15
>
> I have two identical disks that were in a raid configuration in another 
> machine (also running 10.04). I removed them from the old machine, mounted 
> them in a new machine, booted up, and at a terminal prompt as root issued
>
> mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc

Did you mean create or assemble?

If you used create it would have nuked all the data - including partition 
table and filesystem..

... actually, I don't know the precise mechanism for a create on raid 1 - 
if it just copies one disk to the other, then the data might well be 
intect if you can recover the partition table, but if it writes zeros to 
both disks then you're out of luck ...

Gordon
