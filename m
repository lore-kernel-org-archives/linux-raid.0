From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Recreate raid 10 array
Date: Wed, 08 Apr 2009 14:57:22 -0700
Message-ID: <1239227842.18515.8.camel@cichlid.com>
References: <49DA5CE6.7030902@gmx.net> <87prfpdm8y.fsf@frosties.localdomain>
	 <49DD1B87.2050804@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49DD1B87.2050804@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, LCID Fire <lcid-fire@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2009-04-08 at 17:47 -0400, Bill Davidsen wrote:
> Goswin von Brederlow wrote:
> > mdadm --create --assume-clean -l 10 -n 4 /dev/mdX /dev/copied_disk_1 /dev/copied_disk2 missing missing
> >
> > You need to match the create parameters exactly with the ones you
> > initially used (near/offset/farcopies? stripe size? ...) and the order
> > of devices is relevant so you might have to shuffle the disk
> > arguments. So just try different orders till the result can be mounted
> > or fscked. With the wrong options the mount/fsck could screw up the
> > data but then you copy the disk again for the next try. It should be
> > reasonably obvious when mount/fsck goes wrong as it should find tons
> > of errors. Mostly I would expect mount/fsck to just fail with the
> > wrong mdadm args though.

Most fscks can be told to run read-only so they won't write to the
device and also interactive so they ask before writing so you should be
able to avoid recopying. The ext3 journal recovery violates at least one
of these IIRC (or used to) so if it's ext3 find an option to tell it to
ignore the journal.

> May I say that this makes a great case for saving the contents of some 
> files to a safe place when the system is up and running right.? Maybe 
> all of /etc, and at least a "tree /sys" and /proc/mdstat would be 
> useful, preferably on something readable like a CD or USB flash drive, 
> so you have a chance of reading it if you can't boot.
> 
> Of course a rescue flash drive is pretty useful as well, so that's 
> probably the way to go.

It's a good idea

It also seems like mdadm could be enhanced to figure stuff like this out
given intact device superblocks (I suggest --wild-ass-guess as the
option name)

