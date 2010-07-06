From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 33/33] Try exclusive open on a spare device before it is
 added to another container.
Date: Tue, 6 Jul 2010 17:57:12 +1000
Message-ID: <20100706175712.7f881425@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C6B@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C6B@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids


There is no explanation of why you try an exclusive open.
I can only imagine that you are trying to close some sort of race.

I don't think that getting an exclusive open on a member device actually
closes the race, though it might make it harder to hit.

I think the protocol that we want is that before we add or remove a device to
a container, or reassign a device within a container we take an exclusive
open on the container.
mdadm can do this to add/remove devices.
managemon can do this to assign a spare to an array.

This is the protocol that Manage_subdevs uses I think.

NeilBrown




On Mon, 5 Jul 2010 10:45:26 +0100
"Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:

> From: Marcin Labun <marcin.labun@intel.com>
> 
> 
> 
> Signed-off-by: Marcin Labun <marcin.labun@intel.com<mailto:marcin.labun@intel.com>>
> 
> ---
> 
>  Monitor.c |   48 +++++++++++++++++++++++++++++++++++-------------
> 
>  1 files changed, 35 insertions(+), 13 deletions(-)
> 
> 
> 
> diff --git a/Monitor.c b/Monitor.c
> 
> index 932a2bc..a1ae67f 100644
> 
> --- a/Monitor.c
> 
> +++ b/Monitor.c
> 
> @@ -534,8 +534,9 @@ int Monitor(mddev_dev_t devlist,
> 
>       return 0;
> 
>  }
> 
> 
> 
> -static int move_spare(struct state *st2, struct state *st1, int i, char *mailaddr,
> 
> -                 char *mailfrom, char *alert_cmd, int dosyslog)
> 
> +static int move_spare(struct state *st2, struct state *st1, int i,
> 
> +                 char *mailaddr, char *mailfrom, char *alert_cmd,
> 
> +                 int dosyslog)
> 
> 
> 
>  {
> 
>       struct mddev_dev_s devlist;
> 
> @@ -570,20 +571,41 @@ static int move_spare(struct state *st2, struct state *st1, int i, char *mailadd
> 
> 
> 
>       devlist.disposition = 'r';
> 
>       if (Manage_subdevs(st2->devname, from_fd, &devlist, -1) == 0) {
> 
> -           devlist.disposition = 'a';
> 
> -           if (Manage_subdevs(st1->devname, to_fd, &devlist, -1) == 0) {
> 
> -                 st2->devid[i] = 0;
> 
> -                 ping_manager(st2->devname);
> 
> -                 ping_manager(st1->devname);
> 
> -                 alert("MoveSpare", st1->devname, st2->devname, mailaddr,
> 
> -                       mailfrom, alert_cmd, dosyslog);
> 
> -                 close(from_fd);
> 
> -                 close(to_fd);
> 
> -                 return 1;
> 
> +           int dfd;
> 
> +           dfd = open(dv, O_RDWR|O_EXCL);
> 
> +           if (dfd < 0) {
> 
> +                 fprintf(stderr,
> 
> +                       "Error: Exclusive open on device %s failed\n",
> 
> +                       dv);
> 
> +                 devlist.disposition = 'a';
> 
> +                 if (Manage_subdevs(st2->devname, from_fd, &devlist,
> 
> +                                -1) != 0)
> 
> +                       fprintf(stderr,
> 
> +                             "Error: Adding back spare device %s"
> 
> +                             "to container %s failed!\n",
> 
> +                             st2->devname, dv);
> 
>             } else {
> 
> -                 Manage_subdevs(st2->devname, from_fd, &devlist, -1);
> 
> +                 close(dfd);
> 
> +                 devlist.disposition = 'a';
> 
> +                 if (Manage_subdevs(st1->devname, to_fd, &devlist,
> 
> +                                -1) == 0) {
> 
> +                       st2->devid[i] = 0;
> 
> +                       ping_manager(st2->devname);
> 
> +                       ping_manager(st1->devname);
> 
> +                       alert("MoveSpare", st1->devname, st2->devname,
> 
> +                             mailaddr, mailfrom, alert_cmd, dosyslog);
> 
> +                       close(from_fd);
> 
> +                       close(to_fd);
> 
> +                       return 1;
> 
> +                 } else if (Manage_subdevs(st2->devname, from_fd,
> 
> +                                     &devlist, -1) != 0)
> 
> +                       fprintf(stderr,
> 
> +                             "Error: Adding back spare device"
> 
> +                             "%s to container %s failed!\n",
> 
> +                             st2->devname, dv);
> 
>             }
> 
>       }
> 
> +     /* Failed to add spare to new container */
> 
>       close(from_fd);
> 
>       close(to_fd);
> 
>       return 0;
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

