From: hank peng <pengxihan@gmail.com>
Subject: md-mod.start_dirty_degraded=1 can't work in boot command parameters
Date: Fri, 27 Nov 2009 11:50:31 +0800
Message-ID: <389deec70911261950u1e0c05a5jeca7b9c25deb46f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

kernel messages:

Jan 1 00:08:10 mcenter kernel: Command line: root=/dev/hda1 ro
console=tty0 vga=791 splash=silent md-mod.start_dirty_degraded=1
Jan 1 00:08:10 mcenter kernel: Kernel command line: root=/dev/hda1 ro
console=tty0 vga=791 splash=silent md-mod.start_dirty_degraded=1
Jan 1 00:08:10 mcenter kernel: Unknown boot option
`md-mod.start_dirty_degraded=1': ignoring

Then how to use this param in grub?
I think we should add __setup("start_dirty_degraded=", parse_func)  in
md.c, is it right?

-- 
The simplest is not all best but the best is surely the simplest!
