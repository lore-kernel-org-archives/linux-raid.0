From: jlewis@lewis.org
Subject: Re: Adaptec aacraid
Date: Sun, 14 Mar 2004 21:14:50 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0403142056490.1969@web1.mmaero.com>
References: <Pine.LNX.4.58.0403141803560.1969@web1.mmaero.com>
 <4054F4EA.8050805@adaptec.com> <Pine.LNX.4.58.0403141930000.1969@web1.mmaero.com>
 <40550010.1020603@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40550010.1020603@adaptec.com>
To: Scott Long <scott_long@adaptec.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 14 Mar 2004, Scott Long wrote:

> http://www.adaptec.com/worldwide/support/driverdetail.html?sess=no&language=English+US&cat=/Product/AAR-2810SA&filekey=asmbe_linux_v1.23.006.tgz

Same Storage Manager for the SATA and u320 cards?  They want me to fill
out a form to download that, and I'm afraid to try it tonight anyway.
I'll have someone put the CD in when there are sufficiently clued hands
available onsite.

> This is from the 2810SA download page, but should work fine for the
> 2200S.  I'm not sure why the apps packages are not posted for linux
> in the 2200S section.
>
> I'll pass this along to the person who is responsible for the aacraid
> RPMs.  I believe that the script is supposed to leave around a backup
> of the old modules and initrds.  Did it not in this case?

I just took another look, and actually what it did was much worse.  It
looks at grub.conf and then rm's modules from /lib/modules for all kernels
mentioned in grub.conf and then installs its own (if it has one).  This
left me with:

# rpm -V kernel-smp-2.4.20-30.9
.M......   /dev/shm
missing    /lib/modules/2.4.20-30.9smp/kernel/drivers/scsi/aacraid
missing    /lib/modules/2.4.20-30.9smp/kernel/drivers/scsi/aacraid/aacraid.o

and no aacraid module anywhere in /lib/modules/2.4.20-30.9smp/.

Fortunately, it didn't blow away the 2.4.20-30.9smp initrd, so I was able
to extract the missing module from that, and put it back in place.  I know
the system would have booted just fine (since the module was in the
initrd)...but man, that's _really_annoying_ behavior for an RPM.  I
haven't bothered reading the whole script (25kb), but AFAICT, it rm'd the
modules and did not leave backup copies of them anywhere I've looked.

----------------------------------------------------------------------
 Jon Lewis *jlewis@lewis.org*|  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
