From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Subject: How to rename MD device (e.g. md3 -> md2)?
Date: Mon, 07 Apr 2008 17:48:02 +0200
Message-ID: <87zls53bv1.fsf@magla.zg.iskon.hr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list!

Does anybody know what would be the fastest way to rename MD device
(without recreating/resyncing)? I have md0, md1 and md3 in system (don't
ask :)), and obviously it would look slightly nicer if that md3 was
called md2 instead, like I have on other machines (with all the same
setup, except this small difference). Is it possible?

Thanks for any reply (and please Cc:, I'm not subscribed).

I'll also use this opportunity to thank everybody involved in the
development of RAID subsystem in Linux, cause it's a real data
saver. You saved my ass too many times to even count...

Keep up the good work, guys!
-- 
Zlatko

P.S. Debian sid, kernel 2.6.24, mdadm 2.6.4, using two disks in RAID 1
