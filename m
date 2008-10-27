From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: dmraid - where is the raid done?
Date: Tue, 28 Oct 2008 00:38:57 +0100
Message-ID: <slrnggck8i.ond.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <1225120062.20830.34.camel@pc.ilinx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brian J. Murrell <brian@interlinx.bc.ca> wrote:
> I understand that dmraid is just some kind of interface to the
> _software_ raid that is provided on a number of SATA interface cards
> such as the Promise and Adaptec cards.

Well, to be exact, dmraid creates device-mapper tables depending on the
on-disk-layout of various proprietary Software-RAID solutions. It does
neither co-operate with the respective BIOS-subsystems nor does it
manage the respective on-disk metadata to mark disk-failures, change
layouts etc.

> Reading http://ata.wiki.kernel.org/index.php/SATA_RAID_FAQ I get the
> message loud and clear that this is not real hardware RAID but rather
> it's done in the BIOS on the card.

Most of the proprietary Software-RAID solutions out there are
implemented in software only. All the "BIOS" contains there is some very
basic support to initialize and boot off such disk-conglomerates.

> The message there seems to be, if you are going to do it in software
> anyway, why not just skip the IO card RAID and just use MD?

Yes, that's the much cleaner approach. And, for Linux, the more stable
one as well - since dmraid doesn't manage drive-faults etc. anyways as
noted above.

> The one reason I could think of for using the BIOS provided RAID would
> be to reduce the data needing to traverse the PCI bus.  With host-raid
> (i.e. MD) every write to disk needs to actually be written over the PCI
> bus twice, once for each disk, right?

Most of the proprietary Software-RAID solutions out there don't do this,
especially not the low-cost ones that only support RAID0/RAID1/RAID10.
Some solutions that support RAID5 (not all of them, though) provide
on-chip XOR engines - I would suspect those to be able to spread writes
after the PCI(e) bus.

> IIUC, when you have a BIOS RAID configured, even though there are two
> disks, the operating system only sees one.  This would seem to support
> the theory that the write only goes to the controller once and it takes
> care of the mirroring, but I will defer to your experience.

Well, usually the drivers are the ones that hide single devices for ease
and convenience, not the controllers.


regards
   Mario
-- 
Tower: "Say fuelstate." Pilot: "Fuelstate."
Tower: "Say again." Pilot: "Again."
Tower: "Arghl, give me your fuel!" Pilot: "Sorry, need it by myself..."

