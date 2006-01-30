From: Neil Brown <neilb@suse.de>
Subject: Re: raid not creating
Date: Mon, 30 Jan 2006 16:17:10 +1100
Message-ID: <17373.41302.629136.871372@cse.unsw.edu.au>
References: <57285.192.55.52.1.1138383357.squirrel@bugs.osu.edu>
	<17370.35932.856350.327787@cse.unsw.edu.au>
	<43DAD418.9040803@bugs.osu.edu>
	<17373.14913.427109.184586@cse.unsw.edu.au>
	<43DD7A27.6070806@bugs.osu.edu>
	<17373.33567.411470.796966@cse.unsw.edu.au>
	<43DD9DEB.7060502@bugs.osu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wade Pinkston on Sunday January 29
Sender: linux-raid-owner@vger.kernel.org
To: Wade Pinkston <blata@bugs.osu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday January 29, blata@bugs.osu.edu wrote:
> > 
> > What exactly are you trying to achieve?
> > 
> > NeilBrown
> > 
> I live in California and this server is in Ohio  ~3000 mi away.  Any way I
> am rebuilding it remotely do some problems from a few months ago.  Anyway I
> had someone in Ohio format the four drives.  I was then left with a system
> on drives a and e.  Now after the fact I'm trying to get the software raid
> working on a-c e-g.  but I am unable to do so using mdadm.  I'm trying to
> coordinate this with my Ohio counterpart when he is available.
> 
> At this point I am thinking that I need to have him boot the box into
> rescue mode issue the mdadm commands, edit the fstab file and then reboot.
>  Does this sound like a feasible approach?

Feasible, but maybe not ideal.

If you have an active root filesystem on 'a' and want to have it on a
mirrored pair 'a' and 'c', the normal approach, which I'm sure is
documented in some HowTo somewhere - look for "linux root raid" or
similar - is to:

 1/ create the mirrored pair with only one active device:

    mdadm --create /dev/md0 -l1 -n2 missing /dev/hdc1

 2/ create a filesystem there and copy the data over

    mkfs -j /dev/md0
    mount /dev/md0 /mnt
    cp -ax / /mnt
 
 3/ Arrange that you will boot of md0 at next boot.
   e.g. in lilo.conf
  
       append = "md=0,/dev/hdc1 root=/dev/md0"

   
 4/ reboot, and hopefully find yourself with /dev/md0 as root.

 5/ add the old root partition into the array

     mdadm /dev/md0 --add /dev/hda1

 6/ make sure hda1 gets included in future. e.g.
   change the lilo.conf line to

      append = "md=0/dev/hda1,/dev/hdc1 root=/dev/md0"

Good luck.

NeilBrown

