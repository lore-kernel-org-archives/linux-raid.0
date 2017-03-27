From: Andy Smith <andy@strugglers.net>
Subject: Re-assembling array after double device failure
Date: Mon, 27 Mar 2017 13:38:13 +0000
Message-ID: <20170327133813.GQ4349@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm attempting to clean up after what is most likely a
timeout-related double device failure (yes, I know).

I just want to check I have the right procedure here.

So, initial situation was a two device RAID-10 (sdc, sdd). sdc saw
some I/O errors and was kicked. Contents of /proc/mdstat after that:

md4 : active raid10 sdc[0](F) sdd[1]
      3906886656 blocks super 1.2 512K chunks 2 far-copies [2/1] [_U]
      bitmap: 7/30 pages [28KB], 65536KB chunk

A couple of hours later, sdd also saw some I/O errors and was
similarly kicked. Neither /dev/sdc nor sdd appear as device nodes in
the system any more at this point and the controller doesn't see
them.

sdd was re-plugged and re-appeared as sdg.

A mdadm --examine /dev/sdg looks like:

/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 4100ddce:8edf6082:ba50427e:60da0a42
           Name : elephant:4  (local to host elephant)
  Creation Time : Fri Nov 18 22:53:10 2016
     Raid Level : raid10
   Raid Devices : 2

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 3906886656 (3725.90 GiB 4000.65 GB)
  Used Dev Size : 7813773312 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=1712 sectors
          State : active
    Device UUID : d9c9d81d:c487599a:3d3e3a30:0c512610

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Mar 26 00:00:01 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : ec70d450 - correct
         Events : 298824

         Layout : far=2
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : .A ('A' == active, '.' == missing, 'R' == replacing)

mdadm config:

$ grep -v '^#' /etc/mdadm/mdadm.conf | grep -v '^$'
DEVICE /dev/sd*
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
MAILADDR root
ARRAY /dev/md/0  metadata=1.2 UUID=400bac1d:e2c5d6ef:fea3b8c8:bcb70f8f
ARRAY /dev/md/1  metadata=1.2 UUID=e29c8b89:705f0116:d888f77e:2b6e32f5
ARRAY /dev/md/2  metadata=1.2 UUID=039b3427:4be5157a:6e2d53bd:fe898803
ARRAY /dev/md/3  metadata=1.2 UUID=30f745ce:7ed41b53:4df72181:7406ea1d
ARRAY /dev/md/4  metadata=1.2 UUID=4100ddce:8edf6082:ba50427e:60da0a42
ARRAY /dev/md/5  metadata=1.2 UUID=957030cf:c09f023d:ceaebb27:e546f095

(other arrays are on different devices and are not involved here)

So, I think I need to:

- Increase /sys/block/sdg/device/timeout to 180 (already done). TLER
  not supported.

- Stop md4.

  mdadm --stop /dev/md4

- Assemble it again.

  mdadm --assemble /dev/md4

 Theory being that there is at least one good device (sdg that was
 sdd).

- If that complains, I would then have to consider re-creating the
  array with something like:

  mdadm --create --assume-clean --level=10 --layout=f2 missing /dev/sdd

- Once it's up and running, add sdc back in and let it sync

- Make timeout changes permanent.

Does that seem correct?

I'm fairly confident that the drives themselves are actually okay -
nothing untoward in SMART data - so I'm not going to replace them at
this stage.

Cheers,
Andy
