From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: mdadm vs zfs for home server?
Date: Mon, 27 May 2013 23:09:59 -0400
Message-ID: <CAGExVfugwRUx3HPbaGKCMUcmM52YEb36tbarvzy0UVUXZTjYBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 27, 2013 at 2:09 PM, Matt Garman <matthew.garman@gmail.com> wrote:
>
>
> Anyone out there have a home (or maybe small office) file server
> that where they thought about native Linux software RAID (mdadm)
> versus ZFS on Linux?
>


I have a 4 x 1TB drive setup that was running CentOS 5 with mdadm and
ext4 for the last 4 years. About 3 weeks ago I reinstalled with CentOS
6 and ZFS on Linux. One of the deciding factors was I wanted the
previous version tab in Windows to function since I access the shares
mainly from Windows systems.

I've looked at LVM solutions in the past, but there were multiple
drawbacks. The recent LVM thin provisioning addresses some of the
issues, but it still was cumbersome and drawn out dealing with the
various layers.

I also looked at Solaris (OpenIndiana and OmniOS) and FreeBSD.
Obviously ZFS on Solaris just works and the performance seemed good.
However I'm not as familiar with Solaris and there isn't a large
community following for support. FreeBSD had terrible performance out
of the box accessing the Samba shares. I would see spikes where I
would get 70% of gigabit and then drop to 30% and back again. FreeBSD
seems to always require tweaking for performance, which seems
unnecessary when Linux has good performance out of the box.

Going back to CentOS 6 I followed the http://zfsonlinux.org/
directions and was up and running in minutes. Performance with Samba
was great and the system has been rock solid. Accessing shares from
Windows I can achieve 80-90% of gigabit. With ext4 I would see 90-100%
utilization on a large copy, but the features are worth the small
performance hit.

I did turn compression on and atime off. I also set the recommended
options for interoperability with Windows when creating the datasets.

zfs set compress=on data
zfs set atime=off data

zfs create -o casesensitivity=mixed -o nbmand=on data/share

I am using the https://github.com/zfsonlinux/zfs-auto-snapshot script
to create daily and weekly snapshots. You can disable snapshots per
zfs dataset with

zfs set com.sun:auto-snapshot=false data/share2

With CentOS 6.4 Samba 3.6.9 has support for the format option of the
vfs shadow_copy2 module. I added the following to /etc/samba/smb.conf
and the previous versions tab populated.

unix extensions = no

[share]
path = /data/share
wide links = yes
vfs objects = shadow_copy2
shadow: snapdir = .zfs/snapshot
shadow: format = zfs-auto-snap_daily-%Y-%m-%d-%H%M

I added a cron.d job to weekly scrub the array like the raid-check script does.

# Run system wide zfs scrub once a week on Sunday at 3am by default
0 3 * * Sun root /usr/local/sbin/zfs-scrub

Contents of the /usr/local/sbin/zfs-scrub file.

#!/bin/sh
for pool in `/sbin/zpool list -H | cut -f 1`
do
   /sbin/zpool scrub $pool
done

The only missing part is a script to check the zpool status command
for errors and send an email alert.

Ryan
