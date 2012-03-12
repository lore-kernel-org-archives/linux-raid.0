From: Wiliam Colls <william.colls@rogers.com>
Subject: Re: Can't Boot from /dev/md0 - Solved
Date: Mon, 12 Mar 2012 12:44:12 -0400
Message-ID: <4F5E27DC.4010306@rogers.com>
References: <4F5D38FD.4080803@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F5D38FD.4080803@rogers.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/11/2012 07:45 PM, Wiliam Colls wrote:
>
> Ubuntu 10.04 server, patched to date.
>
> This machine is configured to boot from a Raid1 array. The partitions
> are located on /dev/sdb1 and /dev/sdc1, the boot partition is located on
> /dev/sda1. This configuation has worked well for some time, but after a
> recent shutdown for maintenance, which did not involve any of the
> partitions, the machine refuses to boot. The sequence hangs very shortly
> after startup, and eventually errors out with the message /dev/md0 not
> available. and drops into the Busybox shell.
>
> After booting from a live rescue CD, and examining the partitions, they
> are all intact, and clean. They rescue CD was able to assemble the array.
>
> Not sure where to go from here. Any Suggestions will be greatfully
> received.
>
> William.
>
> PS. I am sure that I read some recent discussion on a very similar
> problem, but I can't find that material now. If anyone has a link, it
> also be greatfully received.
>

At least for now. After further investigation, I realised that the mdadm 
module was availalbe in the kernal, and I was able to assemble the array 
from the busybox prompt, and the boot will then continue normally. Still 
trying to determine what caused the problem and find a permanent fix.


-- 
I know that you believe that you understand what you think I said, but I 
am not sure that you realise that what you heard was not what I meant.
