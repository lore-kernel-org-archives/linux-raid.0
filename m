From: Stefan Lamby <webmaster@peter-speer.de>
Subject: Re: Raid 1 needs repair
Date: Thu, 4 Feb 2016 17:03:23 +0100 (CET)
Message-ID: <1161942166.457494.1454601803851.JavaMail.open-xchange@app01.ox.hosteurope.de>
References: <285536573.454192.1454595669809.JavaMail.open-xchange@app01.ox.hosteurope.de> <56B36577.2030902@turmel.org>
Reply-To: Stefan Lamby <webmaster@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56B36577.2030902@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good morning Phil.
I was hoping you are around - thanks for answering.
The distro is a ubuntu lts server version 14.04.

I was able to chroot und grub-install /dev/sdb.
The system is booting again. The md0-Array needs to be fixed now.

My docu for doing so is
mdadm --manage /dev/md0 --fail /dev/sda1    # mark as failed
mdadm --manage /dev/md0 --remove /dev/sda1  # remove failed disk from array
mdadm --manage /dev/md0 --add /dev/sda1     # add new disk to array (assumed
same or greater space for partition)

Can you confirm this?

Thanks for your help.

> Phil Turmel <philip@turmel.org> hat am 4. Februar 2016 um 15:51 geschrieben:
>
>
> Good morning Stefan,
>
> On 02/04/2016 09:21 AM, Stefan Lamby wrote:
> > Hi.
> > My md0 is broken because of a damaged sda.
> > It was simple to find out which on it is thanks to lsdrv by Mr Turmel.
>
> You're welcome. Side note: It looks like lsdrv couldn't find the pvs
> and lvs utilities to fully document your LVM setup. I'd be interested
> in knowing which distro and version that environment was.
>
> > Now I have a new disk, same size, as sda with sda1 partition - same size -
> > formatted as Linux raid autodetect.
> > In the end I like to end up with the new sda1 as member of md0 and I need to
> > put
> > my boot information there, since sdb1, also member of md0, seems to no have
> > no
> > such info because the system wasn't booting with a missing sda1.
>
> >From what I can see from your report, you probably only need to do
> grub-install /dev/sda and grub-install /dev/sdb
>
> The boot partition is mirrored for the bulk of grub's data, which means
> normal upgrades and config changes "just work", but a new drive needs a
> bootloader. That is outside the array in the space before the first
> partition.
>
> > I am afraid of loosing data, so I prefer asking, what to do next.
> > Please guide, I have the system up and running on a sysrescd live distro.
>
> I presume that means you booted a rescue CD and then used chroot to get
> a command prompt in your installed system. If not, grub-install
> probably won't work. Note that some distros use grub2-install.
>
> If the above doesn't work, let us know what it says.
>
> Phil
>
>
