From: Maxim Frolov <wrungel@web.de>
Subject: Re: Re: RAID1 failure recovery
Date: Tue, 14 May 2002 07:56:52 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200205140556.g4E5upX09454@mailgate5.cinetic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I checked the partition type of my  RAID1 disk. It was FreeBSD (not 0xFD  - Linux Raid Autodetect)!

I changed it to 0xFD.
I changed also boot=/dev/hda to boot=/dev/md0 in my lilo.conf and everything began working well!

Thanks a lot to all people in this mailing list, who helped me with my problem!


---------------
Maxim Frolov


Neil Brown <neilb@cse.unsw.edu.au> schrieb am 10.05.02:
> > My questions is: How do I recover the failed RAID1 disk (dev/hda1)?
> > What I did wrong?
> > 
> You forgot to set the partition time of /dev/hda1 to "Linux RAID
> autodetect" or whatever it is meant to be.


Alvin Oga <aoga@Maggie.Linux-Consulting.com> schrieb am 11.05.02:
> hi ya maxim
> 
> i'd also double check lilo.conf 
> 	boot=/dev/md0
> 	...
> 	root=/dev/md0
> 
> i've seen people use 
> 	boot=/dev/hda   
> 
> 	and make  different one on /dev/hdc w/ boot=/dev/hdc
> 
> what did suse-8 do to these lilo configs??
> 
> and as neil says...  check that its FD partition type ( not ext2 )

michael@insulin-pumpers.org schrieb am 10.05.02:
> change the partiton type to FD
> > 

________________________________________________________________
Keine verlorenen Lotto-Quittungen, keine vergessenen Gewinne mehr! 
Beim WEB.DE Lottoservice: http://tippen2.web.de/?x=13


