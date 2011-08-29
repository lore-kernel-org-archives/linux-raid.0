From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: MD devnode still present after 'remove' udev event, and mdadm reports
 'does not appear to be active'
Date: Mon, 29 Aug 2011 20:17:34 +0300
Message-ID: <CAGRgLy4K-sFpeHhu_f+7-F8Fa_L1OP7ki0X-_9858BbBQrnWOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings everybody,

I issue
mdadm --stop /dev/md0
and I want to reliably determine that the MD devnode (/dev/md0) is gone.
So I look for the udev 'remove' event for that devnode.
However, in some cases even after I see the udev event, I issue
mdadm --detail /dev/md0
and I get:
mdadm: md device /dev/md0 does not appear to be active

According to Detail.c, this means that mdadm can successfully do
open("/dev/md0") and receive a valid fd.
But later, when issuing ioctl(fd, GET_ARRAY_INFO) it receives ENODEV
from the kernel.

Can somebody suggest an explanation for this behavior? Is there a
reliable way to know when a MD devnode is gone?

Thanks,
  Alex.
