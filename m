From: Mario Vodisek <vodisek@upb.de>
Subject: Setting a buffer_heads 'real_device'
Date: Wed, 10 Jul 2002 13:25:07 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D2C1993.ABA5EEA0@upb.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------9CAF818A292EB84D2B3564EF"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dies ist eine mehrteilige Nachricht im MIME-Format.
--------------9CAF818A292EB84D2B3564EF
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

I'm writing a virtual disk driver consisting of serveral real disks.
Hence I've to map read/write requests for my virtual device to
underlying
real devices, like md does so for RAID-Arrays.

So my question is how a virtual device driver (like 'md') manages the
read/write
request associated with a virtual (md-) device to get data from a
specific real
device within a 'block_read/block/write()' invokation !
I know that the buffer head-structure contains an entry for a virtual
and a real
device, but i don't know when and in which proper way to set these
components.

Somebody to help me ??

Mario Vodisek
--------------9CAF818A292EB84D2B3564EF
Content-Type: text/x-vcard; charset=us-ascii;
 name="vodisek.vcf"
Content-Transfer-Encoding: 7bit
Content-Description: Visitenkarte für Mario Vodisek
Content-Disposition: attachment;
 filename="vodisek.vcf"

begin:vcard 
n:Vodisek;Mario
tel;fax:---
tel;home:0160/632 96 92
tel;work:---
x-mozilla-html:FALSE
org:University of Paderborn;AG Meyer auf der Heide - Theoretical computing -
version:2.1
email;internet:vodisek@upb.de
title:research assistant
adr;quoted-printable:;;Liebfrauenweg 9=0D=0A	;33334 Gütersloh;;;Germany
x-mozilla-cpt:;-9984
fn:Mario Vodisek
end:vcard

--------------9CAF818A292EB84D2B3564EF--

