From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: NVRAM support
Date: Thu, 16 Feb 2006 11:05:54 +0100
Message-ID: <dt1iq2$c29$1@sea.gmane.org>
References: <43EC5655.1060504@web.de> <20060210124204.GC28676@harddisk-recovery.com> <43ECB4A4.6010005@tmr.com> <Pine.LNX.4.64.0602101700540.30925@twinlark.arctic.org> <20060213092204.GB3209@harddisk-recovery.nl> <43F2E526.9010409@web.de> <17395.45710.99321.522482@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> wrote:
> On Wednesday February 15, mirko.benz@web.de wrote:
>> E.g. Data and parity write requests are issued in parallel but only one 
>> finishes. This will
>> lead to inconsistent data. It will be undetected and can not be 
> If the array is degraded, that the inconsistency cannot be detected.

Hmm, if the array is degraded, then there is no redundancy at all, so
there is no chance for any inconsistency.

Btw., this reminds me... now when you have raid6 - when is a raid6
defined to be degraded? Perhaps you have equal issues there as with
raid1 >2 mirrors some months ago (resync was not started when 3rd
mirror failed and 1st and 2nd were inconsistent)?

> If the array is fully functioning, then any inconsistency will be
> corrected by a 'resync'.

Yes, because the redundancy is ignored and rebuilt.


regards
   Mario
-- 
Why did the tachyon cross the road?
Because it was on the other side.

