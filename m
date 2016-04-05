From: "Christoph Pleger" <Christoph.Pleger@cs.tu-dortmund.de>
Subject: Setting up fakeraid with mdadm / dmraid
Date: Tue, 5 Apr 2016 15:03:12 +0200
Message-ID: <b6ced30ee931f9a6faf2541db2462401.squirrel@postweb.cs.tu-dortmund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a machine with an LSI Megaraid Sofware RAID fakeraid, which uses
ddf format. About two weeks ago, when I wanted to install the machine, I
configured a RAID 1 array in the BIOS config utility and then booted the
machine from PXE with an NFSROOT. mdadm and dmraid are installed in the
NFSROOT, dracut is used for initrd generation. As dracut prefers mdadm
over dmraid, mdadm was chosen for RAID management.

But though mdadm detected the RAID (it created container device /dev/md127
and raid device /dev/md126), it destroyed it - that is, though I did not
perform any action on the raid disks, at the next boot, the BIOS RAID
utility had "forgotten" about the RAID configuration it had created
before.

Why are the possible reasons for that?

Regards
  Christoph



