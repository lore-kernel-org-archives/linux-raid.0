From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm: hot add failed ... lun0/part6: No space left on device
Date: Sat, 31 Jan 2004 21:41:27 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16411.34391.455191.631246@notabene.cse.unsw.edu.au>
References: <20040130123211.GA10754@e-den.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sandro Dentella on Friday January 30
To: Sandro Dentella <sandro.dentella@tin.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday January 30, sandro.dentella@tin.it wrote:
> Hi all,
>   while trying to substitute a failed disk, I'm using the command:  
> 
>     # mdadm /dev/md1 --add /dev/ide/host0/bus1/target0/lun0/part6
> 
>   but I get:
> 
>   mdadm: hot add failed for /dev/ide/host0/bus1/target0/lun0/part6: No space left on device
> 
>   What does it mean?

It means, as you guess lower down, that the partition you have
provided appears to be too small to be used in the given array.

This error should cause a message to appear in the kernel logs
something like

   md1: disk size XXX blocks < array size YYY

You might finding it by
   dmesg | grep 'disk size'

or looking in some file in /var/log (depending on which distribution
you use.  Debian puts it in /var/log/kern.log).

> 
>   I don't know how to interpret it. I thought it was the partition that
>   is not same dime as the other one (disks are different) but the partition
>   I'm adding is bigger... as you can see further on.

Indeed I can:  hda6 appears to be 2533.688 - 533.439 = 2000.249 Mb
while hdc6 (the new one) is 2536.242 - 533.562 = 2002.680 Mb

My only guess is that the kernel hasn't found out about some recent
change in partition size.  What partition sizes are given in
   cat /proc/partitions
??

NeilBrown
