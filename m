From: CoolCold <coolthecold@gmail.com>
Subject: mounting component device of RAID1 with internal bitmap
Date: Thu, 1 Apr 2010 21:47:41 +0400
Message-ID: <q2zf19d625d1004011047gf9d48094p696ac38e669fb5e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello!
For raid1 array with metadata 0.90 it is possible to mount component
(let's say /dev/sda1) as usual FS, fix smth, /etc/fstab for example,
unmount and then assamble arary. but is this possible for raid1 array
with internal bitmap ? If my guesses are right this may damage array.

-- 
Best regards,
[COOLCOLD-RIPN]
