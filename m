From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] uapi: fix linux/raid/md_p.h userspace compilation error
Date: Wed, 19 Apr 2017 09:59:19 -0700
Message-ID: <CAHH2K0bVH6f2yw-vuJtOHsk+z44o=vhzoXkSLwpsvvCnp2cRbA@mail.gmail.com>
References: <xr93wpak0xkb.fsf@gthelen.mtv.corp.google.com> <20170419084806.28405-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170419084806.28405-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, ncroxon@redhat.com
List-Id: linux-raid.ids

On Wed, Apr 19, 2017 at 1:48 AM, Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:
> Use __le32 and __le64 instead of u32 and u64.
>
> This fixes klibc build error:
>   In file included from /klibc/usr/klibc/../include/sys/md.h:30:0,
>                    from /klibc/usr/kinit/do_mounts_md.c:19:
>   /linux-next/usr/include/linux/raid/md_p.h:414:51: error: 'u32' undeclared here (not in a function)
>     (PPL_HEADER_SIZE - PPL_HDR_RESERVED - 4 * sizeof(u32) - sizeof(u64))
>
> Reported-by: Greg Thelen <gthelen@google.com>
> Reported-by: Nigel Croxon <ncroxon@redhat.com>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Tested-by: Greg Thelen <gthelen@google.com>

My klibc builds are working again.  Thanks.
