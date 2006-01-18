From: Neil Brown <neilb@suse.de>
Subject: RE: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 10:19:24 +1100
Message-ID: <17358.52476.290687.858954@cse.unsw.edu.au>
References: <26A66BC731DAB741837AF6B2E29C1017D47EA0@xmb-hkg-413.apac.cisco.com>
	<Pine.LNX.4.61.0601181427090.19392@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161050AbWARXTh@vger.kernel.org>
In-Reply-To: message from Jan Engelhardt on Wednesday January 18
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Wednesday January 18, jengelh@linux01.gwdg.de wrote:
> 
> >personally, I think this this useful functionality, but my personal
> >preference is that this would be in DM/LVM2 rather than MD.  but given
> >Neil is the MD author/maintainer, I can see why he'd prefer to do it in
> >MD. :)
> 
> Why don't MD and DM merge some bits?
> 

Which bits?
Why?

My current opinion is that you should:

 Use md for raid1, raid5, raid6 - anything with redundancy.
 Use dm for multipath, crypto, linear, LVM, snapshot
 Use either for raid0 (I don't think dm has particular advantages
     for md or md over dm).

These can be mixed together quite effectively:
  You can have dm/lvm over md/raid1 over dm/multipath
with no problems.

If there is functionality missing from any of these recommended
components, then make a noise about it, preferably but not necessarily
with code, and it will quite possibly be fixed.

NeilBrown
