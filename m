From: Neil Brown <neilb@suse.de>
Subject: Re: Strange intermittant errors + RAID doesn't fail the disk.
Date: Sat, 1 Jul 2006 11:10:24 +1000
Message-ID: <17573.52096.655463.808666@cse.unsw.edu.au>
References: <bb145bd20606300932x2268822k78561e549996aef3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christian Pernegger on Friday June 30
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 30, pernegger@gmail.com wrote:
> More problems ...
> 
> As reported I have 4x WD5000YS (Caviar RE2 500 GB) in a md RAID5
> array. I've been benchmarking and otherwise testing the new array
> these last few days, and apart from the fact that the md doesn't shut
> down properly I've had no problems.
> 
> Today I wanted to finally copy some data over, but I after 5sec I got:
> 
> [...]
> ata2: port reset, p_is 8000000 is 2 pis 0 cmd 44017 tf d0 ss 123 se 0
> ata2: status=0x50 { DriveReady SeekComplete }
> sdc: Current: sense key: No Sense
>     Additional sense: No additional sense information
> ata2: handling error/timeout
> ata2: port reset, p_is 0 is 0 pis 0 cmd 44017 tf 150 ss 123 se 0
> ata2: status=0x50 { DriveReady SeekComplete }
> ata2: error=0x01 { AddrMarkNotFound }
> sdc: Current: sense key: No Sense
>     Additional sense: No additional sense information
> [repeat]
> 
> All processes accessing the array hang and can't even be killed by
> kill -9, but md does not mark the disk as failed.

Looks very much like a problem with the SATA controller.
If the repeat look you have shown there is an "infinite" loop, then
presumably some failure is not being handled properly.

I suggest you find a SATA related mailing list to post this to (Look
in the MAINTAINERS file maybe) or post it to linux-kernel.

I doubt this is directly related to the raid code at all.

Good luck :-)

NeilBrown


> 
> I then tested all four disks individually in another box -- according
> to WD's drive diagnostic they're fine. Re-created the array on the
> disks, which worked for a few hours, now I get the same error again.
> :(
> 
> Kernel is 2.6.17-1-686 (Debian testing). I could go back to 16, but 15
> is missing a CIFS change I need.
> 
> Any help is appreciated.
> 
> Christian
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
