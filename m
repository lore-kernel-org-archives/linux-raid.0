From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: mdadm: Automatically determine maximum possible size for --grow?
Date: Thu, 19 May 2005 18:39:35 +0200
Message-ID: <d6ifeg$j7m$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

would it be very hard for mdadm to determine the maximum size a given
RAID can be grown to automagically like with --create?
All the resize tools I know about can do this. And I'm quite sure this
could help the average user who just replaced his disks with bigger
ones.

And btw. - do I need a 2.6 kernel to grow a RAID1's size or does this
work with 2.4 too?


regards
   Mario
-- 
Whenever you design a better fool-proof software,
the genetic pool will always design a better fool.

