From: DeadManMoving <sequel@neofreak.org>
Subject: Re: failed RAID 5 array
Date: Fri, 14 Nov 2014 09:08:51 -0500
Message-ID: <1415974131.4241.41.camel@lappy.neofreak.org>
References: <1415807882.4241.36.camel@lappy.neofreak.org>
	 <54653735.90007@turmel.org> <1415971164.4241.38.camel@lappy.neofreak.org>
	 <546606D4.5070406@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <546606D4.5070406@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, DeadManMoving <sequel@neofreak.org>
List-Id: linux-raid.ids

Hi Phil,

Unfortunately, that does not work :

# mdadm --assemble --force /dev/md127 /dev/sd[fhi]
mdadm: /dev/md127 assembled from 2 drives - not enough to start the
array.
# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md127 : inactive sdf[1](S) sdh[4](S) sdi[2](S)
      5860540680 blocks super 1.2
       
unused devices: <none>
# mdadm -D /dev/md127
/dev/md127:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 3
    Persistence : Superblock is persistent

          State : inactive

           Name : abc:xyz  (local to host abc)
           UUID : d707f577:a9e572d5:e5d5f10c:b232f15a
         Events : 9370

    Number   Major   Minor   RaidDevice

       -       8       80        -        /dev/sdf
       -       8      112        -        /dev/sdh
       -       8      128        -        /dev/sdi



I don't think that booting with an alternate boot media will help me out
as kernel and mdadm software are quite recent :

# uname -r
3.14.14-gentoo
# mdadm -V
mdadm - v3.3.1 - 5th June 2014



Thanks again,

Tony

On Fri, 2014-11-14 at 08:42 -0500, Phil Turmel wrote:
> On 11/14/2014 08:19 AM, DeadManMoving wrote:
> > Hi Phil,
> > 
> > Thank you so much to have taken the time to write back to me.
> > 
> > I already tried --assemble --force, indeed and, that did not work. I
> > guess it can work if you have a single drive which is out of sync but in
> > my case, it is a mix of a drive with a problematic superblock (dmesg =
> > does not have a valid v1.2 superblock, not importing!) plus a drive
> > which is out of sync (dmesg = kicking non-fresh sdx from array!).
> > 
> > Here is the output of --assemble --force with double verbose :
> > 
> > 
> > # mdadm -vv --assemble
> > --force /dev/md127 /dev/sdf /dev/sdg /dev/sdh /dev/sdi
> > mdadm: looking for devices for /dev/md127
> > mdadm: /dev/sdf is busy - skipping
> > mdadm: /dev/sdh is busy - skipping
> > mdadm: /dev/sdi is busy - skipping
> > mdadm: Merging with already-assembled /dev/md/xyz
> > mdadm: /dev/sdi is identified as a member of /dev/md/xyz, slot 2.
> > mdadm: /dev/sdh is identified as a member of /dev/md/xyz, slot 3.
> > mdadm: /dev/sdf is identified as a member of /dev/md/xyz, slot 1.
> > mdadm: /dev/sdg is identified as a member of /dev/md/xyz, slot 0.
> > mdadm: /dev/sdf is already in /dev/md/xyz as 1
> > mdadm: /dev/sdi is already in /dev/md/xyz as 2
> > mdadm: /dev/sdh is already in /dev/md/xyz as 3
> > mdadm: failed to add /dev/sdg to /dev/md/xyz: Invalid argument
> > mdadm: failed to RUN_ARRAY /dev/md/xyz: Input/output error
> > 
> > 
> > If i stop the array (which was autostarted) and retry, similar output :
> > 
> > 
> > # mdadm -S /dev/md127
> > mdadm: stopped /dev/md127
> > # mdadm -vv --assemble
> > --force /dev/md127 /dev/sdf /dev/sdg /dev/sdh /dev/sdi
> > mdadm: looking for devices for /dev/md127
> > mdadm: /dev/sdf is identified as a member of /dev/md127, slot 1.
> > mdadm: /dev/sdg is identified as a member of /dev/md127, slot 0.
> > mdadm: /dev/sdh is identified as a member of /dev/md127, slot 3.
> > mdadm: /dev/sdi is identified as a member of /dev/md127, slot 2.
> > mdadm: added /dev/sdf to /dev/md127 as 1
> > mdadm: added /dev/sdi to /dev/md127 as 2
> > mdadm: added /dev/sdh to /dev/md127 as 3 (possibly out of date)
> > mdadm: failed to add /dev/sdg to /dev/md127: Invalid argument
> > mdadm: failed to RUN_ARRAY /dev/md127: Input/output error
> > 
> > 
> > Here is the relevant dmesg output :
> > 
> > [173174.307703]  sdf: unknown partition table
> > [173174.308374]  sdg: unknown partition table
> > [173174.308811] md: bind<sdf>
> > [173174.309385]  sdh: unknown partition table
> > [173174.309552] md: bind<sdi>
> > [173174.310411]  sdi: unknown partition table
> > [173174.310573] md: bind<sdh>
> > [173174.311299]  sdi: unknown partition table
> > [173174.311449] md: invalid superblock checksum on sdg
> > [173174.311450] md: sdg does not have a valid v1.2 superblock, not
> > importing!
> > [173174.311460] md: md_import_device returned -22
> > [173174.311482] md: kicking non-fresh sdh from array!
> > [173174.311498] md: unbind<sdh>
> > [173174.311909]  sdh: unknown partition table
> > [173174.338007] md: export_rdev(sdh)
> > [173174.338651] md/raid:md127: device sdi operational as raid disk 2
> > [173174.338652] md/raid:md127: device sdf operational as raid disk 1
> > [173174.338868] md/raid:md127: allocated 0kB
> > [173174.338880] md/raid:md127: not enough operational devices (2/4
> > failed)
> > [173174.338886] RAID conf printout:
> > [173174.338887]  --- level:5 rd:4 wd:2
> > [173174.338887]  disk 1, o:1, dev:sdf
> > [173174.338888]  disk 2, o:1, dev:sdi
> > [173174.339013] md/raid:md127: failed to run raid set.
> > [173174.339014] md: pers->run() failed ...
> 
> Hmmm.  Should have worked.  Please show kernel version and mdadm
> version.  There have been bugs fixed in this area in the past couple years.
> 
> Also try "mdadm --assemble --force /dev/mdX /dev/sd[fhi]", leaving out
> the bad disk.
> 
> If it still doesn't work, use alternate boot media, like systemrescuecd,
> to get a current kernel and mdadm combination and try again.  If that
> works, get your critical backups before you do anything else.
> 
> Then you can reboot back to your normal kernel and it should assemble
> degraded.
> 
> Phil
> 

