From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: mdadm --wait doesn't
Date: Sun, 5 Jul 2009 12:35:58 -0500
Message-ID: <cccedfc60907051035o1753ea61r7098c2ea2c8ded9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I was trying to use mdadm --wait a bit ago to wait for a recovery
operation, but mdadm --wait didn't actually wait.

Here is md12 after adding /dev/sdf1 back to it.

md12 : active raid1 sdf1[3] nbd0[2](W)(F) sde[0]
      72612988 blocks super 1.1 [3/1] [U__]
      [>....................]  recovery =  3.0% (2195456/72612988)
finish=51.4min speed=22805K/sec
      bitmap: 139/139 pages [556KB], 256KB chunk

However, mdadm /dev/md12 --wait (and --wait-clean) did not wait for
the recovery to be complete.

turnip:~ # mdadm /dev/md12 --wait
turnip:~ # echo $?
0
turnip:~ # mdadm --version
mdadm - v3.0 - 2nd June 2009

I would --fail and --remove /dev/sdf1 and try again (with --add), and
I did this several times, and I could not get it to wait until the
recovery was complete.

Am I doing something wrong? Did I mis-read the documentation?

kernel: 2.6.27.23, x86_64, openSUSE 11.1 "default" kernel.
mdadm version compiled out of latest git.


-- 
Jon
