From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: Can't create partitions on raid, --auto=mdp not possible
Date: Sat, 26 Apr 2008 13:50:23 +0200
Message-ID: <200804261350.23578.Dexter.Filmore@gmx.de>
References: <200804261346.03511.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200804261346.03511.Dexter.Filmore@gmx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Forgot: line I used to create:

mdadm -C /dev/md1 -v -n 5 -l 5 -a p /dev/sd[abcd]1 missing


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
