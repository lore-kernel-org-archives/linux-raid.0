From: Peter Evertz <leo2@pec.homeip.net>
Subject: Re: Spare disk could not sleep / standby  [probably dangerous PATCH]
Date: Wed, 09 Mar 2005 16:53:20 +0100
Message-ID: <200503091553.j29FrKO2009044@pec6.gallier.dorf>
References: <422D327D.11718.F8DB3@localhost>
            <200503080414.j284EG510309@www.watkins-home.com>
            <16941.11443.107607.735855@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="utf-8"
Content-Transfer-Encoding: 7bit
In-Reply-To: <16941.11443.107607.735855@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Guy <bugzilla@watkins-home.com>, 'Peter Evertz' <leo2@pec.homeip.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch removes my problem. I hope it doesn't have influence on the 
stability of
the system.
It is simple: The Update routine skips normaly only "faulty" disks. Now it 
skips all disk
that are not part of the working array ( raid_disk == -1 )
I made some testing, but surely not all, so : 

DON'T APPLY TO YOUR SYSTEM WITH IMPORTENT DATA ! 

Regards
Peter 

 --- md.c.orig   2005-01-14 16:33:49.000000000 +0100
+++ md.c        2005-03-09 15:27:23.000000000 +0100
@@ -1340,14 +1340,14 @@
       ITERATE_RDEV(mddev,rdev,tmp) {
               char b[BDEVNAME_SIZE];
               dprintk(KERN_INFO "md: ");
 -               if (rdev->faulty)
 -                       dprintk("(skipping faulty ");
+               if (rdev->faulty || rdev->raid_disk < 0)
+                       dprintk("(skipping faulty/spare "); 

               dprintk("%s ", bdevname(rdev->bdev,b));
 -               if (!rdev->faulty) {
+               if (!rdev->faulty && !rdev->raid_disk <0 ) {
                       err += write_disk_sb(rdev);
               } else
 -                       dprintk(")\n");
+                       dprintk("<%d>)\n",rdev->raid_disk);
               if (!err && mddev->level == LEVEL_MULTIPATH)
                       /* only need to write one superblock... */
                       break; 


