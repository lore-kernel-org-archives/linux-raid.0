From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm -D /dev/md3: 1  0  0  0  sync ???
Date: Thu, 23 Dec 2004 09:52:16 +1100
Message-ID: <16841.64160.683580.423091@cse.unsw.edu.au>
References: <41C9D08A.5080303@avz.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ferenc-Jan on Wednesday December 22
Sender: linux-raid-owner@vger.kernel.org
To: Ferenc-Jan <ferenc@avz.xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 22, ferenc@avz.xs4all.nl wrote:
> Hello list,
> 
> Does anybody know what this means:
> 
> # mdadm -D /dev/md3
> <snip>
>      Number   Major   Minor   RaidDevice State
>         0       3        6        0      active sync   /dev/hda6
>         1       0        0        0      sync
> 
>         2      22        6        2      active sync   /dev/hdc6
> 
> Please help. Which disk is '1  0  0  0  sync'? The array is currently 
> degraded. How do I remove number 1 and bring number 2 up?

This is a missing drive, that is marked as in-sync, which is bad.  
I don't know how it happened, but the best way to fix it is to remake
the array:

   umount ....
   mdadm -S /dev/md3
   mdadm -C /dev/md3 -R -l1 -n2 /dev/hda6 missing
   mdadm /dev/md3 -a /dev/hdc6

should make it work.  It won't destroy any data

NeilBrown
