From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Still can't get md arrays that were started from an initrd to shutdown
Date: Mon, 17 Jul 2006 22:55:55 +0200
Message-ID: <bb145bd20607171355x8143b0eofb0017637d749263@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[This is a bit of a repost, because I'm slightly desperate :)]

I'm still having problems with some md arrays not shutting down
cleanly on halt / reboot.

The problem seems to affect only arrays that are started via an
initrd, even if they do not have the root filesystem on them.
That's all arrays if they're either managed by EVMS or the
ramdisk-creator is initramfs-tools. For yaird-generated initrds only
the array with root on it is affected.

At the moment I'm working around the problem by inserting a sync and
15 second sleep before reboot / halt. That way the array _sometimes_
is switched into a read-only mode.

If only there were an exitrd imge to comlement the initrds ...

Any ideas welcome

Thank you,

Christian
