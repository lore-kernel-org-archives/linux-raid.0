From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Fwd: Identify SATA Disks
Date: Thu, 24 May 2007 23:00:30 +0200
Message-ID: <20070524210030.GF6533@boogie.lpds.sztaki.hu>
References: <8c4e120705230023v71a2ffa3p182f1e02ccb9cd54@mail.gmail.com> <8c4e120705231629q727718f2yb0704ff33b7012c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8c4e120705231629q727718f2yb0704ff33b7012c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: lewis shobbrook <lewis@blue-matrix.org>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 24, 2007 at 09:29:04AM +1000, lewis shobbrook wrote:

> I've noted that device allocation can change with the generation of
> new initrd's and installation of new kernels; i.e. /dev/sdc becomes
> /dev/sda depending upon what order the modules load etc.
> I'm wondering if one could send a looped read/write task to a swap
> partition or something to determine which the device is?

If you're using a relatively modern distro with udev then you can use
paths under /dev/disk/by-{id,path}. Unless you're using a RAID card that
hides the disk IDs...

> Also I've not had much joy in attempting to "hotswap" SATA on a live 
> system.
> Can anyone attest to successful hotswap (or blanket rule out as
> doesn't work) using std on board SATA controllers,  cf dedicated raid
> card, or suggest further reading?

Make sure you have a chipset that supports hotplug (some older ones do
not). Make sure its driver supports hotplug. Make sure you stop using
the disk before pulling it out (umount, swapoff, mdadm --remove,
pvremove whatever). Power down the disk before pulling it out if your
backplane/enclosure does not do that for you. Then it should work.

If the chipset does not support sending interrupt on hotswap or if the
driver does not implement hotswap signalling, you may need explicit
"scsiadd -r" before yanking out the old drive and "scsiadd -s" after
inserting the new one.

Also remember that this area is rather new and still evolving, so be
sure to try the latest kernel if you encounter problems.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
