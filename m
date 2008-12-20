From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: can you help explain some --examine output to me?
Date: Fri, 19 Dec 2008 18:34:10 -0600
Message-ID: <cccedfc60812191634s74d77322pae0def691388c36e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

As part of the output from --explain (on a raid1 with a 1.0 metadata),
I see this:

    Array Slot : 3 (failed, failed, 0, 1)
   Array State : uU 2 failed

I read the first line as "This device is using slot 3. slot 0 is
failed, slot 1 is failed, slot 2 is RaidDevice 0, slot 3 is RaidDevice
1" where RaidDevice is the same as in the output for --detail. Is that
correct?

The second line is more opaque. What to little-u and big-u mean? Does
"2 failed" mean the raid thinks two devices have failed?


-- 
Jon
