From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: migrating: degrade or grow
Date: Mon, 21 Apr 2008 16:21:28 +0200
Message-ID: <200804211621.28526.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

current situation:

machine with 8 sata ports, currently 4 disks in raid5.
new array is gonna be 5 disks. 

now the question is: pluck one drive, let the array degrade and move data as 
fast as possible to the new array?
Or: build new array with 4 drivers, then pull old array and grow new array to 
5 drives?


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
