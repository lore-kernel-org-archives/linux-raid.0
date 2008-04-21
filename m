From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: mdadm.conf unnecessary?
Date: Mon, 21 Apr 2008 23:45:19 +0200
Message-ID: <200804212345.20631.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What happens if I create two arrays and don't have an mdadm.conf file?

I ask because of this comment:

# mdadm will function properly without the use of a configuration file,
# but this file is useful for keeping track of arrays and member disks.

Um. so... that's all it does? Will mdadm -A -s gather all the info from.. from 
what?

Reason I ask: I have 8 sATA ports in the box with 4 disks that are going to 
replaced with 5 disks.

Now md0 currently is sd[abcd]1.
To copy data to the new array, I will have to build the new array degraded 
because I only have 8 ports.
So the new disks will be sd[efgh]1.
But when I pull the old drives after migrating, they will be sd[abcd]1.. so... 
how do I handle this?

Plus: how do I pass the "missing" disk on mdadm? /dev/sdi missing? After the 
old drives are out, it will become sde. but I can't pass sde as missing on 
creation, since at that point sde will be the first of the new drives.

Cross-eyed,

Dex


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
