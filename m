From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] imsm: enable bad block support for imsm metadata
Date: Thu, 29 Dec 2016 14:29:03 -0500
Message-ID: <wrfjzijefsao.fsf@redhat.com>
References: <1482914287-17630-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1482914287-17630-1-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Wed, 28 Dec 2016 09:38:07 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> Enable bad block support for imsm metadata as commit e522751d605d
> ("seq_file: reset iterator to first record for zero offset") has been
> accepted in upstream kernel. Prior to that patch mdmon had not been able
> to read bad blocks sysfs file.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  super-intel.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Applied!

Thanks,
Jes
