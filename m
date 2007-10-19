From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: mdadm 2.6.x regression, fails creation of raid1 w/ v1.0 sb and internal bitmap
Date: Fri, 19 Oct 2007 00:52:00 -0400
Message-ID: <170fa0d20710182152i4763c347r704c9d939e0a4638@mail.gmail.com>
References: <170fa0d20710170837g1b0cd549w3b7fe8e663a01b7e@mail.gmail.com>
	 <18198.62670.605246.270516@notabene.brown>
	 <170fa0d20710180510o1edff608p22953fa712e217f6@mail.gmail.com>
	 <18200.6319.487833.714355@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18200.6319.487833.714355@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/18/07, Neil Brown <neilb@suse.de> wrote:
>
> Sorry, I wasn't paying close enough attention and missed the obvious.
> .....
>
> On Thursday October 18, snitzer@gmail.com wrote:
> > On 10/18/07, Neil Brown <neilb@suse.de> wrote:
> > > On Wednesday October 17, snitzer@gmail.com wrote:
> > > > mdadm 2.4.1 through 2.5.6 works. mdadm-2.6's "Improve allocation and
> > > > use of space for bitmaps in version1 metadata"
> > > > (199171a297a87d7696b6b8c07ee520363f4603c1) would seem like the
> > > > offending change.  Using 1.2 metdata works.
> > > >
> > > > I get the following using the tip of the mdadm git repo or any other
> > > > version of mdadm 2.6.x:
> > > >
> > > > # mdadm --create /dev/md2 --run -l 1 --metadata=1.0 --bitmap=internal
> > > > -n 2 /dev/sdf --write-mostly /dev/nbd2
> > > > mdadm: /dev/sdf appears to be part of a raid array:
> > > >     level=raid1 devices=2 ctime=Wed Oct 17 10:17:31 2007
> > > > mdadm: /dev/nbd2 appears to be part of a raid array:
> > > >     level=raid1 devices=2 ctime=Wed Oct 17 10:17:31 2007
> > > > mdadm: RUN_ARRAY failed: Input/output error
>                                ^^^^^^^^^^^^^^^^^^
>
> This means there was an IO error.  i.e. there is a block on the device
> that cannot be read from.
> It worked with earlier version of mdadm because they used a much
> smaller bitmap.  With the patch you mention in place, mdadm tries
> harder to find a good location and good size for a bitmap and to
> make sure that space is available.
> The important fact is that the bitmap ends up at a different
> location.
>
> You have a bad block at that location, it would seem.

I'm a bit skeptical of that being the case considering I get this
error on _any_ pair of disks I try in an environment where I'm
mirroring across servers that each have access to 8 of these disks.
Each of the 8 mirrors consists of a local member and a remote (nbd)
member.  I can't see all 16 disks having the very same bad block(s) at
the end of the disk ;)

I feels to me like the calculation that you're making isn't leaving
adequate room for the 128K bitmap without hitting the superblock...
but I don't have hard proof yet ;)

> I would have expected an error in the kernel logs about the read error
> though - that is strange.

What about the "md2: failed to create bitmap (-5)"?

> What do
>   mdadm -E
> and
>   mdadm -X
>
> on each device say?

# mdadm -E /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : caabb900:616bfc5a:03763b95:83ea99a7
           Name : 2
  Creation Time : Fri Oct 19 00:38:45 2007
     Raid Level : raid1
   Raid Devices : 2

  Used Dev Size : 1464913648 (698.53 GiB 750.04 GB)
     Array Size : 1464913648 (698.53 GiB 750.04 GB)
   Super Offset : 1464913904 sectors
          State : clean
    Device UUID : 978cdd42:abaa82a1:4ad79285:1b56ed86

Internal Bitmap : -176 sectors from superblock
    Update Time : Fri Oct 19 00:38:45 2007
       Checksum : c6bb03db - correct
         Events : 0


    Array Slot : 0 (0, 1)
   Array State : Uu

# mdadm -E /dev/nbd2
/dev/nbd2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : caabb900:616bfc5a:03763b95:83ea99a7
           Name : 2
  Creation Time : Fri Oct 19 00:38:45 2007
     Raid Level : raid1
   Raid Devices : 2

  Used Dev Size : 1464913648 (698.53 GiB 750.04 GB)
     Array Size : 1464913648 (698.53 GiB 750.04 GB)
   Super Offset : 1464913904 sectors
          State : clean
    Device UUID : 180209d2:cff9b5d0:05054d19:2e4930f2

Internal Bitmap : -176 sectors from superblock
      Flags : write-mostly
    Update Time : Fri Oct 19 00:38:45 2007
       Checksum : 8416e951 - correct
         Events : 0


    Array Slot : 1 (0, 1)
   Array State : uU

# mdadm -X /dev/sdf
        Filename : /dev/sdf
           Magic : 6d746962
         Version : 4
            UUID : caabb900:616bfc5a:03763b95:83ea99a7
          Events : 0
  Events Cleared : 0
           State : OK
       Chunksize : 1 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 732456824 (698.53 GiB 750.04 GB)
          Bitmap : 715290 bits (chunks), 715290 dirty (100.0%)

# mdadm -X /dev/nbd2
        Filename : /dev/nbd2
           Magic : 6d746962
         Version : 4
            UUID : caabb900:616bfc5a:03763b95:83ea99a7
          Events : 0
  Events Cleared : 0
           State : OK
       Chunksize : 1 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 732456824 (698.53 GiB 750.04 GB)
          Bitmap : 715290 bits (chunks), 715290 dirty (100.0%)

> > > > mdadm: stopped /dev/md2
> > > >
> > > > kernel log shows:
> > > > md2: bitmap initialized from disk: read 22/22 pages, set 715290 bits, status: 0
> > > > created bitmap (350 pages) for device md2
> > > > md2: failed to create bitmap (-5)

I assumed that the RUN_ARRAY failed (via IO error) was a side-effect
of MD's inability to create the bitmap (-5):

md2: bitmap initialized from disk: read 22/22 pages, set 715290 bits, status: 0
created bitmap (350 pages) for device md2
md2: failed to create bitmap (-5)
md: pers->run() failed ...
md: md2 stopped.

So you're saying one has nothing to do with the other?

regards,
Mike
