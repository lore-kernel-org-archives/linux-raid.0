From: Neil Brown <neilb@suse.de>
Subject: Re: [bug?] raid1 integrity checking is broken on 2.6.18-rc4
Date: Mon, 28 Aug 2006 13:47:17 +1000
Message-ID: <17650.26437.447617.467168@cse.unsw.edu.au>
References: <200608171605_MC3-1-C870-8190@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chuck Ebbert on Thursday August 17
Sender: linux-raid-owner@vger.kernel.org
To: Chuck Ebbert <76306.1226@compuserve.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday August 17, 76306.1226@compuserve.com wrote:
> 
> I just tried the patch and now it seems to be syncing the drives instead
> of only checking them?  (At the very least the message is misleading.)
> 

Yes, the message is misleading.  I should fix that.

NeilBrown


>  # echo "check" >/sys/block/md0/md/sync_action
>  # dmesg | tail -9
>  md: syncing RAID array md0
>  md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
>  md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
>  md: using 128k window, over a total of 104256 blocks.
>  md: md0: sync done.
>  RAID1 conf printout:
>   --- wd:2 rd:2
>   disk 0, wo:0, o:1, dev:hda9
>   disk 1, wo:0, o:1, dev:sda5
> 
