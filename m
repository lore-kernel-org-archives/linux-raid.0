From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Proactive Drive Replacement
Date: Mon, 20 Oct 2008 12:35:50 -0500
Message-ID: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I was wondering about proactive drive replacement.
Specifically, let's assume we have a RAID5 (or 10 or whatever)
comprised of 3 drives, A, B, and C.
Let's assume we want to replace drive C with drive D, and the array is md0.
We want to minimize our rebuild windows.

The naive approach would be to:

--add drive D to md0
--fail drive C on md0
wait for the rebuild to finish.
(zero the superblock on drive C)
remove drive C

Obviously, this places the array in mortal danger if another drive
should fail during that time.
Could we not do something like this instead?

1. make sure md0 is using bitmaps
2. --fail drive C
3. create a new *single disk* raid1 from drive C
4. --add drive D to md99
5. --add md99 back into md1.
6. wait for md99's rebuild to finish
7. --fail and --remove md99
8. break md99
9. --add drive D to md0

The problem I see with the above is the creation of the raid1 which
overwrites the superblock. Is there some way to avoid that (--build?)?

The advantage is that the amount of time the array spends degraded is,
theoretically, very small. The disadvantages include complexity,
difficulty resuming in the case of more serious error (maybe), and *2*
windows during which the array is mortally vulnerable to a component
failure.

-- 
Jon
