From: Marc Smith <marc.smith@mcc.edu>
Subject: MD Remnants After --stop
Date: Fri, 4 Nov 2016 11:35:47 -0400
Message-ID: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

It may be that I've never noticed this before, so maybe its not a
problem... after using '--stop' to deactivate/stop an MD array, there
are remnants of it lingering, namely an entry in /sys/block (eg,
/sys/block/md127) and the device node in /dev remains (eg,
/dev/md127).

Is this normal? Like I said, it probably is, and I've just never
noticed it before. I assume its not going to hurt anything, but is
there a way to clean it up, without rebooting? Obviously I could
remove the /dev entry, but what about /sys/block?

Thanks for your time.


--Marc
