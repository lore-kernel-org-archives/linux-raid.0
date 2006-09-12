From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: access *exisiting* array from knoppix
Date: Tue, 12 Sep 2006 16:01:17 +0200
Message-ID: <200609121601.17783.Dexter.Filmore@gmx.de>
References: <200609121352.08834.Dexter.Filmore@gmx.de> <Pine.LNX.4.64.0609120928560.19418@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0609120928560.19418@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Dienstag, 12. September 2006 15:29 schrieb Justin Piszcz:
> fdisk -l
>
> then you have to assemble the array
>
> mdadm --assemble /dev/md0 /dev/hda1 /dev/hdb1 # i think, man mdadm

Not what I meant: there already exists an array on a file server that was 
created from the server os, I want to boot that server from knoppix instead 
and access the array.

-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
