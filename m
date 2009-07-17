From: Justin Maggard <jmaggard10@gmail.com>
Subject: >16TB RAID0
Date: Thu, 16 Jul 2009 20:36:32 -0700
Message-ID: <150c16850907162036w44a13b3dn6d6039a8960ed141@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Has anybody here tried using a >16TB RAID0?  When I recently got my
hands on some 2TB drives, I decided to check out the current status of
large EXT4 filesystems on 32-bit systems.  I created a ~17TB RAID0,
and immediately had problems.  Andreas Dilger advised me to try out
his llverdev utility (kindly hosted by Val Aurora at
http://valhenson.livejournal.com/38933.html) to verify that the
underlying device is functioning properly.  Running "llverdev -p -v
/dev/md0" on a >16TB array resulted in a runaway process, with
llverdev and pdflush each eating up 100% of the CPU time on my two
cores, but not advancing the write offset.  The process did not appear
to be interruptable after more than 30 minutes, and I had to do a hard
shutdown.  A RAID0 just under 16TB ran through llverdev without a
hitch.

I'm in the process of running a RAID5 array through the same test now,
but it's already past the point where the RAID0 failed; so if it does
fail, it'll likely be due to a different cause.  Does anyone have any
ideas?  Has this never been done before?  I'm running debian on a
2.6.30.1 kernel.

-Justin
