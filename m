From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: BUG (Deadlock) in 2.6.10
Date: Sun, 27 Feb 2005 11:05:34 -0500
Message-ID: <200502271605.j1RG5e914310@www.watkins-home.com>
References: <4221E874.6060309@rapidforum.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <4221E874.6060309@rapidforum.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Christian Schmid' <webmaster@rapidforum.com>, mingo@redhat.com, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't know about the dead lock, or the native RAID10,  but you setup is
not the best.

It would be much better to have this config:
MD2 is RAID1 with 2 disks sda1 sdd1
MD3 is RAID1 with 2 disks sdb1 sde1
MD4 is RAID1 with 2 disks sdc1 sdf1
MD5 is RAID0 with 3 disks MD2 MD3 MD4

Now when a disk fails MD5 will not "see" the failure, if fact, each of the
RAID1 arrays can lose 1 disk and not cause MD5 to fail.  A re-sync of 1 disk
will only affect 1 array.

With the setup you had, assume no dead lock...  If you lose 1 disk, 3 disks
go off-line.  When you replace the 1 disk, you must re-sync 3 disks.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Christian Schmid
Sent: Sunday, February 27, 2005 10:34 AM
To: mingo@redhat.com; neilb@cse.unsw.edu.au; linux-raid@vger.kernel.org
Subject: BUG (Deadlock) in 2.6.10

Hello.

Just for your information: There is a deadlock in the following situation:

MD2 is Raid 0 with 3 disks. sda1 sdb1 sdc1
MD3 is Raid 0 with 3 disks. sdd1 sde1 sdf1
MD4 is Raid 1 with 2 disks. MD2 and MD3!!

If a disk in MD2 fails, MD2 completely fails. MD4 SHOULD now mark disk 1
(MD2) as faulty but does 
not. Instead there is a dead-lock. "sync" hangs as well. Had to reboot.

I am now using the native Raid 10. Is this stable enough?

Best regards,
Chris - RapidTec
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

