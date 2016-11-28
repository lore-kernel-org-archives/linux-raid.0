From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 3/4 v2] mdmon: bad block support for external metadata - store bad blocks
Date: Mon, 28 Nov 2016 17:49:23 -0500
Message-ID: <wrfjh96rkyoc.fsf@redhat.com>
References: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>
        <1477558425-13332-3-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477558425-13332-3-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Thu, 27 Oct 2016 10:53:44 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> If md has changed the state to 'blocked' and metadata handler supports
> bad blocks, try process them first. If metadata handler has successfully
> stored bad block, acknowledge it to md via 'badblocks' sysfs file. If
> metadata handler has failed to store the new bad block (ie. lack of
> space), remove bad block support for a disk by writing "-external_bbl"
> to state sysfs file. If all bad blocks have been acknowledged, request
> to unblock the array.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Acked-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  mdadm.h   |   4 +++
>  monitor.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 116 insertions(+)

Applied!

Thanks,
Jes
