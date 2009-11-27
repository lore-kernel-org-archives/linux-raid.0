From: Neil Brown <neilb@suse.de>
Subject: Re: md-mod.start_dirty_degraded=1 can't work in boot command
 parameters
Date: Fri, 27 Nov 2009 16:48:20 +1100
Message-ID: <20091127164820.35be8ee5@notabene.brown>
References: <389deec70911261950u1e0c05a5jeca7b9c25deb46f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <389deec70911261950u1e0c05a5jeca7b9c25deb46f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hank peng <pengxihan@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 27 Nov 2009 11:50:31 +0800
hank peng <pengxihan@gmail.com> wrote:

> kernel messages:
> 
> Jan 1 00:08:10 mcenter kernel: Command line: root=/dev/hda1 ro
> console=tty0 vga=791 splash=silent md-mod.start_dirty_degraded=1
> Jan 1 00:08:10 mcenter kernel: Kernel command line: root=/dev/hda1 ro
> console=tty0 vga=791 splash=silent md-mod.start_dirty_degraded=1
> Jan 1 00:08:10 mcenter kernel: Unknown boot option
> `md-mod.start_dirty_degraded=1': ignoring
> 
> Then how to use this param in grub?
> I think we should add __setup("start_dirty_degraded=", parse_func)  in
> md.c, is it right?
> 


That command line option works for me.
My only thought is that you have md compiled as a separate module rather
than compiled in to the kernel.  If that is the case you need to get
modprobe or insmod to pass in the parameter I think.

NeilBrown
