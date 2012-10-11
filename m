From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: task xfssyncd blocked while raid5 was in recovery
Date: Thu, 11 Oct 2012 06:20:02 -0500
Message-ID: <5076AB62.2070501@hardwarefreak.com>
References: <CACY-59dr2Gy5XgddD01yy+c5ktCgYvOdU9w-VX8GK27bvbbgRA@mail.gmail.com>,  <507561EB.1050308@hardwarefreak.com> <2012101110412757886112@meganovo.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012101110412757886112@meganovo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/10/2012 9:42 PM, hanguozhong wrote:

> Hm, I searched "XFS.. blocked for 120s" on google. There was a same problem 
> with me, the flowing is the link: 
> http://lists.debian.org/debian-kernel/2012/01/msg00274.html

That's not the same problem as you.  The INFO text doesn't tell you the
source of the problem, the included thread information does.  To debug
that you need to be an XFS developer.  Which is why you should report
that to the xfs list, not here.

> I use the tilera platform, so it is hard to upgrade to kernel 3.2.31 or 3.4.13.

Ahh, I didn't recognize your name.  You're the guy trying to build the 8
drive storage appliance with a 36 core Tilera chip.

What is the latest Tilera supported kernel?  Do they support any 3.x
series kernels?  How often do they update their kernel and userland code
so you can get badly needed bug fixes?

This is the 2nd glaring reason demonstrating you should have gone with
x86, or another fully supported low core count low power CPU (MIPS), as
I previously mentioned.

-- 
Stan

