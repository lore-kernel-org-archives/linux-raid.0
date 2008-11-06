From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: metadata format 00.90 unknown, ignored
Date: Thu, 06 Nov 2008 20:00:40 +0100
Message-ID: <49133ED8.4010409@rabbit.us>
References: <837a927a0811061051heb9081fr51217068eede302e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <837a927a0811061051heb9081fr51217068eede302e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leandro Tracchia <ltracchia@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leandro Tracchia wrote:
> i'm not sure exactly what i did wrong and i wouldn't mind starting
> over only i'm not sure how.
> 
> i created a raid level 1 array using 2 disks.
> 
> mdadm --create /dev/md0 --level=1 --raid-devices=2   /dev/sda   /dev/sdc
> 
> ...
> 
> 
> mdadm --assemble /dev/md0 /dev/sda1 /dev/sdc1
> 

/dev/sda1 != /dev/sda

Cheers :)
