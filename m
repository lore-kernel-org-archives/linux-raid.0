From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Multiple arrays out of devices belonging to single array
Date: Fri, 05 Dec 2014 12:27:31 +0300
Message-ID: <54817A83.6020000@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

We in Debian have 2 rather similar bugreports which are somewhat old:
 http://bugs.debian.org/599352
 http://bugs.debian.org/694513
Last bugreport is against mdadm-3.2.5, so not THAT old.

Basically, it smells like there's a possibility for mdadm to assemble
more than one (degraded) array out of components of the same array.

So I wonder if mdadm or kernel have some protection of this situation
from happening.  Something like looking at already active/assembled
devices to see if the same UUID is already used before trying to
assemble another array.

It might be better done in kernel because this way the process might
be freee from races when two mdadm instances tries to do the work in
parallel.

Are these bugs for real?

Thanks,

/mjt
