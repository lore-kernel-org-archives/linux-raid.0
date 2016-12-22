From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH RESEND] IMSM: Do not update metadata if not able to migrate
Date: Thu, 22 Dec 2016 12:20:30 -0500
Message-ID: <wrfja8bnkhi9.fsf@redhat.com>
References: <20161222121047.32469-1-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161222121047.32469-1-pawel.baldysiak@intel.com> (Pawel
        Baldysiak's message of "Thu, 22 Dec 2016 13:10:47 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> This patch prevents mdadm from updating metadata if migration is
> not possible. The same check is done in analyse_change(),
> but in that place - metadata is already modified.
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c | 5 +++++
>  1 file changed, 5 insertions(+)

Applied!

Thanks,
Jes
