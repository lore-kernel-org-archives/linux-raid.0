From: Bernd Fischer <bernd@begu.net>
Subject: Re: Linux RAID setup
Date: Sun, 10 Oct 2004 00:25:49 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4168656D.3030502@begu.net>
References: <20041009122106.650.qmail@web60410.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041009122106.650.qmail@web60410.mail.yahoo.com>
To: poonamsbox@yahoo.com
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Poonam Dalya wrote:

>  3. Then I worrked with the following command.

>  bash2-2.05b# mdadm --create /dev/md0 --level=0
>  --chunk=128 --raid-disks=2 /dev/hda5 /dev/hda4

Are you sure about that? You are trying to create a RAID0 array using 
two partitions on the same physical device. This will result in abysmal 
performance, which is exactly what you don't want.


Bernd Fischer

