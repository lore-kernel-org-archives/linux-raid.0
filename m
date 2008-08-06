From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: [PATCH md] Allow raid10 resync to happening in larger chunks.
Date: Wed, 6 Aug 2008 11:01:35 +0200
Message-ID: <20080806090135.GA308@rap.rap.dk>
References: <1217917054-1725-1-git-send-email-neilb@suse.de> <1217917054-1725-2-git-send-email-neilb@suse.de> <1217917054-1725-3-git-send-email-neilb@suse.de> <1217917054-1725-4-git-send-email-neilb@suse.de> <1217917054-1725-5-git-send-email-neilb@suse.de> <1217917054-1725-6-git-send-email-neilb@suse.de> <1217917054-1725-7-git-send-email-neilb@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1217917054-1725-7-git-send-email-neilb@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil made this patch based on my patch to speed up raid10 resync.

It is a bit different, although it messes with exactly the two cinstant=
s
that I also changed. One difference is that Neil intiatlly only allocat=
es
1 MiB for buffers while my patch allocates 32 MiB. For the patch to wor=
k=20
as intended it is essential that something like 32 MiB be available for
buffers. I do not see how that is done in Neil's case, but then I do no=
t
know the code so well.  So how does it work, Neil?

Has your patch been tested, Neil?

Anyway if this i a difference between 32 MiB being available or not, I
think it is important that it be available at the start of the process
and available for the whole duration of the process. Is it a concern of
whether 32 Mib buffers be available? My take is that if you are running
raid, then you probably always have quite some memory.=20

best regards
keld


On Tue, Aug 05, 2008 at 04:17:34PM +1000, NeilBrown wrote:
> The raid10 resync/recovery code currently limits the amount of
> in-flight resync IO to 2Meg.  This was copied from raid1 where
> it seems quite adequate.  However for raid10, some layouts require
> a bit of seeking to perform a resync, and allowing a larger buffer
> size means that the seeking can be significantly reduced.
>=20
> There is probably no real need to limit the amount of in-flight
> IO at all.  Any shortage of memory will naturally reduce the
> amount of buffer space available down to a set minimum, and any
> concurrent normal IO will quickly cause resync IO to back off.
>=20
> The only problem would be that normal IO has to wait for all resync I=
O
> to finish, so a very large amount of resync IO could cause unpleasant
> latency when normal IO starts up.
>=20
> So: increase RESYNC_DEPTH to allow 32Meg of buffer (if memory is
> available) which seems to be a good amount.  Also reduce the amount
> of memory reserved as there is no need to keep 2Meg just for resync i=
f
> memory is tight.
>=20
> Thanks to Keld for the suggestion.
>=20
> Cc: Keld J=F8rn Simonsen <keld@dkuug.dk>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  drivers/md/raid10.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index d41bebb..e34cd0e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -76,11 +76,13 @@ static void r10bio_pool_free(void *r10_bio, void =
*data)
>  	kfree(r10_bio);
>  }
> =20
> +/* Maximum size of each resync request */
>  #define RESYNC_BLOCK_SIZE (64*1024)
> -//#define RESYNC_BLOCK_SIZE PAGE_SIZE
> -#define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
>  #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
> -#define RESYNC_WINDOW (2048*1024)
> +/* amount of memory to reserve for resync requests */
> +#define RESYNC_WINDOW (1024*1024)
> +/* maximum number of concurrent requests, memory permitting */
> +#define RESYNC_DEPTH (32*1024*1024/RESYNC_BLOCK_SIZE)
> =20
>  /*
>   * When performing a resync, we need to read and compare, so
> @@ -690,7 +692,6 @@ static int flush_pending_writes(conf_t *conf)
>   *    there is no normal IO happeing.  It must arrange to call
>   *    lower_barrier when the particular background IO completes.
>   */
> -#define RESYNC_DEPTH 32
> =20
>  static void raise_barrier(conf_t *conf, int force)
>  {
> --=20
> 1.5.6.3
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
