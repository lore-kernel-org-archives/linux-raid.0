From: syzbot <syzbot+1e46a0864c1a6e9bd3d8@syzkaller.appspotmail.com>
Subject: Re: WARNING in md_ioctl
Date: Mon, 25 Nov 2019 14:37:01 -0800
Message-ID: <000000000000f4160705983366e8@google.com>
References: <000000000000a52337056b065fb3@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000a52337056b065fb3@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: airlied@linux.ie, chris@chris-wilson.co.uk, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, rafael.antognolli@intel.com, rodrigo.vivi@intel.com, shli@kernel.org, syzkaller-bugs@googlegroups.com
List-Id: linux-raid.ids

syzbot has bisected this bug to:

commit 4b6ce6810a5dc0af387a238e8c852e0d3822381f
Author: Rafael Antognolli <rafael.antognolli@intel.com>
Date:   Mon Feb 5 23:33:30 2018 +0000

     drm/i915/cnl: WaPipeControlBefore3DStateSamplePattern

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13aeb522e00000
start commit:   c61a56ab Merge branch 'x86-urgent-for-linus' of git://git...
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=106eb522e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17aeb522e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4013180e7c7a9ff9
dashboard link: https://syzkaller.appspot.com/bug?extid=1e46a0864c1a6e9bd3d8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16bca207800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14819a47800000

Reported-by: syzbot+1e46a0864c1a6e9bd3d8@syzkaller.appspotmail.com
Fixes: 4b6ce6810a5d ("drm/i915/cnl:  
WaPipeControlBefore3DStateSamplePattern")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
