From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Tue, 15 Feb 2011 21:09:34 +0000
Message-ID: <4D5AEB8E.7030702@gmail.com>
References: <4D540F6C.6050904@gmail.com>	<20110215155315.55d35b8e@notabene.brown>	<4D5A92F3.1090004@turmel.org>	<4D5ACE4B.9040309@gmail.com>	<4D5AD613.3040402@turmel.org> <20110216004524.67abe977@natsu>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110216004524.67abe977@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I got my info from:

http://linux.die.net/man/8/blkid

"*blkid* is part the e2fsprogs package since version 1.26 and is 
available from http://e2fsprogs.sourceforge.net 
<http://e2fsprogs.sourceforge.net/>. "

I also did apt-file search blkid and it showed up as e2fsprogs or was it 
e2fs-utils (I forget).  The system I was/am running was Debian Lenny x64.

This just shows how little I know about Linux (I've only been dabbling 
for 6 months or so).  I'll install util-linux next time the machine 
start up.  Thanks for the pointer.

regards
Simon

On 15/02/2011 19:45, Roman Mamedov wrote:
> On Tue, 15 Feb 2011 14:37:55 -0500
> Phil Turmel<philip@turmel.org>  wrote:
>
>>> For some reason blkid doesn't exist on my machine even though I have
>>> e2fs-utils installed.  V weird.
> Weird is that you think it is somehow a "e2fs-utils" program.
>
> dpkg -S blkid
> ...
> util-linux: /sbin/blkid
> ...
>
>> FWIW, on my VPS running Ubuntu Server 10.10, the blkid executable is part of
>> util-linux, and installed in /sbin.  You might need to re-install it.
