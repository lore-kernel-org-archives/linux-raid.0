From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 8 Jan 2005 13:19:00 +0100
Message-ID: <200501081319.00799.maarten@ultratux.net>
References: <crmt7e$8d6$1@sea.gmane.org> <200501072157.j07Lvg906301@www.watkins-home.com> <croc94$kiu$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <croc94$kiu$1@sea.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 08 January 2005 11:22, Mario Holbe wrote:
> Guy <bugzilla@watkins-home.com> wrote:
> > Each of his six RAID5 arrays will only use 1 partition of each physical
> > disk.
> > His plan is to combine the 6 arrays with LVM or a linear array.
>
> Ah, I just missed that part, sorry & thanks :)
> I agree with you then - it's something like a RAID5+0 (analogue
> to RAID1+0) then and it *should* work just fine :)

Yes, it should.  And the array does indeed work, but I'm plagued with a host 
of other -unrelated- problems now. :-(
First, I had to upgrade from kernel 2.4 to 2.6 because I lacked a driver for 
my SATA card.  That was quite complicated as there is no official support to 
run 2.6 kernels on Suse 9.0. It also entailed migrating to lvm2 as lvm is not 
part of 2.6.  But as it turns out, the 2.6 kernel I eventually installed does 
somehow not initialize my bttv cards correctly and also ALSA has problems.  
So now I'm reverting back to a 2.4 kernel which should support SATA, version 
2.4.28, which I'm building as we speak from vanilla kernel sources...
But that has a lot of hurdles too, and I'd still have to find an ALSA driver 
for that as well.  Worse, I fear that I will have to migrate back to lvm1 now 
too, so that means copying all the 200 Gig data _again_, which by itself 
takes about 10 hours... :-(
Ah, if only I would have bought ATA disks instead of SATA !
I've thought about putting the disks in another system and just use them over 
NFS, but that would mean another system that is powered for 24/7, and that 
gets to be a bit much.  Reinstalling from scratch with a 9.1 / 2.6 distro is 
a worse option still, as mythtv carries such a bucket full of obscure 
dependencies I'd hate to install all that again. 

In other words, I'm not there yet, but at least that has little or nothing to 
do with lvm or md.  But this does 'suck' a lot.

Maarten

-- 

