From: Christoph Plattner <christoph.plattner@gmx.at>
Subject: Bug by starting with missed first devies - bug fix included !!
Date: Wed, 18 Dec 2002 21:06:32 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E00D548.3000907@gmx.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello RADI hackers,

some days ago I recongnized, that `raidstart' has a problem, if 
`raid-disk 0' is missed or defect. This was a critical problem
on my RAID 5 for me.

Solution for this problem: try to use all devices to get RAID info,
not only the first defined device (bad design bug).

I am not sure, if this is already reported or fixed, I have release
20010914, and the raidstart `v0.3d'.

Please answer directly to me, I am not registered on the RAID
mailing list !! (Perhaps I will do in future).


One possible fix:

bash# diff -u raidlib.c.ORIG raidlib.c
--- raidlib.c.ORIG      Wed Dec 18 20:59:11 2002
+++ raidlib.c   Sun Dec 15 13:42:06 2002
@@ -395,11 +395,29 @@
        case raidstart:
        {
         struct stat s;
+       int did = 0;
+       int done = 0;
+
+       fd = open_or_die(cfg->md_name);

-       stat (cfg->device_name[0], &s);
+       while (cfg->device_name [did])
+       {
+           stat (cfg->device_name [did], &s);

-       fd = open_or_die(cfg->md_name);
-       if (do_mdstart (fd, cfg->md_name, s.st_rdev)) rc++;
+           if (do_mdstart (fd, cfg->md_name, s.st_rdev) == 0)
+           {
+               done = 1;
+               break;
+           }
+           did ++;
+       }
+
+       if (done == 0)
+       {
+           rc++;
+           close (fd);
+       }
+
         break;
        }



With friendly regards
Christoph Plattner



-- 
-------------------------------------------------------
private:	christoph.plattner@gmx.at
company:	christoph.plattner@alcatel.at

