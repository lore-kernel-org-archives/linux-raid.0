From: "John Stoffel" <john@stoffel.org>
Subject: Re: Setting up fakeraid with mdadm / dmraid
Date: Tue, 5 Apr 2016 09:58:20 -0400
Message-ID: <22275.50300.54320.32686@quad.stoffel.home>
References: <b6ced30ee931f9a6faf2541db2462401.squirrel@postweb.cs.tu-dortmund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b6ced30ee931f9a6faf2541db2462401.squirrel@postweb.cs.tu-dortmund.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Pleger <Christoph.Pleger@cs.tu-dortmund.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Christoph> I have a machine with an LSI Megaraid Sofware RAID
Christoph> fakeraid, which uses ddf format. About two weeks ago, when
Christoph> I wanted to install the machine, I configured a RAID 1
Christoph> array in the BIOS config utility and then booted the
Christoph> machine from PXE with an NFSROOT. mdadm and dmraid are
Christoph> installed in the NFSROOT, dracut is used for initrd
Christoph> generation. As dracut prefers mdadm over dmraid, mdadm was
Christoph> chosen for RAID management.

First off, I would strongly suggest that you turn off the FakeRAID
entirely, just expose both disks to the OS and have the OS do the
mirroring.  FakeRAID was designed when CPUs were much slower, but RAID
HW ASICs were also expensive.  So you got the worst of both worlds!
*grin*

It's also almost entirely black magic to support these things, since
the vendors don't generally share the details on the on-disk format
that I'm aware of.  I'm probably wrong in the details.

But again, please just use the controller in JBOD (Just a Bunch of
Disks) mode, and let mdadm mirror the disks for you.  

Christoph> But though mdadm detected the RAID (it created container
Christoph> device /dev/md127 and raid device /dev/md126), it destroyed
Christoph> it - that is, though I did not perform any action on the
Christoph> raid disks, at the next boot, the BIOS RAID utility had
Christoph> "forgotten" about the RAID configuration it had created
Christoph> before.

Christoph> Why are the possible reasons for that?

Crappy implementation of semi-secret on-disk format?   It could be
that mdadm over-wrote something on the disk, or you partitioned it and
then overwrote something the FakeRAID wanted kept around.

In general, just don't go the fake RAID route, it's not worth the
hassle.

John
