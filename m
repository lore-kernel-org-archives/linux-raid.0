From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2 mdadm] raid6check.c: fix "misleading-indentation" error
Date: Wed, 26 Oct 2016 12:00:24 -0400
Message-ID: <wrfjshrjm76v.fsf@redhat.com>
References: <1477469438-62688-1-git-send-email-yilongx.ren@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477469438-62688-1-git-send-email-yilongx.ren@intel.com> (Yilong
        Ren's message of "Wed, 26 Oct 2016 16:10:38 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Yilong Ren <yilongx.ren@intel.com>
Cc: LKP <lkp@eclists.intel.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yilong Ren <yilongx.ren@intel.com> writes:
> To fix the following error info:
>
> root@vm-lkp-nex04-8G-7 /tmp/mdadm# make test
> cc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" -DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM -DVERSION=\"3.4-43-g1dcee1c\" -DVERS_DATE="\"06th April 2016\"" -DUSE_PTHREADS -DBINDIR=\"/sbin\"  -c -o raid6check.o raid6check.c
> raid6check.c: In function 'manual_repair':
> raid6check.c:267:4: error: this 'else' clause does not guard... [-Werror=misleading-indentation]
>     else
>     ^~~~
> raid6check.c:269:5: note: ...this statement, but the latter is misleadingly indented as if it is guarded by the 'else'
>      printf("Repairing D(%d) and P\n", failed_data);
>      ^~~~~~
> cc1: all warnings being treated as errors
> <builtin>: recipe for target 'raid6check.o' failed
> make: *** [raid6check.o] Error 1
> root@vm-lkp-nex04-8G-7 /tmp/mdadm# 
>
>
> Cc: NeilBrown <neilb@suse.com>
> Cc: linux-raid <linux-raid@vger.kernel.org>
> Cc: LKP <lkp@eclists.intel.com>
> Reviewed-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> Signed-off-by: Yilong Ren <yilongx.ren@intel.com>
> ---
>  raid6check.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied!

However, in the future I would much prefer a sane commit message rather
than this auto generated noise which doesn't do a good job describing
the change.

Jes
