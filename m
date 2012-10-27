From: Sam van Ratt <sam.vanratt@gmx.net>
Subject: MDADM after QNAP Support disaster QNAP 859 Pro
Date: Sat, 27 Oct 2012 17:26:42 +0200
Message-ID: <508BFD32.7010901@gmx.net>
Reply-To: Sam.vanRatt@gmx.net
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Michael Samer EPOS GmbH <michael.samer@epos-cat.de>
List-Id: linux-raid.ids

Hello
a few days I received a NAS with 8 Slots. The original config consistet 
of 8* 2TB HDs as a RAID6 mdadm softraid system. After a normal reboot 
the array was no longer found, so QNAP was contacted.
The support told the keyuser todo this:


mdadm -D /dev/md0 (zeigt das gesamte RAID auf)
to assemble the HDs you have to:
mdadm -A /dev/md0 /dev/sda3.... (take care here, depending on the HDs 
they get a value like /dev/sdb3 dev/sdc3 ...) - with 8 HDs:
mdadm -A /dev/md0 /dev/sda3 /sdb3 /dev/sdc3 /dev/sdd3 /dev/sde3 
/dev/sdf3 /dev/sdg3 /dev/sdh3 (be careful with the order!)
If you get an error message about the assemble, you have to stop md0
mdadm -S /dev/md0 (stopping md0)
umount /dev/md0 (unmount of md0)

After serveral failed tries it endet in have a RAID 1 Konfig on sda and 
sdb but not seeing anything else of the config before (funnily only a 
500MB partition (as /dev/md9 sounds as a lot of tries).
As I'm not using mdadm in my workplace anywhere:

How can I delete the RAID1 (pretty simple I know) and reconstruct the R6 
Array without damaging the config further (and therefore the datas). The 
R6 should be about 11TiB usable size.
Is there a init build with searching for the old conifg? As R6 it should 
even be readable without sda or sdb if this should be needed. I manly 
use HW RAID Controller where a few (ICP, Infortrend, Areca)  which 
allows a reassembly by just declaring the disks as member to mdx and 
assemble then again; I hope mdadm could offer something similar


Cheers
Sam
