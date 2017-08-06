From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 5/5] testb: badblock support
Date: Sat, 5 Aug 2017 18:56:31 -0700
Message-ID: <CAA9_cmdcYq8yr9cO=Tm4bQ25OhFbhy=e2mNWtknFMPc5BqGEDA@mail.gmail.com>
References: <cover.1501945859.git.shli@fb.com> <76006963eb89552e91e3d6acf72199a75d45659a.1501945859.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <76006963eb89552e91e3d6acf72199a75d45659a.1501945859.git.shli@fb.com>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-block@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, Kernel Team <kernel-team@fb.com>, Kyungchan Koh <kyungchan.koh@gmail.com>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On Sat, Aug 5, 2017 at 8:51 AM, Shaohua Li <shli@kernel.org> wrote:
> From: Shaohua Li <shli@fb.com>
>
> Sometime disk could have tracks broken and data there is inaccessable,
> but data in other parts can be accessed in normal way. MD RAID supports
> such disks. But we don't have a good way to test it, because we can't
> control which part of a physical disk is bad. For a virtual disk, this
> can be easily controlled.
>
> This patch adds a new 'badblock' attribute. Configure it in this way:
> echo "+1-100" > xxx/badblock, this will make sector [1-100] as bad
> blocks.
> echo "-20-30" > xxx/badblock, this will make sector [20-30] good

Did you happen to overlook block/badblocks.c, or did you find it unsuitable?
