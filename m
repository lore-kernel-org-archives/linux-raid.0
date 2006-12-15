From: John McMonagle <johnm@advocap.org>
Subject: Raid corruption problems.
Date: Fri, 15 Dec 2006 13:52:50 -0600
Message-ID: <4582FD12.90806@advocap.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090903040403040809000704"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090903040403040809000704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Have a raid1  backup server that seems to get corrupted.
This is the 3rd time in about a year.
Have 2 other backup servers that were cloned from this one that have no 
problems.

Done a couple kernel upgrades recently.
Now has 2.6.18-2 kernel.
It's based on Debian sarge.

It's a low end Intel server motherboard using ata_piix sata driver.
Have another mother board just like doing raid1 with sata drives that 
has had no problems but it has a much lighter disk load.
smartctl has never shown any problems.
In /sys/block/md2 did
echo check > syncaction
No error messages but mismatch_cnt  is 1152.
rc0/errors and rc1/errors are both 0.

I'm guessing a hardware problem.
Any suggestions?

John



--------------090903040403040809000704
Content-Type: text/x-vcard; charset=utf-8;
 name="johnm.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="johnm.vcf"

begin:vcard
fn:John McMonagle
n:McMonagle;John
org:Advocap inc
email;internet:johnm@advocap.org
title:IT manager
x-mozilla-html:FALSE
url:http://www.advocap.org
version:2.1
end:vcard


--------------090903040403040809000704--
