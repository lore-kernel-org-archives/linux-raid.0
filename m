From: Sandro Dentella <sandro.dentella@tin.it>
Subject: Re: RAID design
Date: Sat, 12 Jul 2003 19:34:30 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030712173430.GA8599@bluff.diade.it>
References: <000201c3480a$9c7ebbd0$27e703ca@magnus> <Pine.LNX.4.43.0307120912550.6220-100000@unicorn.drogon.net> <2168.208.48.139.163.1058030561.squirrel@www.greenhydrant.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2168.208.48.139.163.1058030561.squirrel@www.greenhydrant.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Not neccessarily. Modern motherboards will boot of either on-board
> > controller, so if the primary failed, then the master drive on the 2nd
> > controller ought to be able to boot. It's worth checking your motherboard
> > though. All the systems I've built in the past 2-3 years like this have
> > had this ability. You may need to physically unplug the failed drive
> > though (and reboot) if it fails in a way that make it look like it's still
> > active.

   You also need to install GRUB (od lilo) on both disks, as I
   understand. Reallu I never understood how to do that from living hard
   disk, so I normally need to install GRUN from floppy the first time it
   starts. 

   I normally do the following from a CD that I use to make istallations from

grub --batch <<EOT
device (hd0) $DEVICE1
root (hd0,0)
setup --prefix=/grub (hd0,0)
quit
EOT

grub --batch <<EOT
device (hd1) $DEVICE2
root (hd1,0)
setup --prefix=/grub (hd1,0)
quit
EOT

   but this often fails installing correctly. If I start from a floppy in
   which I have:

title Install GRUB into (hd0,0) the first disk
root    (hd0,0)
setup   (hd0)
 
title Install GRUB into (hd1,0) the second disk
root    (hd1,0)
setup   (hd1)
   
   It never fails. Hany clues?

   Thanks
   sandro	
   *:-)



-- 
Sandro Dentella  *:-)
e-mail: sandro.dentella@tin.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
