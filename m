From: <bhess@patmedia.net>
Subject: (unknown)
Date: Wed, 11 Jan 2006 09:47:03 -0500
Message-ID: <20060111144943.93BAA396A20@mxo3.broadbandsupport.net>
Reply-To: bhess@patmedia.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

linux-raid@vger.kernel.org



I originally sent this to Neil Brown who suggested I sent it to you.







Any help would be appreciated.







Has anyone put an effort into building a raid 1 based on USB connected

drives under Redhat 3/4 not as the root/boot

drive. A year ago I don't think this made any sense but with the

price of drives being far less that then the equivalent tape media

and the simple USB to IDE smart cable I am evaluating an expandable

USB disk farm for two uses. A reasonable robust place to store

data until I can select what I want to put on tape. The second

is secondary storage for all of the family video tapes that I am

capturing in preparation for editing to DVD. The system does not

have to be fast just large, robust, expandable and cheep.



I currently run a Redhat sandbox with a hardware raid 5 and 4 120G

SATA drives. I have added USB drives and have them mount with

the LABEL=/PNAME option in fstab. In this manner they end up

in the right place after reboot. I do not know enough about

the Linux drive interface to know if USB attached devices will

get properly mounted into the raid at reboot and after changes

or additions of drives to the USB.



I am a retired Bell Labs Research supervisor. I was in Murray Hill

when UNIX was born and still use Intel based UNIX in the current

form of SCO Unixware both professionally and personally. Unixware

is no longer a viable product since I see no future in it and

Oracle is not supported. I know way to much about how the guts

of Unixware works thanks to a friend who was one of SCO's kernel

and storage designers. I know way to little how Linux works to

get a USB based raid up without a lot of research and tinkering.

I don't mind research and tinkering but I don't like reinventing

the wheel.



I have read The Software-RAID HOWTO by Jakob 0stergaard and

Emilio Bueso and downloaded mdadm. I have not tried it yet.





The system I have in mind uses a Intel server motherboard,

hardware raid 1 SATA root/boot/swap drive, SCSI tape drive

and a 4 port USB card. In a 2U chasses. A second 2U chassis

will contain a supply, up to 14 drives and lots of fans.

I have everything except the drives. The sole use of this system

will be a disk farm with a NFS and Samba server. It will run

under Redhat 3 or 4. I am leaning toward Redhat 4 since I

understand SCSI tape support is more stable under 4. Any

comment in this area would also be appreciated.



Can you point me in the direction of newer articles that cover

Linux raid using USB connected drives or do you have any

suggestions on the configuration of a system. My main concern

is how to get USB drives correctly put back in the raid after

boot and/or a USB change since I do not know how they are assigned

to /dev/sdxy in the first place and how USB hubs interact with

the assignments. I realize I should have other concerns and

just don't know enough. Ignorance is bliss, up to an init 6.



Thank You for your time.



Bill Hess



bhess@patmedia.net 

