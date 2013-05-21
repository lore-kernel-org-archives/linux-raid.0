From: Phil Turmel <philip@turmel.org>
Subject: Re: "Missing" RAID devices
Date: Tue, 21 May 2013 11:31:29 -0400
Message-ID: <519B9351.4050708@turmel.org>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Santos <iluvgadgets@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jim,

On 05/21/2013 08:51 AM, Jim Santos wrote:
> Hi,
> I recently upgraded my 2 disk RAID-1 array from 1.5TB to 2TB disks.
> When I started I had 10 MD devices. Since the last partition was
> small, I removed the filesystems and deleted the associated RAID
> device. The I created two new devices and split the extra 500 GB
> between them. Everything was good until I rebooted. Now two of the
> raid devices are 'gone'.

[snip /]

> Notice the Preferred Minor numbers. It looks like the two new RAID
> devices took over the devices with the highest minor numbers.

Preferred minors are only used when assembling with kernel internal
auto-assembly (deprecated), which only works on meta-data v0.90, and
only if an initramfs is not present.  Boot-time assembly is otherwise
governed by the copy of mdadm.conf in your initramfs.

You appear to have failed to update your initramfs.  This is complicated
by your failure to avoid mdadm's "fallback" minor numbers that are used
when an array is assembled without an entry in mdadm.conf.

> I don't know what I did to get into this situation, but could really
> use some help getting out of it.

mdadm is called by modern initramfs boot scripts to assemble raid
devices as they are encountered.  If the given device is not a member of
an array listed in mdadm.conf, mdadm picks the next unused minor number
starting at 127 and counting down.  Mdadm must have found the members of
your new arrays before it found members of the arrays your old
mdadm.conf listed for md127 and md126.

Any time you update your mdadm.conf in your root filesystem, you must
remember to regenerate your initramfs so mdadm has the correct
information at boot time (before root is mounted).

To minimize future confusion, I recommend you renumber all of your
arrays in mdadm.conf starting with minor number 1.  Then update your
initramfs.  Then reboot.

Your fstab uses uuids (wisely), so you don't need any particular minor
numbers.  So you can and should avoid the minor numbers mdadm will use
as defaults.

HTH,

Phil
