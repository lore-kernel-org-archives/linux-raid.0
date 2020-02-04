From: Song Liu <song@kernel.org>
Subject: Re: [PATCH] md: optimize barrier usage for Rmw atomic bitops
Date: Mon, 3 Feb 2020 16:25:50 -0800
Message-ID: <CAPhsuW6k10vZju0r_=HG81gWkZGMQD-0e5Rk-b3tZN7yDTi+jQ@mail.gmail.com>
References: <20200129181437.25155-1-dave@stgolabs.net> <a7358719-55af-6510-952e-df8f202f1ab9@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a7358719-55af-6510-952e-df8f202f1ab9@cloud.ionos.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, linux-raid <linux-raid@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-raid.ids

On Fri, Jan 31, 2020 at 8:43 AM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
>
>
>
> On 1/29/20 7:14 PM, Davidlohr Bueso wrote:
> > For both set and clear_bit, we can avoid the unnecessary barrier
> > on non LL/SC architectures, such as x86. Instead, use the
> > smp_mb__{before,after}_atomic() calls.
> >
> > Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

./scripts/checkpatch.pl reports the following:

=============== 8< =================
WARNING: memory barrier without comment
#81: FILE: drivers/md/md.c:2564:
+                       smp_mb__before_atomic();

WARNING: memory barrier without comment
#112: FILE: drivers/md/raid5.c:367:
+               smp_mb__before_atomic();

WARNING: Missing Signed-off-by: line by nominal patch author
'Davidlohr Bueso <dave@stgolabs.net>'

total: 0 errors, 3 warnings, 42 lines checked
=============== 8< =================

Since we are on it, let's add comments for the barriers. Also, please
double check the email
is correct.

Thanks,
Song
