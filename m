From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: raid5 write performance
Date: Sun, 2 Jul 2006 17:02:58 +0300
Message-ID: <5d96567b0607020702p25d66490i79445bac606e5210@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Neil hello.

I have been looking at the raid5 code trying to understand why writes
performance is so poor.
If I am not mistaken here, It seems that you issue a write in size of
one page an no more no matter what buffer size I am using .

1. Is this page is directed only to parity disk ?
2. How can i increase the write throughout ?


Thank you
-- 
Raz
