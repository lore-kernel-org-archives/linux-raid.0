From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: RE: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 21:12:02 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0601192104560.26558@yvahk01.tjqt.qr>
References: <26A66BC731DAB741837AF6B2E29C1017D47EA0@xmb-hkg-413.apac.cisco.com>
 <Pine.LNX.4.61.0601181427090.19392@yvahk01.tjqt.qr> <17358.52476.290687.858954@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161394AbWASUM2@vger.kernel.org>
In-Reply-To: <17358.52476.290687.858954@cse.unsw.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

>> >personally, I think this this useful functionality, but my personal
>> >preference is that this would be in DM/LVM2 rather than MD.  but given
>> >Neil is the MD author/maintainer, I can see why he'd prefer to do it in
>> >MD. :)
>> 
>> Why don't MD and DM merge some bits?
>
>Which bits?
>Why?
>
>My current opinion is that you should:
>
> Use md for raid1, raid5, raid6 - anything with redundancy.
> Use dm for multipath, crypto, linear, LVM, snapshot

There are pairs of files that look like they would do the same thing:

  raid1.c  <-> dm-raid1.c
  linear.c <-> dm-linear.c



Jan Engelhardt
-- 
