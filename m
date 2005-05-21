From: Rolf Schatzmann <rolf@mactherapy.com>
Subject: Chunk Size
Date: Sat, 21 May 2005 12:03:54 +0800
Message-ID: <428EB32A.2000603@mactherapy.com>
Reply-To: rolf@mactherapy.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050308070803050308020802"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------050308070803050308020802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I have been using Linux Software Raid 5 for years, it is excellent. If 
anyone involved in the development of it is ever in Perth Australia look 
me up and i will buy you many beers.
Last year i switched from using pata to sata, to be honest it did not 
result in the performance gains I was hoping for and when a drive fails 
it sometimes crashes the host machine (at least with a 2.4 kernel) but 
otherwise its just as dependable as pata raid 5 was. I used to just use 
raid for the data volume of the server but recently i am using it for / 
with a separate raid 1 partition for /boot , it works very well.

In the past I have had to do a few crazy things with raidreconf and got 
away with most of them, however that was when i was using raidtools2 and 
now its all mdadm instead, so my question is this, is there anyway to 
change the chunk size on an existing raid 5 partition without destroying 
the data on it and whilst it is mounted at / .  Yeah you read that 
right, I am laughing too, but I just wanted to be sure i am not missing 
something obvious here, I have in the past found huge performance gains 
by using larger chunk sizes for big file copies and would like to 
experiment.

Thanks in advance!

-- 
--------------------------

Rolf Schatzmann
MacTherapy Australia Pty Ltd
Fax 08 9444 2560
Mobile 0410 577664

We love GNU/Linux Debian.

Http://www.mactherapy.com


--------------050308070803050308020802
Content-Type: text/x-vcard; charset=utf-8;
 name="rolf.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rolf.vcf"

begin:vcard
fn:Rolf Schatzmann
n:Schatzmann;Rolf
org:MacTherapy Australia Pty Ltd
adr:;;Po Box 381;Mt Lawley;WA;6929;Australia
email;internet:rolf@mactherapy.com
title:Director
tel;work:0410 577664
tel;fax:08 94442560
tel;cell:0410 577664
x-mozilla-html:TRUE
url:http://www.mactherapy.com
version:2.1
end:vcard


--------------050308070803050308020802--
