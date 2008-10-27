From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: dmraid - where is the raid done?
Date: Mon, 27 Oct 2008 18:29:52 -0500
Message-ID: <49064EF0.4080804@gmail.com>
References: <1225120062.20830.34.camel@pc.ilinx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1225120062.20830.34.camel@pc.ilinx>
Sender: linux-raid-owner@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brian J. Murrell wrote:
> Somebody had suggested this list for this question:
> 
> I understand that dmraid is just some kind of interface to the
> _software_ raid that is provided on a number of SATA interface cards
> such as the Promise and Adaptec cards.
> 
> Reading http://ata.wiki.kernel.org/index.php/SATA_RAID_FAQ I get the
> message loud and clear that this is not real hardware RAID but rather
> it's done in the BIOS on the card.
> 
> The message there seems to be, if you are going to do it in software
> anyway, why not just skip the IO card RAID and just use MD?
> 
> The one reason I could think of for using the BIOS provided RAID would
> be to reduce the data needing to traverse the PCI bus.  With host-raid
> (i.e. MD) every write to disk needs to actually be written over the PCI
> bus twice, once for each disk, right?
> 
> But do the BIOS RAID cards out there only need the write command and
> data once and they do the work of writing it to the two disks on-board
> the IO card?

At bootup the bios takes care of booting properly for the fakeraid.

After that the OS driver only reads tables that the BIOS put on the disks,
and figures out which disks are to be raided, and the OS does *ALL* of the work 
just like MD.   The only advantage is the bios taking care of booting from 
either disk, without this if a bad disk still partially there (say it just had 
bad blocks on all of the /boot partition) then the OS won't boot (with MD), but 
may boot with bios raid1/dmraid.

If you set raid in the bios, and don't use dmraid in the OS, at some future
boot the bios raid *CAN* determine that the disks are out of sync
and correct this (and depending on your configuration eliminate your data), I
had a customer that did this and was running R0 on the 2 disks, but the
bios was configured R1 and after a year+ of running R0 the machine crashed
in a bad way and the bios determined there were out of sync and asked to
correct it, and they said yes, and it eliminated their data.

So only bootup is done in the bios, once the machine boots the bios is gone
and no longer doing anything.

> 
> IIUC, when you have a BIOS RAID configured, even though there are two
> disks, the operating system only sees one.  This would seem to support
> the theory that the write only goes to the controller once and it takes
> care of the mirroring, but I will defer to your experience.

I don't remember if dmraid takes care of hiding the 2 devices, if it does
the OS is still aware of them and writing to both of them.

> 
> Thanx,
> b.

