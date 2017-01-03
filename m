From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/1] IMSM: Fix signed/unsigned comparisons
Date: Tue, 03 Jan 2017 10:34:36 -0500
Message-ID: <wrfjmvf817jn.fsf@redhat.com>
References: <20170103142013.13132-1-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170103142013.13132-1-pawel.baldysiak@intel.com> (Pawel
        Baldysiak's message of "Tue, 3 Jan 2017 15:20:13 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> Prior to this patch there was an error during compiling
> on 32-bit arch. This patch fixes this issue.
>
> Reported-by: Thomas Backlund <tmb@mageia.org>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)

Hi Pawel,

I am not wildly in love with this approach, especially as it discards
the error code. I'll apply it for now, but I would like to see happen is
better explicit error handling throughout the code.

Cheers,
Jes
