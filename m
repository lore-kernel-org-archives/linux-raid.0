From: "Torsten E." <linux-user@gmx.com>
Subject: Question regarding mdadm.conf
Date: Thu, 17 Feb 2005 07:25:45 +0100
Message-ID: <421438E9.5020000@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning! :)

End of january I had some problems with an faulty harddisk, which was 
part of an RAID1 (two mirroed disks containing 4 partitions).
I replaced it, and got some realy good instructions from Gordon Henderson.
Last week the same problem occured again, and I decided to replace the 
controller, too. Now its an PCI 4-port S-ATA controller, and everything 
runs fine till now.

My question now is:
the formerly used /etc/mdadm.conf had some lines like:
   ARRAY /dev/md1 level=raid1 num-devices=2
   UUID=66f80d1a:621442c5:2b6eabe8:3a9f5e54
    devices=/dev/sda6,/dev/sdb6
   ARRAY /dev/md0 level=raid1 num-devices=2
   UUID=06b9cdec:65448b34:3add2ff0:2180f5cd
    devices=/dev/sda5,/dev/sdb5

How does I get those UUID information, to add them to the new 
/etc/mdadm.conf?

Have a nice day
Torsten
