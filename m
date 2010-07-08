From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: RE: [PATCH 27/33] extension of IncrementalRemove to store location
 (port) of removed device
Date: Thu, 8 Jul 2010 17:02:32 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8D84FCD@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C55@irsmsx504.ger.corp.intel.com>
 <20100706173230.4f98a118@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100706173230.4f98a118@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Tuesday, July 06, 2010 9:33 AM
> To: Czarnowska, Anna
> Cc: linux-raid@vger.kernel.org; Hawrylewicz Czarnowski, Przemyslaw;
> Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciechanowski, Ed;
> dledford@redhat.com
> Subject: Re: [PATCH 27/33] extension of IncrementalRemove to store
> location (port) of removed device
> 
> On Mon, 5 Jul 2010 10:40:54 +0100
> "Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:
> 
> > From: Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com>
> >
> >
> >
> > If the disk is taken out from its port this port information is lost.
> Only udev rule can provide us with this information, and then we have
> to store it somehow. This patch adds writing 'cookie' file in
> /var/run/mdadm directory in form of file named with value of <path-id>,
> containing the names of arrays holding this device before it was
> removed.
> >
> > FAILED_SLOTS constant has been added to hold the location of cookie
> files.
> >
> >
> >
> > Signed-off-by: Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com<mailto:przemyslaw.hawrylew
> icz.czarnowski@intel.com>>
> >
> > ---
> >
> >  Incremental.c |   63
> ++++++++++++++++++++++++++++++++++++++++++++++++++++----
> >
> >  Makefile      |    6 +++-
> >
> >  mdadm.h       |    8 +++++++
> >
> >  3 files changed, 70 insertions(+), 7 deletions(-)
> >
> >
> >
> > diff --git a/Incremental.c b/Incremental.c index 20e3445..adaefb9
> 100644
> >
> > --- a/Incremental.c
2> >
> > +++ b/Incremental.c
> >
> > @@ -937,19 +937,22 @@ int Incremental_container(struct supertype *st,
> char *devname, int verbose,
> >
> >   * raid arrays, and if so first fail (if needed) and then remove the
> device.
> >
> >   *
> >
> >   * @devname - The device we want to remove
> >
> > + * @id_path - name as found in /dev/disk/by-path for this device
> >
> >   *
> >
> >   * Note: the device name must be a kernel name like "sda", so
> >
> >   * that we can find it in /proc/mdstat
> >
> >   */
> >
> > -int IncrementalRemove(char *devname, char *path, int verbose)
> >
> > +int IncrementalRemove(char *devname, char *id_path, int verbose)
> >
> >  {
> >
> >       int mdfd;
> >
> >       int rv;
> >
> > -     struct mdstat_ent *ent;
> >
> > +     struct mdstat_ent *ent, *mds, *mi;
> >
> >       struct mddev_dev_s devlist;
> >
> > +     char path[PATH_MAX];
> >
> > +     FILE *id_fd;
> >
> >
> >
> > -     if (!path) {
> >
> > -           fprintf(stderr, Name ": incremental removal without --
> path <path_id> lacks "
> >
> > +     if (!id_path) {
> >
> > +           fprintf(stderr, Name ": incremental removal without --
> path <id_path> lacks "
> >
> >                   "the possibility to re-add new device in this
> port\n");
> >
> >             return 1;
> >
> >       }
> >
> > @@ -965,15 +968,65 @@ int IncrementalRemove(char *devname, char
> *path, int verbose)
> >
> >                   "of any array\n", devname);
> >
> >             return 1;
> >
> >       }
> >
> > +     strncpy(path, FAILED_SLOTS, PATH_MAX);
> >
> > +     if (mkdir(path, O_CREAT) < 0 && errno != EEXIST) {
> 
> It is incorrect to path O_CREAT to mkdir.
> It should be permission bits such as '0700' or S_IRWXU.
> 
> Also, the strncpy is pointless, just use
>     mkdir(FAILED_SLOTS, 0700)
Sure, good point

> 
> 
> >
> > +           fprintf(stderr, Name ": can't create file to save path to
> old disk\n");
> >
> > +           return 1;
> >
> > +     }
> >
> > +     snprintf(path, PATH_MAX, FAILED_SLOTS "/%s", id_path);
> >
> > +
> >
> > +     if ((id_fd = fopen(path, "w")) == NULL) {
> >
> > +           fprintf(stderr, Name ": can't create file to save path to
> old disk\n");
> >
> > +           return 1;
> >
> > +     }
> 
> Again, I don't think it is reasonably to failed the "-If" just because
> you
> cannot record the removal.
> 
> 
> >
> > -     Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
> >
> > +
> >
> > +     /* slightly different behavior for native and external */
> >
> > +     if (!is_external(ent->metadata_version)) {
> >
> > +           /* just write array device */
> >
> > +           if (fprintf(id_fd, "%s\n", ent->dev) < 0) {
> >
> > +                 fprintf(stderr, Name ": Failed to write to
> <id_path> cookie\n");
> >
> > +                 fclose(id_fd);
> >
> > +                 unlink(path);
> >
> > +           }
> 
> Do we really want to record the array as "md0" or "md127" ??
> 
> I would have thought we would record the uuid, probably together with
> the
> metadata type to ensure no ambiguity if some time passes before
> plugging a
> new device in.
> We may even want to let the metadata handler provide a string to save
> and
> later restore.
The requirements for this feature are not clear enough right now. We thought
of deleting cookies during de-assemblation or assemblation. Other alternative
we planned was to store UUID of array, as cookie timeout is not limited right 
now, and device name is obviously inappropriate. But this code above shows
the general idea.

> 
> Or on the other hand, do we need to record anything other than "this
> device
> was using in an md array" which tells is that it is appropriate for md
> to
> grab any device that is plugged in.
> Once a device has been taken for use by md, it should surely be put to
> the
> best use based on what the various policies allow, should it not?
> i.e. exactly the same slot in the same array is not necessary is it?
> (and if it is, then we would need to record the slot number, and I
> don't
> think you do).
Our point was to put new drive into the same container as previous disk, and
let mdmon make use of it.

> 
> 
> >
> > +#ifndef FAILED_SLOTS
> >
> > +#define FAILED_SLOTS "/var/run/failed-slots"
> >
> > +#endif /* FAILED_SLOTS */
> >
> 
> This should be in /var/run/mdadm/ somewhere.
> e.g. /var/run/mdadm/failed-slots.
Yes, you're right

> 
> NeilBrown

By the way, some rework of the hot-insert was needed, as in early udev rules /dev/disk/by-path links are not available.
The patches are ready, so if you want to take a look, I'm OK to send them. Otherwise we'll prepare new series of all patches with code reworked after your comments. I know, that new policy framework is getting ready, but we hope that parts of our work will comply with new design...

-- 
Przemyslaw Hawrylewicz-Czarnowski
