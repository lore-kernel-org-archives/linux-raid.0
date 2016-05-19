From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] IMSM: retry reading sync_completed during reshape
Date: Thu, 19 May 2016 10:45:39 -0400
Message-ID: <wrfjwpmqw1gs.fsf@redhat.com>
References: <146348428075.32064.12075746168157997590.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <146348428075.32064.12075746168157997590.stgit@gklab-154-222.intel.com>
	(Pawel Baldysiak's message of "Tue, 17 May 2016 13:24:41 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com, aleksey.obitotskiy@intel.com, tomasz.majchrzak@intel.com
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> The sync_completed after restarting a reshape
> (for example - after reboot) is set to "delayed" until
> mdmon changes the state. Mdadm does not wait for that change with
> old kernels. If this condition occurs - it exits and reshape
> is not continuing. This patch adds retry of reading sync_complete
> with a delay. It gives time for mdmon to change the "delayed" state.
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c |   17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)

Hi Pawel,

Applied, thanks!

I have to admit I don't like this kind of fixes very much, delaying and
hoping for something to happen in time, but with the APIs we have it's
probably the best we can do.

Cheers,
Jes
