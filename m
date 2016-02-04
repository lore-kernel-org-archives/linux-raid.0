From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 1 needs repair
Date: Thu, 4 Feb 2016 09:51:35 -0500
Message-ID: <56B36577.2030902@turmel.org>
References: <285536573.454192.1454595669809.JavaMail.open-xchange@app01.ox.hosteurope.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <285536573.454192.1454595669809.JavaMail.open-xchange@app01.ox.hosteurope.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Lamby <webmaster@peter-speer.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good morning Stefan,

On 02/04/2016 09:21 AM, Stefan Lamby wrote:
> Hi.
> My md0 is broken because of a damaged sda.
> It was simple to find out which on it is thanks to lsdrv by Mr Turmel.

You're welcome.  Side note:  It looks like lsdrv couldn't find the pvs
and lvs utilities to fully document your LVM setup.  I'd be interested
in knowing which distro and version that environment was.

> Now I have a new disk, same size, as sda with sda1 partition - same size -
> formatted as Linux raid autodetect.
> In the end I like to end up with the new sda1 as member of md0 and I need to put
> my boot information there, since sdb1, also member of md0, seems to no have no
> such info because the system wasn't booting with a missing sda1.

From what I can see from your report, you probably only need to do
grub-install /dev/sda and grub-install /dev/sdb

The boot partition is mirrored for the bulk of grub's data, which means
normal upgrades and config changes "just work", but a new drive needs a
bootloader.  That is outside the array in the space before the first
partition.

> I am afraid of loosing data, so I prefer asking, what to do next.
> Please guide, I have the system up and running on a sysrescd live distro.

I presume that means you booted a rescue CD and then used chroot to get
a command prompt in your installed system.  If not, grub-install
probably won't work.  Note that some distros use grub2-install.

If the above doesn't work, let us know what it says.

Phil

