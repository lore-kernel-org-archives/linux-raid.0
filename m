From: "Jason C. Leach" <Jason.Leach@jsthrower.com>
Subject: Promise SX6000 is a POS.
Date: Fri, 02 Apr 2004 09:52:53 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406DA875.30605@jsthrower.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010604060703040703060301"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------010604060703040703060301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linux-Raid:

I have a Promise SX6000 RAID card and on it an 1Tb RAID-5 array (6*200G 
WD2000 ATA disks 7500rmp).  I am using Debian Woody with the 2.4.19 
Kernel on a AMD AthelonXP +2500 system. I am using the Promise driver 
downloaded and compiled from there website.

I am getting about 3.3Meg/sec from the array to an EIDE disk (segate 
barracuda ATA). While from the Array to the Array I get about  
4.1Meg/sec; copying 200G is an overnight plus job for sure. To me this 
is stupid slow, and I must be doing something wrong. Even if the Promise 
card is the slowest one available (3Ware, Promise, Adaptek) it can't 
really be *this* slow: this card should not even be on the market at 
this speed.  All the while my system load average is about 1.5-2.  Is 
this Linux? Does it really run this slow under Windows as well? Should I 
be using i2o or some other driver? Perhaps the array is just too large?

PS: I get no errors, and the card is on it's own interrupt with a full 
128MB cache.

Thanks,
Jason.


-- 
Jason C. Leach
IT Manager
J.S. Thrower & Associates Ltd.
Phone: (250) 314-0875 Fax (250) 314-0871
email: jason.leach@jsthrower.com
http://www.jsthrower.com


--------------010604060703040703060301
Content-Type: text/x-vcard; charset=utf8;
 name="Jason.Leach.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Jason.Leach.vcf"

begin:vcard
fn:Jason C. Leach
n:Leach;Jason
org:J.S. Thrower & Associates Ltd.;IT Department
adr:;;103 - 1383 McGill Rd;Kamloops;BC;V2C 6K7;Canada
email;internet:jason.leach@jsthrower.com
title:IT Manager
tel;work:250/314-0875
tel;fax:250/314-0871
tel;home:250/314-0875
x-mozilla-html:FALSE
url:http://www.jsthrower.com
version:2.1
end:vcard


--------------010604060703040703060301--
