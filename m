From: "wagner" <wagner@mail.webway.com.br>
Subject: Raid-1 on fedora setup
Date: Wed, 12 Jan 2005 12:38:43 GMT
Message-ID: <20050112123843.4760.qmail@seguranca.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

I'm trying to set up a Raid-1 in my fedora core 2.
I have an IDE HD with two partitions /boot and /.
I bought another identical HD and set these partitions with the same size
as the first HD.

I follow the RAID-HOWTO 7.6 (Converting a non-RAID RedHat System to run on
Software RAID).

And almost everything worked fine. i set /dev/md0 for the boot partition
and /dev/md1 for the / partition.

The problem was when i tried the last command: resize2fs /dev/md1... it is
telling that the device is mounted... and i can't umount it anyway.

I didn't have this problem when doing it on the /dev/md0 device.

Does anyone has faced it before and can help me?

Thanks a lot in advance,
Wagner.
