From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: raid5.h documentation
Date: Wed, 19 Jul 2006 12:08:05 +0300
Message-ID: <5d96567b0607190208y2ad6f71fvb92eb5ac66ff9af9@mail.gmail.com>
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

you say raid5.h:
...
 * Whenever the delayed queue is empty and the device is not plugged, we
 * move any strips from delayed to handle and clear the DELAYED flag
and set   PREREAD_ACTIVE.
 ...

i do not understand how can one move from delayed if delayed is empty .


thank you
-- 
Raz
