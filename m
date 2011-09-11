From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: mdadm/Monitor.c - never removes MD devices from statelist
Date: Sun, 11 Sep 2011 21:32:12 +0300
Message-ID: <CAGRgLy4=mq_py=Qr+Mk8MOvXY1fbwgeEmEr1kAcmiwHQfCZweg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everybody,
looking at the code of Monitor.c and doing some tests with it, I see
that it is capable of detecting new arrays, when they appear in
/proc/mdstat (if --scan is given). However, once array is added to
'statelist', it is never removed from there. Is this intentional?
Perhaps only if --scan is given, and device disappears from
/proc/mdstat, then it should be removed from monitoring, otherwise it
could stick there forever, even though the array has been gone long
time ago. And if it appears again, it will be picked up anyways.

Thanks,
  Alex.
