From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and async
 writes
Date: Tue, 10 Feb 2004 11:20:40 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <402904D8.98747590@SteelEye.com>
References: <40198E85.29EBC8E0@SteelEye.com>
		<16422.62911.755570.855200@notabene.cse.unsw.edu.au>
		<4027E342.D02202F1@SteelEye.com> <16424.8182.876520.280031@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@SteelEye.com>
List-Id: linux-raid.ids

Neil Brown wrote:
 
> >
> > > - ioctl - By changing the size of mdu_array_info_t you have changed
> > >   the GET_ARRAY_INFO ioctl, so you lose backwards compatibility with
> > >   user-space tools.
> >
> > Yes, unfortunately...
> >
> > >   If you want to return more info with
> > >   GET_ARRAY_INFO (which is reasonable) we need to handle both the old
> > >   and new mdu_array_info_t sizes. Ditto for SET_ARRAY_INFO
> >
> > OK, I'll code this up and include it in the next patch. Some type of
> > versioning scheme (like what you've done with the superblock) would
> > probably do the trick.
> 
> When you change the structure size, you change the ioctl number so you
> can differentiate requests based just on the ioctl.
> so you would need to define a "struct mda_array_info_s_old" and  have
> #define GET_ARRAY_INFO          _IOR (MD_MAJOR, 0x11, mdu_array_info_t)
> #define GET_ARRAY_INFO_OLD      _IOR (MD_MAJOR, 0x11, struct mdu_array_info_s_old)
> 
> and handle each ioctl separately (or translate one into the other
> early in md_ioctl).

I was thinking of leaving the original ioctls alone and just adding two
new ioctls that would handle only the new parameters, something like:

#define GET_EXTRA_ARRAY_INFO    _IOR (MD_MAJOR, 0x15,
mdu_extra_array_info_t)
#define SET_EXTRA_ARRAY_INFO    _IOW (MD_MAJOR, 0x2b,
mdu_extra_array_info_t)

/* The extra array info structure is flexible, to allow for future
changes */
#define EXTRA_ARRAY_INFO_VERSION 1

typedef struct mdu_extra_array_info_s {
        __u32 extra_info_version;  /* EXTRA_ARRAY_INFO_VERSION */
        __u32 async_max_writes;    /* Max outstanding async writes (0 =
sync) */
        __u32 bitmap_fd;           /* The bitmap file descriptor (in
only)    */
        __u32 bitmap_chunksize;    /* The bitmap
chunksize                    */
        __u32 bitmap_daemon_sleep; /* The bitmap daemon sleep
period          */
        char bitmap_path[256];     /* The bitmap filename (out
only)          */
        char pad[4096-256-20];     /* Allow for future additions, empty
now   */
} mdu_extra_array_info_t;

So for older kernels, the ioctls would just error out and mdadm would
ignore that, and the array would be run using only the old features.
This will also allow me to get rid of the SET_BITMAP_FILE ioctl and just
use the SET_EXTRA_ARRAY_INFO ioctl for Assembling.

Sound OK?

--
Paul
