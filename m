From: "Daniel Korstad" <dan@korstad.net>
Subject: RE: RAID 6 grow problem
Date: Sun, 3 Jun 2007 18:33:28 -0500
Message-ID: <H00000670006c6c4.1180913607.www.korstad.net@MHS>
References: <C287AF46.7EDF%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C287AF46.7EDF%groups@email.iain.rauch.co.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: groups <groups@email.iain.rauch.co.uk>
Cc: jpiszcz <jpiszcz@lucidpixels.com>, linux-raid <linux-raid@vger.kernel.org>, neilb <neilb@suse.de>
List-Id: linux-raid.ids

As I understand it, you have to get 2.6.21.  The raid 6 reshape code was not added until this latest kernel.

If your apt-get only has, 2.6.20 version, your distro (whatever flavor) might not have released a cook version for 2.6.21.

I run Fedora.  An older version, FC4.  In Fedora, the update utility is yum but since mine is older, there are no longer updates for me.

You have a couple options, if your distro/version is still supported for updates, wait for them to release a new one for 2.6.21.

Or, get the vanilla source.  This is what I had to do since my version is considered legacy and no new updates are coming my way.

The source can be found; http://www.kernel.org/

Compiling a kernel is not too hard, a bit time consuming depending on your hardware but unfortunately a bit more involved than just adding a line to the config and a reboot as you mentioned previously.

It varies a bit among distros.  You may want to do a search and check some forums for your distro.  They might have a good howto for your distro.

For me (Fedora) the basics are;
1. Download the vanilla source
2. As root decompress it to /usr/src/ 

bzip2 -d linux-2.6.21.3.bz2 

3. Change to the new kernel directory 

cd /usr/src/linux-2.6.21.3

4. If you wish to apply some kernel patch, do so before the next step. As an example: (optional)

patch -p0 < kernel.patch

5. Put the kernel source in a proper/clean state: 

make mrproper

6. Setup /usr/src/linux Softlink: 

cd /usr/src/;  ln -s linux-2.6.21.3 linux

7. The .config file contains EVERYTHING specific to the kernel you compile. You must have a starting .config file or it will be too difficult to select the right set of options.  I grabbed one from my old source that is specific for my processor type: 

cd /usr/src/linux
cp /usr/src/redhat/BUILD/kernel-2.6.11/linux-2.6.11/configs/kernel-2.6.11-x86_64.config .config

Hopefully for you, your old source will not be quite as old as mine.  You will see what I mean in the make oldconfig step...

8. As an option you can change the EXTRA name attached to the end of the kernel, for example: 1.1369_FC4. Open /usr/src/linux/Makefile in any editor (gedit, kwrite, nano, etc.), and go to line 4.
EXTRAVERSION = -raid6reshape
You can change this value to ANYTHING you like. The result will be that yourkernel name will be something like:2.6.21.3-raid6reshape

9. Bring the .config file up to date to match the new kernel. 

make oldconfig

This will prompt for many new options. If you know what they are, answer them correctly. Otherwise just hit [Enter]

Since my old config was from a very old source, I had a ton of prompts for all the new wonderful features and changes that the old config did not address.  Be sure to hit enter to take the defaults unless you know what you are doing.

The one exception, if you see CONFIG_MD_RAID5_RESHAPE= 
Be sure to answer yes.

10. Once done, configure all the necessary options in the kernel by using any of the following:

text based questions:	make config
text based GUI:		make menuconfig
GTK based GUI:		make gconfig
QT based GUI:		make xconfig	(recommended but you need to be in xwindows)

Be VERY CAREFUL when changing things with which you are unfamiliar. If you do not know what it is, leave it to the default value. Some things I personally change are the processor type to match my AMD, and add NTFS in the filesystem support to be able to read a friend's usb hard drive when all he uses is windows...

Oh, and check to see that RAID5 RESHAPE feature is included.

11. This step may take between 15min - 2hours depending on the speed of your system

make all

If that did not work, research the error and try to disable the troublesome module or feature in the Configure step above.  Sometimes I get too crazy and disable too many things or enable too many things that were not the default and it breaks. 

If that worked correctly install it.  

12. make modules_install
13. make install

Depending on your distro type, these steps may or may not work exactly as shown.

After you are done and reboot to the new kernel, Grow your raid.

For me, I had a RAID6 with 8 drives.  I added an 9th.

mdadm --add /dev/md1 /dev/sdj1
mdadm --grow /dev/md1 --raid-devices=9

After mdamd finishes (watch cat /proc/mdstat  this will take hours) the filesystem the needs to be expanded to fill up the new space.

fsck.ext3 /dev/md1
resize2fs /dev/md1


or for me, I am using XFS;

xfs_growfs /dev/md1


After a few hours all was done and it all worked great.

Good luck!!

And thanks to all for the work to bring in reshape for RAID6.  I had been waiting a while for this. 

Chalk one up for a successful RAID6 reshape here!

Cheers,
Dan.

-----Original Message-----
From: Iain Rauch [mailto:groups@email.iain.rauch.co.uk] 
Sent: Saturday, June 02, 2007 5:36 PM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Justin Piszcz
Subject: Re: RAID 6 grow problem

>>> raid6 reshape wasn't added until 2.6.21.  Before that only raid5 was
>>> supported.
>>> You also need to ensure that CONFIG_MD_RAID5_RESHAPE=y.
>> 
>> I don't see that in the config. Should I add it? Then reboot?
> 
> You reported that you were running a 2.6.20 kernel, which doesn't
> support raid6 reshape.
> You need to compile  2.6.21 kernel (or
>    apt-get install linux-image-2.6.21-1-amd64
> or whatever) and ensure that CONFIG_MD_RAID5_RESHAPE=y is in the
> .config before compiling.

There only seems to be version 2.6.20 does this matter a lot? Also how do I
specify what is in the config when using apt-get install?

>> I used apt-get install mdadm to first install it, which gave me 2.5.x then I
>> downloaded the new source and typed make then make install. Now mdadm -V
>> shows "mdadm - v2.6.2 - 21st May 2007".
>> Is there anyway to check it is installed correctly?
> 
> The "mdadm -V" check is sufficient.

Are you sure because at first I just did the make/make install and mdadm -V
did tell me v2.6.2 but I don't believe it was installed properly because it
didn't recognise my array nor did it make a config file, and cat
/proc/mdstat said no file/directory??


Iain


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


