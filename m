From: Chris Murphy <chris@colorremedies.com>
Subject: indefinite hang when growing/reshaping
Date: Wed, 17 Dec 2014 15:20:50 -0700
Message-ID: <CAJCQCtQWSVbx08xafh6MDikiJOZJ6MVJ4Jx=qt=UZnX3t47A7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If this is user error I'd expect a discreet error message, but I don't
get one, just a hang during the reshape following successful --grow
command (going from 3x device raid5 to 4x device raid5).

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : active raid5 loop3[4] loop2[3] loop1[1] loop0[0]
      2095104 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
      [>....................]  reshape =  0.0% (0/1047552)
finish=7.0min speed=2402K/sec

Reproduces with:
kernel-3.17.6-300.fc21.x86_64
mdadm-3.3.2-1.fc21.x86_64
and
3.18.0-2.fc22.i686+debug
mdadm-3.3.2-1.fc21.i686

Details are here:
https://bugzilla.kernel.org/show_bug.cgi?id=89851

-- 
Chris Murphy
