From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 11/33] fix: IncrementalRemove leaves open handle
Date: Tue, 6 Jul 2010 16:48:05 +1000
Message-ID: <20100706164805.4f669677@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C0C@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C0C@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

On Mon, 5 Jul 2010 10:23:52 +0100
"Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:

> From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
> 
> 
> 
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com<mailto:przemyslaw.hawrylewicz.czarnowski@intel.com>>
> 
> ---
> 
>  Incremental.c |    5 ++++-
> 
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> 
> 
> diff --git a/Incremental.c b/Incremental.c index 3501bc1..4455a89 100644
> 
> --- a/Incremental.c
> 
> +++ b/Incremental.c
> 
> @@ -866,6 +866,7 @@ int Incremental_container(struct supertype *st, char *devname, int verbose,  int IncrementalRemove(char *devname, int verbose)  {
> 
>       int mdfd;
> 
> +     int rv;
> 
>       struct mdstat_ent *ent;
> 
>       struct mddev_dev_s devlist;
> 
> 
> 
> @@ -890,7 +891,9 @@ int IncrementalRemove(char *devname, int verbose)
> 
>       devlist.disposition = 'f';
> 
>       Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
> 
>       devlist.disposition = 'r';
> 
> -     return Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
> 
> +     rv = Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
> 
> +     close(mdfd);
> 
> +     return rv;

All of these patches are formatted rather badly with lots of blank lines.

However this is simple and correct so I have applied this one by hand.

Thanks,
NeilBrown


> 
>  }
> 
> 
> 
>  /*
> 
> --
> 
> 1.6.4.2
> 
> 
> 
> ---------------------------------------------------------------------
> Intel Technology Poland sp. z o.o.
> z siedziba w Gdansku
> ul. Slowackiego 173
> 80-298 Gdansk
> 
> Sad Rejonowy Gdansk Polnoc w Gdansku, 
> VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
> numer KRS 101882
> 
> NIP 957-07-52-316
> Kapital zakladowy 200.000 zl
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.

