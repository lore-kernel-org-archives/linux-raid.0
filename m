From: Phil Turmel <philip@turmel.org>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Wed, 1 Mar 2017 12:23:42 -0500
Message-ID: <27373f29-a8ea-012c-102d-9fadf05cb3c2@turmel.org>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
 <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
 <20170224084024.4dfe83a2.ian_bruce@mail.ru>
 <1e40da0d-b175-9ff5-d2e5-cf1f25aacc26@turmel.org>
 <c23b2aca-b6e6-37b8-3238-e59423d8f5a7@youngman.org.uk>
 <aee1f55b-cedf-15e9-5865-7fc0cdf9a188@turmel.org>
 <58B2137B.6070608@youngman.org.uk>
 <5172e2ab-e193-477b-52c4-86fbab0d52fe@turmel.org>
 <58B21987.6060604@youngman.org.uk>
 <657e80e9-b1f5-1f58-a4d0-6cbc4cc44927@turmel.org>
 <58B6E287.9020804@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58B6E287.9020804@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, ian_bruce@mail.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/01/2017 10:02 AM, Wols Lists wrote:

> Sorry to drag this up again, but where are these write intent bits
> going to come from? And it's a backup. Why am I going to re-add,
> unless I'm going to wipe the old backup and create a new one?

Given your process below, it's moot.

> And your way is more complicated - more room for sys-admin cock-up
> :-)

I strongly disagree.  This procedure, as shown, is an admin cock-up:

> mdadm --build /dev/mdbackup --device-count 2 /dev/md/home missing
> ... hotplug sd-big ...
> madam /dev/mdbackup --add /dev/sd-big
> ... wait for sync to finish ...
> mdadm --stop mdbackup
> ... unplug sd-big ...

Are you unmounting /dev/md/home while this is going on?  If not, and
there's any significant activity, your "backup" is corrupt.  If you are
unmounting, your data is unavailable for the duration of the resync.

The corresponding procedure for logical volume in LVM would be:

# lvcreate -n homesnaplv -s homelv --size 10g vg0
# dd if=/dev/vg0/homesnaplv of=/dev/sd-big bs=1M
# lvremove /dev/vg0/homesnaplv

Unlike your solution, the LVM snapshot won't be changing underneath you
during the copy.  The allocated size of the snapshot, shown as 10g
above, only has to be big enough to accommodate the amount of writes to
homelv while the dd is in progress.

Also, LVM understands most mounted filesystems, and will invoke the
proper kernel calls to briefly quiesce the filesystem for the snapshot,
ensuring the filesystem copied out is consistent.  But the user sees
only a few tens or hundreds of milliseconds of hesitation and can keep
going.  Writes to homelv while the snapshot exists generate extra disk
activity (to move the replaced blocks to the snapshot storage, with some
metadata), but is otherwise invisible to the users.

LVM is *made* for this.  You should use it.

Phil
