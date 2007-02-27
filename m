From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux Software RAID Bitmap Question
Date: Tue, 27 Feb 2007 12:42:23 -0500
Message-ID: <45E46D7F.9000501@tmr.com>
References: <Pine.LNX.4.64.0702250903120.21821@p34.internal.lan> <17890.24681.249414.635536@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17890.24681.249414.635536@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> When md find a bad block (read failure) it either fixes it (by
> successfully over-writing the correct date) or fails the drive.
>
> The count of the times that this has happened is available via
>    /sys/block/mdX/md/errors
>   
What kernel provides this? I have system running everything from 2.6.15 
to 2.6.20-get14, and there is no such file in any of them. There is a 
per-device errors file one level down, but that presumably wouldn't be 
in the superblock.

Do I have to go from 0.90 to v1 or later superblocks to get this, and if 
so is that a safe thing to do?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

