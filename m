From: <robin-lists@robinbowes.com>
Subject: Multi-channel ATA controller cards
Date: Sun, 9 May 2004 00:06:10 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <S263851AbUEHXGM/20040508230612Z+21001@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm putting together a (relatively) large capacity Raid 5 storage solution
for home use to store rips of all my CDs, probably in flac format.

As I'm paying for it cost is a major factor, more so than performance but
not over and above data integrity, i.e. my priorities are 1. Data Integrity,
2. Cost, 3. Performance.

I'll be building this into a CoolerMaster case which can take up to six 3.5"
drives. I've been looking into various controller options, both PATA and
SATA, and have decided that PATA will give me best price/capacity.

So far, the most likely candidate (on a cost basis) is the Acard AEC6885S
(http://www.acard.com/eng/product/adapter/pc/ide/aec-6885.html) which is a
4-channel ATA-133 "RAID" Controller. I'm not too bothered about the RAID
capabilities as I would configure it as JBOD, although I might use the
controller RAID1 functionality to create mirrors to host /boot and swap, but
that's just implementation detail.

Has anyone got any experience with this controller? Is it well supported
under Linux?

I was planning to buy two of these and to hang three drives off each one.
Does anyone know if two of these controllers will co-exist in the same
machine?

One other possibility is to use three two-channel controllers (two disks on
each one). Does anyone know if this is feasible?

Finally, does anyone know of any other 4-channel (or 6-channel) ATA
controllers that would be worth my checking out?

Thanks,

R.

