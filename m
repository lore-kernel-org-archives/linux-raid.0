From: =?ISO-8859-1?Q?Sebastian_F=E4rber?= <faerber@gmail.com>
Subject: Prevent automatic reconstruction during boot/assembly (RAID 1)?
Date: Tue, 11 Aug 2009 14:28:26 +0200
Message-ID: <2953e180908110528u705fc002m6c799821fe278375@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

i'm trying to figure out if it is possible to prevent the
automatic reconstruction that can occur during the md assembly
at boot.
I'm running Kernel 2.6.30.4 and use a RAID-1 over two SATA disks.
If the server is rebooted "hard" due to power loss etc. it often happens
that the reconstruction of my RAID-1 is automatically triggered by the kernel.
Is there any way to prevent this? I want to re-add the "out of sync"
drive myself
using mdadm only.
I'm currently using raid auto detection (partiton type fd) and the old
0.90 superblock format but if it helps i would switch
to an initrd/newer superblock.

Thanks for your help!

Regards,

Sebastian
