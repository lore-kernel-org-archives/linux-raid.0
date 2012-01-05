From: Mikhail Balabin <mbalabin@gmail.com>
Subject: polling mdX/md/degraded in sysfs
Date: Thu, 5 Jan 2012 14:34:37 +0600
Message-ID: <CAC9iW=taiG0=JOXcrEDOWKoHswEAp1uRTP2UP=4MepBXNf2Lrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I'm playing around with monitoring software raid status via sysfs
entries. In my case it's a raid1 array. According to
Documentation/md.txt any md device with redundancy should contain file
"degraded" (for example, /sys/block/md0/md/degraded) with the number
of devices by which the arrays is degraded. It is stated that this
file can be polled to monitor changes in the array, but it does not
work for me. Here is my (stripped-down) python code:

import select
fileName = "/sys/block/md0/md/degraded"
epoll = select.epoll()
while(True):
  file = open(fileName)
  status = file.read()
  print(status)

  epoll.register(file.fileno(), select.EPOLLPRI|select.EPOLLERR)
  epoll.poll()
  print("==== poll ====")
  epoll.unregister(file.fileno())
  file.close()

The script works fine for /proc/mdstat or /proc/mounts, but does not
show any events for /sys/block/md0/md/degraded. Is there a problem in
my code? Or is the documentation inaccurate?

Mikhail Balabin
