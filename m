From: "Harrell, Thomas" <tharrell@health.usf.edu>
Subject: Further clarification of the sync_action check behavior.
Date: Fri, 22 Feb 2008 12:46:15 -0500
Message-ID: <1AA1CDAD1BE022458D32739BDBB2F1AE0492633C@COMEXCHANGE.hscnet.hsc.usf.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: "Harrell, Thomas" <tharrell@health.usf.edu>
List-Id: linux-raid.ids

Hi!

	I have been reading the "Clarifications about check/repair, i.e.
RAID SCRUBBING" thread, and there were some answers which were still
slightly unclear to me, and I'd like to get a bit more clarification.
This is all in reference to the /sys/block/md0/md/sync_action setting.


Neil Brown wrote:
> 'check' just reads everything and doesn't trigger any writes unless a
> read error is detected, in which case the normally read-error handing
> kicks in.  So it can be useful on a read-only array.
>
> 'repair' does that same but when it finds an inconsistency is corrects
> it by writing something.
> If any raid personality had not be taught to specifically understand
> 'check', then a 'check' run would effect a 'repair'.  I think 2.6.17
> will have all personalities doing the right thing.
>
> check doesn't keep a record of problems, just a count.  'repair' will
> reprocess the whole array.

What exactly is the normal read-error handling behavior that is invoked
when 'check' detects a read error, especially in regards to raid level
5?

Also, why exactly is 'check' useful on a read-only array? Does this mean
on an array which has 'array_state' set to 'readonly'? In this case, I'm
guessing this is designed to be useful in repairing a dirty and degraded
array, correct?

Lastly, under which mounted conditions are 'check' and 'repair'
safe/useful? Can I run both on a read-write mounted partition? Should
they be read-only, or totally unmounted? I'm assuming since resyncs can
occur while the overlying fs is mounted read-write, that it is both safe
and useful to both 'check' and 'repair' while the fs is mounted
read-write as well, but I don't see this mentioned explicitly anywhere.

Please CC: me, as I'm not on the list.

Thank you very much!
TJ Harrell
