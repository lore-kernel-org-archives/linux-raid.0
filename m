From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/2] super-intel: Make print_vmd_attached_devs() return int again
Date: Fri, 11 Mar 2016 12:36:43 -0500
Message-ID: <wrfjmvq47w7o.fsf@redhat.com>
References: <1457711236-16990-1-git-send-email-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457711236-16990-1-git-send-email-pawel.baldysiak@intel.com>
	(Pawel Baldysiak's message of "Fri, 11 Mar 2016 16:47:15 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> This patch reverts a0abe1e
> (super-intel: Make print_found_intel_controllers() return void)
> and make this function "return int" again.
> Also, interpreting the return value is added.
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)

Applied!

Thanks,
Jes
