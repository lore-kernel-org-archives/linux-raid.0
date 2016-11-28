From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 4/4 v4] mdmon: bad block support for external metadata - clear bad blocks
Date: Mon, 28 Nov 2016 17:50:13 -0500
Message-ID: <wrfjd1hfkymy.fsf@redhat.com>
References: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>
        <1477558425-13332-4-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477558425-13332-4-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Thu, 27 Oct 2016 10:53:45 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> If an update of acknowledged bad blocks file is notified, read entire
> bad block list from sysfs file and compare it against local list of bad
> blocks. If any obsolete entries are found, remove them from metadata.
>
> As mdmon cannot perform any memory allocation, new superswitch method
> get_bad_blocks is expected to return a list of bad blocks in metadata
> without allocating memory. It's up to metadata handler to allocate all
> required memory in advance.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  mdadm.h   |  7 ++++++
>  monitor.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 86 insertions(+), 2 deletions(-)

Applied!

Thanks,
Jes
