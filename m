From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/2] super-intel: Simplify for() loop in ahci_enumerate_ports
Date: Fri, 11 Mar 2016 12:36:51 -0500
Message-ID: <wrfjio0s7w7g.fsf@redhat.com>
References: <1457711236-16990-1-git-send-email-pawel.baldysiak@intel.com>
	<1457711236-16990-2-git-send-email-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457711236-16990-2-git-send-email-pawel.baldysiak@intel.com>
	(Pawel Baldysiak's message of "Fri, 11 Mar 2016 16:47:16 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> This patch simplifies for() loop used in
> ahci_enumerate_ports(). It makes it more readable.
> Similar thing was done in b913501
> ({platform,super}-intel: Fix two resource leaks).
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Applied!

Thanks,
Jes
