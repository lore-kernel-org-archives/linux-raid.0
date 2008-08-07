From: 'Keld =?iso-8859-1?Q?J=F8rn?= Simonsen' <keld@dkuug.dk>
Subject: Re: [PATCH md] Allow raid10 resync to happening in larger chunks.
Date: Thu, 7 Aug 2008 02:45:20 +0200
Message-ID: <20080807004520.GC9550@rap.rap.dk>
References: <20080806090135.GA308@rap.rap.dk> <200808062256.m76MupNY089428@sia.dkuug.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200808062256.m76MupNY089428@sia.dkuug.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: 'NeilBrown' <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 06, 2008 at 06:56:40PM -0400, Guy Watkins wrote:
> } -----Original Message-----
> } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> } owner@vger.kernel.org] On Behalf Of Keld J=F8rn Simonsen
> } Sent: Wednesday, August 06, 2008 5:02 AM
> } To: NeilBrown
> } Cc: linux-raid@vger.kernel.org
> } Subject: Re: [PATCH md] Allow raid10 resync to happening in larger =
chunks.
> }=20
> } Neil made this patch based on my patch to speed up raid10 resync.
> }=20
> } It is a bit different, although it messes with exactly the two cins=
tants
> } that I also changed. One difference is that Neil intiatlly only all=
ocates
> } 1 MiB for buffers while my patch allocates 32 MiB. For the patch to=
 work
> } as intended it is essential that something like 32 MiB be available=
 for
> } buffers. I do not see how that is done in Neil's case, but then I d=
o not
> } know the code so well.  So how does it work, Neil?
> }=20
> } Has your patch been tested, Neil?
> }=20
> } Anyway if this i a difference between 32 MiB being available or not=
, I
> } think it is important that it be available at the start of the proc=
ess
> } and available for the whole duration of the process. Is it a concer=
n of
> } whether 32 Mib buffers be available? My take is that if you are run=
ning
> } raid, then you probably always have quite some memory.
>=20
> Bad assumption!  My Linux firewall/router has 64MB total and works re=
ally
> well.  I have 2 disks in a RAID1.

well, well, you do not use the raid10-driver, then.

> Maybe the amount of memory could be based on a percentage of total RA=
M?

Anyway, if it works then Neil's patch is probably better than mine, as =
I
think it will aso run if 32 MiB is not availble.

Best regards
keld

> Guy
>=20
> }=20
> } best regards
> } keld
> }=20
> }=20
> } On Tue, Aug 05, 2008 at 04:17:34PM +1000, NeilBrown wrote:
> } > The raid10 resync/recovery code currently limits the amount of
> } > in-flight resync IO to 2Meg.  This was copied from raid1 where
> } > it seems quite adequate.  However for raid10, some layouts requir=
e
> } > a bit of seeking to perform a resync, and allowing a larger buffe=
r
> } > size means that the seeking can be significantly reduced.
> } >
> } > There is probably no real need to limit the amount of in-flight
> } > IO at all.  Any shortage of memory will naturally reduce the
> } > amount of buffer space available down to a set minimum, and any
> } > concurrent normal IO will quickly cause resync IO to back off.
> } >
> } > The only problem would be that normal IO has to wait for all resy=
nc IO
> } > to finish, so a very large amount of resync IO could cause unplea=
sant
> } > latency when normal IO starts up.
> } >
> } > So: increase RESYNC_DEPTH to allow 32Meg of buffer (if memory is
> } > available) which seems to be a good amount.  Also reduce the amou=
nt
> } > of memory reserved as there is no need to keep 2Meg just for resy=
nc if
> } > memory is tight.
> } >
> } > Thanks to Keld for the suggestion.
> } >
> } > Cc: Keld J=F8rn Simonsen <keld@dkuug.dk>
> } > Signed-off-by: NeilBrown <neilb@suse.de>
> } > ---
> } >  drivers/md/raid10.c |    9 +++++----
> } >  1 files changed, 5 insertions(+), 4 deletions(-)
> } >
> } > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> } > index d41bebb..e34cd0e 100644
> } > --- a/drivers/md/raid10.c
> } > +++ b/drivers/md/raid10.c
> } > @@ -76,11 +76,13 @@ static void r10bio_pool_free(void *r10_bio, v=
oid
> } *data)
> } >  	kfree(r10_bio);
> } >  }
> } >
> } > +/* Maximum size of each resync request */
> } >  #define RESYNC_BLOCK_SIZE (64*1024)
> } > -//#define RESYNC_BLOCK_SIZE PAGE_SIZE
> } > -#define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
> } >  #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_S=
IZE)
> } > -#define RESYNC_WINDOW (2048*1024)
> } > +/* amount of memory to reserve for resync requests */
> } > +#define RESYNC_WINDOW (1024*1024)
> } > +/* maximum number of concurrent requests, memory permitting */
> } > +#define RESYNC_DEPTH (32*1024*1024/RESYNC_BLOCK_SIZE)
> } >
> } >  /*
> } >   * When performing a resync, we need to read and compare, so
> } > @@ -690,7 +692,6 @@ static int flush_pending_writes(conf_t *conf)
> } >   *    there is no normal IO happeing.  It must arrange to call
> } >   *    lower_barrier when the particular background IO completes.
> } >   */
> } > -#define RESYNC_DEPTH 32
> } >
> } >  static void raise_barrier(conf_t *conf, int force)
> } >  {
> } > --
> } > 1.5.6.3
> } --
> } To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> } the body of a message to majordomo@vger.kernel.org
> } More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
