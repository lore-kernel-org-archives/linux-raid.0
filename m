From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: --no-degraded in mdadm.conf? / disable auto assembly
Date: Tue, 29 Apr 2008 13:55:58 +0200
Message-ID: <200804291355.59052.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How do I prevent mdadm from assembling any array at all without uninstalling 
the package? I commented out all lines, still it seems it scanned and 
assembled what it found.
(Possibly a debian thing, will look into this)

Next thing: I don't want mdadm to assemble arrays if not all disks are 
present. Can I pass no-degraded to mdadm.conf?

Is there a dry-run-option that says what would happen if I assembled now?

Dex


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
