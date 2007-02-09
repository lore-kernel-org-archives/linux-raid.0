From: TJ <systemloc@earthlink.net>
Subject: Hard disk wierdness in raid array
Date: Fri, 9 Feb 2007 18:01:57 -0500 (GMT-05:00)
Message-ID: <8110270.1171062117832.JavaMail.root@elwamui-norfolk.atl.sa.earthlink.net>
Reply-To: TJ <systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
      I've got a 6x200GB RAID 5 array that I've kept up for some time. I've always had a bit of trouble with stability and I've suspected a cranky controller, or disk, or a combo that simply doesn't work together, but I managed to get it up and stable for approximately 12 months. Now I'm adding a disk to the array and this problem has come round to bite me again and I'm hoping someone here can confirm my logic. I have 3 controller cards, a Promise IDE, a Maxtor branded SiI 680 IDE, and a SiI 3112 SATA. Previously, I had my drives configured so that each was a single drive, not in a master/slave config, but this is getting to be too much in the way of cabling, and I really think with modern UDMA drives that this should be necessary. I changed the config to get rid of some of those PATA cables. Here's a basic list of the new drive/controller config:

SiI 680
/dev/hda  Seagate Barracuda 200GB
/dev/hdb  Seagate Barracuda 200GB
/dev/hdc
/dev/hdd
PDC 20269
/dev/hde  Western Digital Caviar 40GB (Boot device, not part of RAID5)
/dev/hdf   Western Digital Caviar 200GB
/dev/hdg   Western Digital Caviar 200GB
/dev/hdh   Western Digital Caviar 200GB
SiI 3112
/dev/sda  Seagate Barracuda 200GB
/dev/sdb  Seagate Barracuda 200GB

I do know that WD drives are cranky in that they have different jumper settings for single vs master, and my jumpers were/are set correctly. Immediately on adopting this configuration, the array would come up, but on resyncing, I would recieve this error:

hdg: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdg: dma_intr: error=0x40 { UncorrectableError }, LBAsect=248725, high=0, low=248725, sector=248639
ide: failed opcode was: unknown
end_request: I/O error, dev hdg, sector 248639
raid5 Disk failure on hdg1, disabling device. Operation continuing on 4 devices

Then the machine would freeze. I'm confident that hdg did not suddenly die, as I've gotten these messages before when I was previously having stability issues. I repeated the procedure and got the error again and again on hdg. In order to find the problematic component, I switched the cable connecting hdg and hdh to the SiI 680 controller, making them hdc and hdd. On trying to resync, I got the same error message, but at a different sector, and on hdc (which would be the same drive). I feel that this isolated the problem to one WD 200GB drive which seems to always error when in a master/slave config on either controller. In order to recover my data, I changed the configuration again so that the problematic drive was in a single configuration again, making sure to set the jumper accordingly. I am now half-way through rebuilding the array.

I would simply like someone to confirm my assumption that although this drive functions correctly in a single configuration, it has some sort of hardware problem and needs to be RMA'd. I don't believe anything else to be at fault as I swapped which controller the drive was on, still saw errors, and I also ran the drive that was slaved to it with another drive and that drive never caused any trouble. 

Thanks for any input, and feel free to ask for more info, or suggest testing,
TJ Harrell

