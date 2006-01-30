From: Neil Brown <neilb@suse.de>
Subject: Re: raid not creating
Date: Mon, 30 Jan 2006 14:08:15 +1100
Message-ID: <17373.33567.411470.796966@cse.unsw.edu.au>
References: <57285.192.55.52.1.1138383357.squirrel@bugs.osu.edu>
	<17370.35932.856350.327787@cse.unsw.edu.au>
	<43DAD418.9040803@bugs.osu.edu>
	<17373.14913.427109.184586@cse.unsw.edu.au>
	<43DD7A27.6070806@bugs.osu.edu>
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
> > Neil Brown wrote:
> > 
> >>On Friday January 27, blata@bugs.osu.edu wrote:
> > 
> > 
> >>># mdadm --create --verbose /dev/md4 --level=1 --raid-devices=2 /dev/hde3
> >>>/dev/hdg3
> >>>mdadm: /dev/hde3 appears to contain an ext2fs file system
> >>>   size=35214480K  mtime=Thu Jan 26 13:38:20 2006
> >>>mdadm: /dev/hdg3 appears to contain an ext2fs file system
> >>>   size=35214480K  mtime=Thu Jan 26 13:38:20 2006
> >>>mdadm: size set to 35214400K
> >>>Continue creating array? y
> >>>mdadm: SET_ARRAY_INFO failed for /dev/md4: Device or resource busy
> > 
> > 
> >>Sounds like /dev/md4 already exists.  What does
> >>  cat /proc/mdstat
> >>show?
> > 
> >>NeilBrown
> > 
> > 
> > cat /proc/mdstat
> > Personalities :
> > md2 : inactive hdc3[0]
> >       8723200 blocks
> > md3 : inactive hdg1[0]
> >       61440448 blocks
> > md4 : inactive hdg3[0]
> >       35214400 blocks
> > md1 : inactive hdc2[0]
> >       20482752 blocks
> > md0 : inactive hdc1[0]
> >       104320 blocks
> > unused devices: <none>

So md4 (and others) is partially created.  If you
  mdadm --stop /dev/md4
  mdadm --create --verbose /dev/md4 --level=1 --raid-devices=2 /dev/hde3 /dev/hdg3

it should work.


> > 
> > I got this only after doing the following.
> > 
> > mdadm --manage --add /dev/md2 /dev/hdc3
> > 

I guess you are trying to add devices to non-existent arrays... Maybe
mdadm should complain about that...

> > for each md device.  If I then go back and try to add /dev/hda1 to the md0
> > I get this.
> > 
> > mdadm --manage --add /dev/md0 /dev/hda1
> > mdadm: add new device failed for /dev/hda1: Device or resource
> > busy

Maybe hda1 is currently in use?  Maybe it is mounted as a filesystem?

What exactly are you trying to achieve?

NeilBrown
