From: Michal Soltys <soltys@ziu.info>
Subject: Re: mdadm ignoring homehost?
Date: Thu, 02 Apr 2009 00:47:18 +0200
Message-ID: <49D3EEF6.8050601@ziu.info>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jon Nelson wrote:
> I have a raid1 comprised of a local physical device (/dev/sda) and a
> network block device (/dev/nbd0).
> When the machine hosting the network block device comes up, however,
> it creates /dev/md127.
> Why?
> 

Likely due to udev. Stock udev rules for md devices create with names as 
seen by kernel. When mdadm assembles arrary with non standard name, the 
suitable kernel name will be chosen, often md127 or md_d127 depending on 
the scheme (regular, or legacy partitionable)

> On the machine hosting the network block device, /dev/sdb is what
> backs /dev/nbd0.
> This is physical storage for /dev/nbd0:
> 
> ...
> 
> As you can see, the "Name" attribute is "turnip:11". The hostname is
> "frank". Why did frank bring up the device?

Homehost is secondary to ARRAY - so if you have ARRAY line and all 
metadata matches (or appropriate switches on the commandline) - the 
array will be assembled regardless of the hostname.

> The only thing in frank's /etc/mdadm.conf is "HOMEHOST frank" which I
> didn't think was necessary anyway.
> 

If the only thing there is that HOMEHOST line, and you're trying to 
assembly using just mdadm -As, then the assembly shouldn't succeed, afaik.
