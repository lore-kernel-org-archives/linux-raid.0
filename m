From: Christian Schmid <webmaster@rapidforum.com>
Subject: BUG (Deadlock) in 2.6.10
Date: Sun, 27 Feb 2005 16:34:12 +0100
Message-ID: <4221E874.6060309@rapidforum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: mingo@redhat.com, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

Just for your information: There is a deadlock in the following situation:

MD2 is Raid 0 with 3 disks. sda1 sdb1 sdc1
MD3 is Raid 0 with 3 disks. sdd1 sde1 sdf1
MD4 is Raid 1 with 2 disks. MD2 and MD3!!

If a disk in MD2 fails, MD2 completely fails. MD4 SHOULD now mark disk 1 (MD2) as faulty but does 
not. Instead there is a dead-lock. "sync" hangs as well. Had to reboot.

I am now using the native Raid 10. Is this stable enough?

Best regards,
Chris - RapidTec
