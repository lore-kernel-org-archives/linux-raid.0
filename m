From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Too much ECC?
Date: Thu, 9 Nov 2006 15:30:55 +0100
Message-ID: <200611091530.56024.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just ran smartctl -d ata on my sATA disks (Samsung) and got these raw 
values:

195 Hardware_ECC_Recovered  3344107
195 Hardware_ECC_Recovered  2786896
195 Hardware_ECC_Recovered  617712
195 Hardware_ECC_Recovered  773986

Looking at a 5 year old 40GB Maxtor that's not been cooled too well I see "3" 
as the raw value.
Should I be worried or am I just not properly reading this?

Dex


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
