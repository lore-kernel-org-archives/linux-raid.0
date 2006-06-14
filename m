From: Adam Talbot <talbotx@comcast.net>
Subject: Disks keep failing durning testing
Date: Wed, 14 Jun 2006 13:38:05 -0700
Message-ID: <449073AD.3000809@comcast.net>
References: <4558af040606121737w1bab008am1110e4e1c2cd8934@mail.gmail.com>	<17550.2944.728044.154492@cse.unsw.edu.au>	<448E127F.5010708@comcast.net>	<Pine.LNX.4.56.0606130906370.27931@lion.drogon.net>	<Pine.LNX.4.64.0606130620410.8834@p34.internal.lan>	<Pine.LNX.4.56.0606131124160.27931@lion.drogon.net>	<448EFCA7.6050603@comcast.net>	<Pine.LNX.4.56.0606132229110.17860@lion.drogon.net> <87zmgfn562.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zmgfn562.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Gordon Henderson <gordon@drogon.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You guys are going to love this one...  I have ripped most of my hair
out because of this bug and can not track down the problem!
When ever I build my new array I looses a disk in slot N.  So, a bad
disk?   Move that disk to a different slot in my drive cage, rebuilds
just fine.  New disk in slot N fails...  Bad cable?   Replace the cable
to slot N...  Drive in slot N still fails.  Get mad at drive cage.  Get
new drive cage...  Same slot "N" in new drive cage fails...  Bad
controller card?  New controller card. So I have now replace the drive,
drive cage, cable, controller card...   I am going mad.  My mother board
has 4 onboard SATA ports, I have never had a drive fail on any of those
4 ports...    Concept test.  Took 4 "Failed"  drives and installed them
in the 4 slots the connected to the onboard SATA's... build array.  The
array built in record time, and built at 50MB/sec!  4 disk array works
fine?  Ok, try test 9 more times, just to be sure.  Never once did the
array fail during building or testing in the 4 drive/onboard state. 
What is wrong with my controller cards! I can connect them to any one of
the drives in my array, to any slot in the cage and watch that drive
fail...  The drive(s) never fails at the same stop.

All disks now have over 1000 error in the SMART Logs !@#$.  All the
exact same error:
  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  35 00 f8 08 08 00 e0 00      00:06:26.949  WRITE DMA EXT
  35 00 f8 08 08 00 e0 00      00:06:26.907  WRITE DMA EXT
  35 00 f8 08 08 00 e0 00      00:06:26.866  WRITE DMA EXT
  35 00 f8 08 08 00 e0 00      00:06:26.824  WRITE DMA EXT
  35 00 f8 08 08 00 e0 00      00:06:26.782  WRITE DMA EXT

My NAS's hardware.

AMD Athlon 64 3000
1024MB DDR400
Foxconn 6150K8MA-8EKRS Motherboard
Off brand 6X SATA drive cage
6X MaxLine 300GB SATAII 7200RPM Hard drive.
Promise SATA300 TX2plus controller card
Silicon Image, Inc. SiI 3112 controller card

Any ideas?
-Adam
