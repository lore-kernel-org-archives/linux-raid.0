From: jes.sorensen@gmail.com
Subject: Re: [PATCH 1/1] imsm: fix missing error message during migration
Date: Thu, 26 Jan 2017 20:59:16 -0500
Message-ID: <wrfjefzpgt57.fsf@gmail.com>
References: <20170124132933.16943-1-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170124132933.16943-1-pawel.baldysiak@intel.com> (Pawel
        Baldysiak's message of "Tue, 24 Jan 2017 14:29:33 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> If user tries to migrate from raid0 to raid5 and there is no spare
> drive to perform it - mdadm will exit with errorcode, but
> no error message is printed.
>
> Print error instead of debug message when this condition occurs,
> so user is informed why requested migration is not started.
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes
