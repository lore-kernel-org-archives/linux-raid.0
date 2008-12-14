From: Michal Soltys <soltys@ziu.info>
Subject: Re: Raid 5 Problem
Date: Sun, 14 Dec 2008 23:55:19 +0100
Message-ID: <49458ED7.1030005@ziu.info>
References: <49450D04.8060703@nigelterry.net> <4945276E.1010405@ziu.info> <49456F94.8020100@nigelterry.net> <alpine.DEB.1.10.0812141552380.27065@p34.internal.lan> <4945735A.6030909@nigelterry.net> <alpine.DEB.1.10.0812141600430.27065@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812141600430.27065@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: nterry <nigel@nigelterry.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> You have another issue here though, it looks like your "few" attempts have
> lead to multiple RAID superblocks.  I have always wondered how one can 
> clean
> this up without dd if=/dev/zero of=/dev/dsk & (for each disk, wipe it) 
> to get
> rid of them all, you should only have [1] /dev/md0 for your raid 5, not 3.

Well - 0.9 superblock is 4K at 64K boundary, at least 64K from the end 
of the device, but less 128K (man 4 md). If a filesystem on some 
partition taking up that space *didn't* overwrite this space with its 
[meta]data (check with debugfs, xfs_db, etc.), just clean it up 
*carefully* with dd or hexeditor.

