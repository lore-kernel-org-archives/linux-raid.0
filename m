From: linux@horizon.com
Subject: Does md work in 2.6 yet?
Date: 9 Sep 2003 15:08:18 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030909150818.23616.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A while ago (2.5.46 or so), I tried using the 2.6 kernel and
discovered that if you have large stripe sizes, it will send
a single bio for more than 256 sectors to the IDE driver,
which complains and doesn't do the I/O.

File system corruption follows shortly thereafter.  Ouch.

The obvious fix was just to propagate the minimum of the underlying
devices' maximum bio size to the md driver, but the general solution had
to cope with hot adds, which might include a new device with a smaller
bio size limit, and was difficult.

Has anyone managed a fix yet?  I've been a bit scared to try, although
read-only should be safe enough.

Thanks!
