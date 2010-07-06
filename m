From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 32/33] Fix the count of member devices in mdstat_read
 function.
Date: Tue, 6 Jul 2010 17:51:09 +1000
Message-ID: <20100706175109.447fa94b@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C67@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C67@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

On Mon, 5 Jul 2010 10:45:05 +0100
"Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:

> From: Marcin Labun <marcin.labun@intel.com>
> 
> 
> 
> Correction of the number of container or volume member devices (devcnt in struct mdstat_ent). The number after the last devices was counted towards member of devices.

Thanks.
I have applied this fix, though I inverted the value returned by
add_member_devname so it is 0 for failure and 1 for success.
(if 0 is used for success, then it is best to use negative numbers for
failure I find).

NeilBrown


> 
> 
> 
> Signed-off-by: Marcin Labun <marcin.labun@intel.com<mailto:marcin.labun@intel.com>>
> 
> ---
> 
>  mdstat.c |   10 ++++++----
> 
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> 
> 
> diff --git a/mdstat.c b/mdstat.c
> 
> index 01a126b..5b9d997 100644
> 
> --- a/mdstat.c
> 
> +++ b/mdstat.c
> 
> @@ -94,19 +94,20 @@ static void free_member_devnames(struct dev_member *m)
> 
>       }
> 
>  }
> 
> 
> 
> -static void add_member_devname(struct dev_member **m, char *name)
> 
> +static int add_member_devname(struct dev_member **m, char *name)
> 
>  {
> 
>       struct dev_member *new;
> 
>       char *t;
> 
> 
> 
>       if ((t = strchr(name, '[')) == NULL)
> 
>             /* not a device */
> 
> -           return;
> 
> +           return 1;
> 
> 
> 
>       new = malloc(sizeof(*new));
> 
>       new->name = strndup(name, t - name);
> 
>       new->next = *m;
> 
>       *m = new;
> 
> +     return 0;
> 
>  }
> 
> 
> 
>  void free_mdstat(struct mdstat_ent *ms) @@ -207,8 +208,9 @@ struct mdstat_ent *mdstat_read(int hold, int start)
> 
>                   } else if (in_devs && strcmp(w, "blocks")==0)
> 
>                         in_devs = 0;
> 
>                   else if (in_devs) {
> 
> -                       ent->devcnt++;
> 
> -                       add_member_devname(&ent->members, w);
> 
> +
> 
> +                       if (add_member_devname(&ent->members, w) == 0)
> 
> +                             ent->devcnt++;
> 
>                         if (strncmp(w, "md", 2)==0) {
> 
>                               /* This has an md device as a component.
> 
>                                * If that device is already in the
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

