From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: minimum speed for raid5 check
Date: Mon, 4 Jun 2007 11:31:21 -0300
Message-ID: <18020.8761.82894.369329@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'd like the check speed in a raid5 array to have a minimum speed. I
put the value at sync_speed_min but it only works when the array is
idle. Is there a way to set a minimum check speed independent of the
array load? Otherwise it'll never finish because the machine is always
reading from the disks.

This is a different request from the others that have appeared
recently in the list... I'm using 2.6.20.11 and CFQ. It seems changing
the IO scheduler wouldn't make a difference because the check is
really only using the idle bandwidth, which is scarce.
