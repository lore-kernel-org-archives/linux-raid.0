From: "Johny Mail list" <maillist.johny@gmail.com>
Subject: Linux Software RAID is really RAID?
Date: Tue, 26 Jun 2007 19:43:24 +0200
Message-ID: <cd98e0260706261043t32fe6609ye1e4e252c722358c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,
I have a little question about software RAID on Linux.
I have installed Software Raid on all my SC1425 servers DELL by
believing that the md raid was a strong driver.
And recently i make some test on a server and try to view if the RAID
hard drive power failure work fine, so i power up my server and after
booting and the prompt appear I disconnected the power cable of my
SATA hard drive. Normaly the MD should eleminate the failure hard
drive of the logical drive it build, and the server continue to work
fine like nothing happen. Oddly the server stop to respond and i get
this messages :
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
              res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4: port is slow to respond, please be patient (Status 0xd0)
ata4: port failed to respond (30sec, Status 0xd0)
ata4: soft resetting port

After that my system is frozen. Normaly in a basic RAID the device is
"disable" in the logical RAID device (md0) and it only use the last
disk.

I have make the same test on Windows with the fakeraid in the
bios/sata chip and with one disk disconnected the system is always up
with a logical device.

I use Linux RAID + LVM + ext3 a basic combinaison, i have make this
test on debian etch defautl kernel and with the last version of the
kernel. If anyone have an idea why the driver don't manage electric
failure of an hard drive ...

Thanks
