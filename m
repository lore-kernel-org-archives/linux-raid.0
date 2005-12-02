From: Neil Brown <neilb@suse.de>
Subject: Re: Data errors on clean, degraded Raid5. Help Please.
Date: Fri, 2 Dec 2005 14:47:56 +1100
Message-ID: <17295.50156.217214.617838@cse.unsw.edu.au>
References: <d39ad6430512011852g47d155a7i3f03db36996c01b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Erich Newell on Friday December 2
Sender: linux-raid-owner@vger.kernel.org
To: Erich Newell <erich.newell@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 2, erich.newell@gmail.com wrote:
> 
> Which generates errors when I try and copy off large amounts of data:
>      About ten of these:
>           ata1: translated ATA stat/err 0x25/00 to SCSI SK/ASC/ASCQ 0x4/00/00
>           ata1: status=0x25 { DeviceFault CorrectedError Error }
>           SCSI error : <0 0 0 0> return code = 0x8000002
>           sda: Current: sense key: Hardware Error
>           Additional sense: No additional sense information
>           end_request: I/O error, dev sda, sector 489794513

Sounds like there is something badly wrong with your hardware.  I've
no idea what though ... maybe a bad cable??

> 
> Should I do this:
>     > fsck -n -c /dev/md0
>     > mdadm --assemble /dev/md0
>     > mdadm --add /dev/md0 /dev/sdb3

The ordering looks wrong (you cannot fsck before you assemble) , but
it is probably your best bet (assume you don't have ongoing hardware
errors). 

> 
> or this:
>      > mdadm -c /dev/md0 -l 5 -n 4 -x 0 -f /dev/sdd3 /dev/sdc3
> /dev/sdb3 /dev/sda3
>      > mdadm -S /dev/md0
>      > mdadm --assemble --update=resync /dev/md0

You mean '-C', not '-c', and the last two steps are pointless after
the first.  But your first option is probably best, not that there is
liekly to be a big difference in the result.

> 
> or ???
> 
> If anyone has this knowledge, please share. I'm in over my head on this one.
> 
> Thanks in advance!
> 
> P.S. I am currently running a non-distructive badblock check while I
> wait for expert advice:

That's a good idea.  I would do that on all the devices... in parallel.

NeilBrown
