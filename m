From: Mike Lovell <mlovell@bluehost.com>
Subject: Re: [PATCH 0/2] Fixes for lots of arrays
Date: Tue, 31 May 2016 11:33:52 -0600
Message-ID: <CAK9wOaA0RaH7yPH83D2BxOLq41d3rC9Ck5E5nNauekSYkOZAng@mail.gmail.com>
References: <1463595794-17045-1-git-send-email-mlovell@bluehost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1463595794-17045-1-git-send-email-mlovell@bluehost.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

ping. its been about 2 week since i posted these. just following up on it.

mike

On Wed, May 18, 2016 at 12:23 PM, Mike Lovell <mlovell@bluehost.com> wrote:
> This patch series fixes two issues around having more than 127 arrays on a
> system. The first one fixes an issue with using a dev_t as int and the
> number going negative when the array number would be larger than 2<<19. This
> would happen when more than 128 arrays were created on the system without
> creating the arrays by name. Manually specifying the large number would also
> fail.
>
> The second patch changes find_free_devnm in mdopen.c to use go to (2<<9)-1
> after 128 arrays have been created. Newer versions of the kernel don't allow
> the user to specify an array number than 511 so mdadm shouldn't automatically
> choose a bigger number. There was discussion about checking for new_array
> in /sys/module/md_mod/parameters on the list but that parameter has been in
> the kernel since 2.6.29. Any kernel from the last 7 years would still be
> limited by the check so it probably isn't worth a special case.
>
> Mike Lovell (2):
>   Use dev_t for devnm2devid and devid2devnm
>   Change behavior in find_free_devnm when wrapping around.
>
>  Detail.c  | 4 ++--
>  Grow.c    | 2 +-
>  lib.c     | 2 +-
>  mapfile.c | 2 +-
>  mdadm.h   | 4 ++--
>  mdopen.c  | 6 +++---
>  util.c    | 6 +++---
>  7 files changed, 13 insertions(+), 13 deletions(-)
>
> --
> 1.9.1
>
