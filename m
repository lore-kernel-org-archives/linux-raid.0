From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/4] mdadm: bad block support for external metadata - initialization
Date: Mon, 28 Nov 2016 17:45:22 -0500
Message-ID: <wrfjpolfkyv1.fsf@redhat.com>
References: <wrfjr35vpw2j.fsf@redhat.com>
        <1480342025-19508-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1480342025-19508-1-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Mon, 28 Nov 2016 15:07:05 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> If metadata handler provides support for bad blocks, tell md by writing
> 'external_bbl' to rdev state file (both on create and assemble),
> followed by a list of known bad blocks written via sysfs 'bad_blocks'
> file.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  mdadm.h | 13 +++++++++++++
>  sysfs.c | 27 ++++++++++++++++++++++++++-
>  2 files changed, 39 insertions(+), 1 deletion(-)

Applied!

Thanks,
Jes
