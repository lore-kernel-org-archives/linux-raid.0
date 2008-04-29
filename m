From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: degraded array after reboot *again*
Date: Tue, 29 Apr 2008 14:52:21 +0200
Message-ID: <200804291452.21666.Dexter.Filmore@gmx.de>
References: <200804281424.33558.Dexter.Filmore@gmx.de> <A20315AE59B5C34585629E258D76A97C197159@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C197159@34093-C3-EVS3.exchange.rackspace.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Controller is running "dumb", all you can do there is "create raid set" 
and "delete raid set".

I resynced the array yesterday. then shut down. then rebooted to Slackware 
WITHOUT assembling.
Ran mdadm -E.
All drives have event count 0.3064.

So I reboot to debian. 4 out of 5. 
Event count on the active drives 0.3066, on the mssing still 0.3064.

So the disk was kicked when debian assembled. Why?
Only thing I could think of was if the controller wasn't ready when mdadm 
assembled, but since it's the same chip as the onboard controller they should 
all be there as soon as sata_sil is loaded.

I now put sde on yet another controller and see what happens.


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
