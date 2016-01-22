From: Dark Penguin <darkpenguin@yandex.ru>
Subject: md failing mechanism
Date: Fri, 22 Jan 2016 20:59:45 +0300
Message-ID: <56A26E11.2090703@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

Recently, I've had my first drive failure in a software RAID1 on a file 
server. And I was really surprised about exactly what happened; I always 
thought that when md can't process a read request from one of the 
drives, it is supposed to mark that drive as faulty and read from 
another drive; but, for some reason, it was deliberately trying to read 
from a faulty drive no matter what, which apparently caused Samba to 
wait until it's finished, and so the whole server was rendered 
inaccessible (I mean, the whole Samba).


What I expected:
- A user tries to read a file via Samba.
- Samba issues a read request to md.
- md tries to read the file from one of the drives... the drive is 
struggling to read a bad sector...
- md thinks: okay, this is taking too long, production is not waiting; 
I'll just read from another drive instead.
- It reads from another drive successfully, and users continue their work.
- Finally, the "bad" drive gives up on trying to read the bad sector and 
returns an error. md marks the drive as faulty and sends an email 
telling me to replace the drive as soon as possible.


What happened instead:
- A user tries to read a file via Samba.
- Samba issues a read request to md.
- md tries to read the file from one of the drives... the drive is 
struggling to read a bad sector... Samba is waiting for md, md is 
waiting for the drive, and the drive is trying again and again to read 
this blasted sector like its life depends on it, while users see that 
the network folder doesn't respond anymore at all.

This goes on forever, until users call me, I come to investigate, see 
Samba down, see a lot of errors in dmesg, and then I manually mark this 
drive as faulty.


Now, that happened a while ago; I did not have the most recent kernel on 
that server (I think it was 3.2 from Debian Wheezy or something a little 
newer from the backports), but I can't try it again with a new server, 
because I can't make a functional RAID1, write data there, and then 
destroy some sectors and see what happens. I just want to ask, is that 
really how it works?.. Was that supposed to happen?.. I thought the main 
point of a RAID1 is to avoid any downtime, especially in such cases!.. 
Or is it maybe a known issue fixed in the more recent versions, so I 
should just update my kernels and expect different behaviour next time?..


-- 
darkpenguin
