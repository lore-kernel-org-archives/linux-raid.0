From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm create problem with existing bitmap file
Date: Mon, 23 Aug 2010 12:15:27 +1000
Message-ID: <20100823121527.61ca1ca4@notabene>
References: <4C6EB877.1050602@datagardens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C6EB877.1050602@datagardens.com>
Sender: linux-raid-owner@vger.kernel.org
To: Juan Aristizabal <jaristizabal@datagardens.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 20 Aug 2010 11:16:39 -0600
Juan Aristizabal <jaristizabal@datagardens.com> wrote:

> Hello,
> 
> I am using mdadm 2.6.3 on Ubuntu 8.04.3 32 bits. Sometimes I hit this 
> error when I try to create a RAID1:
> 
> mdadm --create --force --assume-clean /dev/md73 --level=1 
> --bitmap=/root/bitmaps/md73bm.tmp --raid-devices=2 /dev/vg1/vol1 
> --write-mostly /dev/sdj
> 
> Continue creating array? mdadm: failed to open bitmap file 
> /root/bitmaps/md73bm.tmp: Text file busy
> 
> The bitmap file exists, but lsof doesn't show that it is in use by any 
> other process.
> 
> If I copy the bitmap file and try the create again everything works fine.
> 
> Any idea what might be happening here?

My best guess is that some other array is already using that bitmap file.  
   cat /proc/mdstat
should show you.
There aren't many circumstances that can create Text file busy - either the
file must be a binary that is being run, or a swap-file for which swapon has
been run, or the file is a bitmap file for an md array (maybe there are some
others, I cannot be bothered to grep just now).

NeilBrown


> 
> 
> Thanks,
> 
>  
> Juan Aristizabal
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

