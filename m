From: Christian Schmit <cschmit@vo.lu>
Subject: RH73 using raid1
Date: Wed, 22 May 2002 16:39:14 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <133804933873.20020522163914@vo.lu>
Reply-To: Christian Schmit <cschmit@vo.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I installed RH7.3 on a testserver with raid1
using 2 IDE HD's. Everything is working fine.

If I remove the primary IDE HD and try
to boot the server from the secondary
master IDE HD it won't boot.
(not even the bootloader is starting)

I assume this is because the booloader
(in this case Grub) is not installed in
the MBR of the HD on the secondary IDE channel.

How can I install Grub in the MBR of the 2nd HD
of my software raid1?

Christian

