From: Steven Dake <sdake@mvista.com>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Wed, 20 Nov 2002 17:35:59 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DDC2A6F.2030307@mvista.com>
References: <20021120234743.GF29881@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Lars Marowsky-Bree wrote:

>>The md driver in linux uses a 'superblock' written to all devices in =
a
>>RAID to record the current state and geometry of a RAID and to allow
>>the various parts to be re-assembled reliably.
>>
>>The current superblock layout is sub-optimal.  It contains a lot of
>>redundancy and wastes space.  In 4K it can only fit 27 component
>>devices.  It has other limitations.
>>   =20
>>
>
>Yes. (In particular, getting all the various counters to agree with ea=
ch other
>is a pain ;-)
>
>Steven raises the valid point that multihost operation isn't currently
>possible; I just don't agree with his solution:
>
>- Activating a drive only on one host is already entirely possible.
>  (can be done by device uuid in initrd for example)
> =20
>
This technique doesn't work if autostart is set (the partition type is=20
tagged as a RAID volume) or if the user is stupid and starts the wrong=20
uuid by accident.  It also requires the user to keep track of which=20
uuids are used by which hosts, which is a pain.  Trust me, users will=20
start the wrong RAID volume and have a hard time keeping track of the=20
right UUIDs to asssemble.  The technique I use ensures that the RAID=20
volumes can all be set to autostart and only the correct volumes will b=
e=20
started on the correct host.

>- Activating a RAID device from multiple hosts is still not possible.
>  (Requires way more sophisticated locking support than we currently h=
ave)
> =20
>
The only application where having a RAID volume shareable between two=20
hosts is useful is for a clustering filesystem (GFS comes to mind).=20
 Since RAID is an important need for GFS (if a disk node fails, you=20
don't want ot loose the entire filesystem as you would on GFS) this=20
possibility may be worth exploring.

Since GFS isn't GPL at this point and OpenGFS needs alot of work, I've=20
not spent the time looking at it.

Neil have you thought about sharing an active volume between two hosts=20
and what sort of support would be needed in the superblock?

Thanks
-steve

>However, for none-RAID devices like multipathing I believe that activa=
ting a
>drive on multiple hosts should be possible; ie, for these it might not=
 be
>necessary to scribble to the superblock every time.
>
>(The md patch for 2.4 I sent you already does that; it reconstructs th=
e
>available paths fully dynamic on startup (by activating all paths pres=
ent);
>however it still updates the superblock afterwards)
>
>Anyway, on to the format:
>
> =20
>
>>The code in 2.5.lastest has all the superblock handling factored out =
so
>>that defining a new format is very straight forward.
>>
>>I would like to propose a new layout, and to receive comment on it..
>>
>>My current design looks like:
>>	/* constant array information - 128 bytes */
>>  u32  md_magic
>>  u32  major_version =3D=3D 1
>>  u32  feature_map     /* bit map of extra features in superblock */
>>  u32  set_uuid[4]
>>  u32  ctime
>>  u32  level
>>  u32  layout
>>  u64  size		/* size of component devices, if they are all
>>			 * required to be the same (Raid 1/5 */
>>  u32  chunksize
>>  u32  raid_disks
>>  char name[32]
>>  u32  pad1[10];
>>   =20
>>
>
>Looks good so far.
>
> =20
>
>>	/* constant this-device information - 64 bytes */
>>  u64  address of superblock in device
>>  u32  number of this device in array  /* constant over reconfigurati=
ons=20
>>  */
>>  u32  device_uuid[4]
>>   =20
>>
>
>What is "address of superblock in device" ? Seems redundant, otherwise=
 you
>would have been unable to read it, or am missing something?
>
>Special case here might be required for multipathing. (ie, device_uuid=
 =3D=3D 0)
>
> =20
>
>>  u32  pad3[9]
>>
>>	/* array state information - 64 bytes */
>>  u32  utime
>>   =20
>>
>
>Timestamps (also above, ctime) are always difficult. Time might not be=
 set
>correctly at any given time, in particular during early bootup. This f=
ield
>should only be advisory.
>
> =20
>
>>  u32  state    /* clean, resync-in-progress */
>>  u32  sb_csum
>>  u64  events
>>  u64  resync-position	/* flag in state if this is valid)
>>  u32  number of devices
>>  u32  pad2[8]
>>
>>	/* device state information, indexed by 'number of device in array'=20
>>	   4 bytes per device */
>>  for each device:
>>    u16 position     /* in raid array or 0xffff for a spare. */
>>    u16 state flags  /* error detected,  in-sync */
>>   =20
>>
>
>u16 !=3D u32; your position flags don't match up. I'd like to be able =
to take
>the "position in the superblock" as a mapping here so it can be found =
in this
>list, or what is the proposed relationship between the two?
>
> =20
>
>>The interpretation of the 'name' field would be up to the user-space
>>tools and the system administrator.
>>I imagine having something like:
>>	host:name
>>where if "host" isn't the current host name, auto-assembly is not
>>tried, and if "host" is the current host name then:
>>   =20
>>
>
>Oh, well. You seem to sort of have Steven's idea here too ;-) In that =
case,
>I'd go with the idea of Steven. Make that field a uuid of the host.
>
>
>
>Sincerely,
>    Lars Marowsky-Br=E9e <lmb@suse.de>
>
> =20
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
