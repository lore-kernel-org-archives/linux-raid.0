From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Samsung HD204UI (2TB F4EG) disk vs smart
Date: Wed, 16 Feb 2011 08:40:59 +1100
Message-ID: <4D5AF2EB.3060809@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Some of you already know this, but I thought it warrants a reminder
(I did not know...).

For the last month I was chasing a problem with my new RAID where a
large number of mismatches was reported in my weekly scrub.
I confirmed that I really had some data corruption.

I managed to not lose critical data but it surely was an uneasy period.
I commissioned new disks, new controller, and moved from f13 to f14
around the same time.

In the end the problem turned out to be the disks. It seems that these
popular (cheap) disks have a firmware bug that causes bad writes if a
specific smart command is issued at the right (wrong) time.

There is a fw fix but I found it not widely advertised. It can be found
here
     http://www.samsung.com/global/business/hdd/faqView.do?b2b_bbs_msg_id=386
Unfortunately it does *not* change the fw revision so you will not know
if your disk has the patch applied or not. I just applied it and so far
so good. My fw rev was (and still is) 1AQ10001.

FYI

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
