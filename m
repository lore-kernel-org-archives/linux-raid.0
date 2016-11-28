From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/4 v2] mdmon: bad block support for external metadata - sysfs file open
Date: Mon, 28 Nov 2016 17:46:20 -0500
Message-ID: <wrfjlgw3kytf.fsf@redhat.com>
References: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>
        <1477558425-13332-2-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477558425-13332-2-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Thu, 27 Oct 2016 10:53:43 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> Open 'badblocks' and 'unacknowledged_bad_blocks' sysfs files for each
> disk in the array. Add them to the list of files observed by monitor.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  managemon.c | 17 +++++++++++++++++
>  mdadm.h     |  2 ++
>  monitor.c   |  7 ++++++-
>  3 files changed, 25 insertions(+), 1 deletion(-)

Applied!

Thanks,
Jes
