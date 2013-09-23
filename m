From: Ian Pilcher <arequipeno@gmail.com>
Subject: How to create a near-far array
Date: Sun, 22 Sep 2013 23:20:22 -0500
Message-ID: <l1ofht$ftc$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to create a near-far RAID-10 array (so that I can test
parsing of the corresponding /proc/mdstat output), but I haven't been
able to figure out how to create such a beast with mdadm.  It always
complains that the layout must be nNN, oNN, or fNN.

What's the magic incantation?

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
Sometimes there's nothing left to do but crash and burn...or die trying.
========================================================================

