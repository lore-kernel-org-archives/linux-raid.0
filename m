From: "Christoph Pleger" <Christoph.Pleger@cs.tu-dortmund.de>
Subject: Re: Setting up fakeraid with mdadm / dmraid
Date: Tue, 5 Apr 2016 17:43:09 +0200
Message-ID: <a889980159966a8db49dacfa8b00f25e.squirrel@postweb.cs.tu-dortmund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

> Christoph> I have a machine with an LSI Megaraid Sofware RAID
> Christoph> fakeraid, which uses ddf format. About two weeks ago, when
Christoph> I wanted to install the machine, I configured a RAID 1
Christoph> array in the BIOS config utility and then booted the
> Christoph> machine from PXE with an NFSROOT. mdadm and dmraid are
Christoph> installed in the NFSROOT, dracut is used for initrd
> Christoph> generation. As dracut prefers mdadm over dmraid, mdadm was
Christoph> chosen for RAID management.

> It's also almost entirely black magic to support these things, since the
vendors don't generally share the details on the on-disk format that I'm
aware of.  I'm probably wrong in the details.

The same fakeraid works quite well in Linux when using dmraid instead of
mdadm, so the ddf format used is obviously not secret. I just would like
to switch to mdadm because its documentation states that it supports the
ddf format and because many sites on the internet recommend to move from
dmraid to mdadm for fakeraid management.

> But again, please just use the controller in JBOD (Just a Bunch of
Disks) mode, and let mdadm mirror the disks for you.

The purpose of my NFSROOT is to partition disks, create filesystems and
unpack a base system to the disks. This should support a great variety of
machines, so the installation system has to be quite general. Though it is
not the case here, what if Linux had to be installed on the RAID together
with another OS? I think, that then all installed OSes should have the
same view on the RAID - the view which if offered by the fakeraid.

And if I had not intended to reinstall the machine anyway, but wanted to
use the NFSROOT as a rescue system, my data had been lost without
intention. So, even if mdadm does not support ddf fakeraids (correctly),
it should at least not destroy data.

> Crappy implementation of semi-secret on-disk format?   It could be that
mdadm over-wrote something on the disk, or you partitioned it and then
overwrote something the FakeRAID wanted kept around.

Like I wrote before, I did not perform any action on the disks. No
mounting, no partitioning, no mkfs. Just booting with an NFSROOT which has
mdadm and dmraid installed.

Regards
  Christoph



