From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Increase buffer for sysfs disk state
Date: Thu, 17 Nov 2016 09:46:56 -0500
Message-ID: <wrfjy40iduzj.fsf@redhat.com>
References: <1477560856-17310-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477560856-17310-1-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Thu, 27 Oct 2016 11:34:16 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> Bad block support has incremented sysfs disk state reported by kernel
> ("external_bbl") so it became longer than 20 bytes. It causes reshape to
> fail as it reads truncated entry from sysfs.
>
> Increase buffer so it can accommodate the string including all state
> values currently implemented in kernel at the same time.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  Grow.c        | 6 ++++--
>  monitor.c     | 4 ++--
>  super-intel.c | 5 +++--
>  3 files changed, 9 insertions(+), 6 deletions(-)

Applied!

Thanks,
Jes
