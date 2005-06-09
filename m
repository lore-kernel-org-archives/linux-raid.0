From: "Martin D. Weinberg" <weinberg@astro.umass.edu>
Subject: Help migrating array from Promise IDE cards to 3ware card
Date: Thu, 9 Jun 2005 14:17:42 -0400
Message-ID: <20050609141742.2f1be0c8.weinberg@astro.umass.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: weinberg@astro.umass.edu
List-Id: linux-raid.ids

Folks,

I just upgraded a server to a dual opteron box (32 bit OS) and could no longer
run the two Promise PDC20269 used to control 8 160GB Maxtor disks on RAID5.

I bought and installed an 8-port 3ware card.  The OS detects the 8 disks but
the system seems to fail with raidstart:

Jun  9 14:04:37 kestrel kernel: md: raid5 personality registered as nr 4
Jun  9 14:04:44 kestrel kernel: md: could not open unknown-block(1824,41760).
Jun  9 14:04:44 kestrel kernel: md: autostart failed!
Jun  9 14:04:44 kestrel kernel: md: could not open unknown-block(1824,41760).
Jun  9 14:04:44 kestrel kernel: md: autostart failed!
Jun  9 14:04:44 kestrel kernel: md: could not open unknown-block(1824,41760).
Jun  9 14:04:44 kestrel kernel: md: autostart failed!
Jun  9 14:04:44 kestrel kernel: md: could not open unknown-block(1824,41760).
Jun  9 14:04:44 kestrel kernel: md: autostart failed!
Jun  9 14:04:44 kestrel kernel: md: could not open unknown-block(1824,41760).
Jun  9 14:04:44 kestrel kernel: md: autostart failed!
Jun  9 14:04:44 kestrel kernel: md: could not open unknown-block(1824,41760).
Jun  9 14:04:44 kestrel kernel: md: autostart failed!
 
and etc.

Is there a way to get this array back?  Thanks!!!

--Martin

