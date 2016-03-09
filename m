From: NeilBrown <nfbrown@novell.com>
Subject: Re: RAID6 Array crash during reshape.....now will not re-assemble.
Date: Wed, 09 Mar 2016 11:23:30 +1100
Message-ID: <874mcglcsd.fsf@notabene.neil.brown.name>
References: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Mar 02 2016, Another Sillyname wrote:

> I have a 30TB RAID6 array using 7 x 6TB drives that I wanted to
> migrate to RAID5 to take one of the drives offline and use in a new
> array for a migration.
>
> sudo mdadm --grow /dev/md127 --level=raid5 --raid-device=6
> --backup-file=mdadm_backupfile

First observation:  Don't use --backup-file unless mdadm tell you that
you have to.  New mdadm on new kernel with newly create arrays don't
need a backup file at all.  Your array is sufficiently newly created and
I think your mdadm/kernel are new enough too.  Note in the --examine output:

>    Unused Space : before=262056 sectors, after=143 sectors

This means there is (nearly) 128M of free space in the start of each
device.  md can perform the reshape by copying a few chunks down into
this space, then the next few chunks into the space just freed, then the
next few chunks ... and so on.  No backup file needed.  That is
providing the chunk size is quite a bit smaller than the space, and your
512K chunk size certainly is.

A reshape which increases the size of the array needs 'before' space, a
reshape which decreases the size of the array needs 'after' space.  A
reshape which doesn't change the size of the array (like yours) can use
either.

>
> I watched this using cat /proc/mdstat and even after an hour the
> percentage of the reshape was still 0.0%.

A more useful number to watch is the  (xxx/yyy) after the percentage.
The first number should change at least every few seconds.

>
> Reboot.....
>
> Array will not come back online at all.
>
> Bring the server up without the array trying to automount.
>
> cat /proc/mdstat shows the array offline.
>
> Personalities :
> md127 : inactive sdf1[2](S) sde1[3](S) sdg1[0](S) sdb1[8](S)
> sdh1[7](S) sdc1[1](S) sdd1[6](S)
>       41022733300 blocks super 1.2
>
> unused devices: <none>
>
> Try to reassemble the array.
>
>>sudo mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1
> mdadm: /dev/sdg1 is busy - skipping
> mdadm: /dev/sdh1 is busy - skipping
> mdadm: Merging with already-assembled /dev/md/server187.internallan.com:1

It looks like you are getting races with udev.  mdadm is detecting the
race and says that it is "Merging" rather than creating a separate array
but still the result isn't very useful...


When you  run "mdadm --assemble /dev/md127 ...." mdadm notices that /dev/md127
already exists but isn't active, so it stops it properly so that all the
devices become available to be assembled.
As the devices become available they tell udev "Hey, I've changed
status" and udev says "Hey, you look like part of an md array, let's put
you back together".... or something like that.  I might have the details
a little wrong - it is a while since I looked at this.
Anyway it seems that udev called "mdadm -I" to put some of the devices
together so they were busy when your "mdadm --assemble" looked at them.


> mdadm: Failed to restore critical section for reshape, sorry.
>        Possibly you needed to specify the --backup-file
>
>
> Have no idea where the server187 stuff has come from.

That is in the 'Name' field in the metadata, which must have been put
there when the array was created
>            Name : server187.internallan.com:1
>   Creation Time : Sun May 10 14:47:51 2015

It is possible to change it after-the-fact, but unlikely unless someone
explicitly tried.
I doesn't really matter how it got there as all the devices are the
same.
When "mdadm -I /dev/sdb1" etc is run by udev, mdadm needs to deduce a
name for the array.  It looks in the Name filed and creates

/dev/md/server187.internallan.com:1

>
> stop the array.
>
>>sudo mdadm --stop /dev/md127
>
> try to re-assemble
>
>>sudo mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1
>
> mdadm: Failed to restore critical section for reshape, sorry.
>        Possibly you needed to specify the --backup-file
>
>
> try to re-assemble using the backup file
>
>>sudo mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 --backup-file=mdadm_backupfile
>
> mdadm: Failed to restore critical section for reshape, sorry.

As you have noted else where, the backup file contains nothing useful.
That is causing the problem.

When an in-place reshape like yours (not changing the size of the array,
just changing the configuration) starts the sequence is something like:

 - make sure reshape doesn't progress at all (set md/sync_max to zero)
 - tell the kernel about the new shape of the array
 - start the reshape (this won't make any progress, but will update the
   metadata)
Start:
 - suspend user-space writes to the next few stripes
 - read the next few stripes and write to the backup file
 - tell the kernel that it is allowed to progress to the end of those
   'few stripes'
 - wait for the kernel to do that
 - invalidate the backup
 - resume user-space writes to those next few stripes
 - goto Start

(the process is actually 'double-buffered' so it is more complex, but
this gives the idea close enough)

If the system crashes or is shut down, on restart the kernel cannot know
if the "next few stripes" started reshaping or not, so it depends on
mdadm to load the backup file, check if there is valid data, and write
it out.

I suspect that part of the problem is that mdadm --grow doesn't initialize the
backup file in quite the right way, so when mdadm --assemble looks at it
it doesn't see "Nothing has been written yet" but instead sees
"confusion" and gives up.

If you --stop and then run the same --assemble command, including the
--backup, but this time add --invalid-backup (a bit like Wol
suggested) it should assemble and restart the reshape.  --invalid-backup
tells mdadm "I know the backup file is invalid, I know that means there
could be inconsistent data which won't be restored, but I know what is
going on and I'm willing to take that risk.  Just don't restore anything,
it'll be find.  Really".

I don't actually recommend doing that though.

It would be better to revert the current reshape and start again with no
--backup file.  This will use the new mechanism of changing the "Data
Offset" which is easier to work with and should be faster.

If you have the very latest mdadm (3.4) you can add
--update=revert-reshape together with --invalid-backup and in your case
this will cancel the reshape and let you start again.

You can test this out fairly safely if you want to.

   mkdir /tmp/foo
   mdadm --dump /tmp/foo /dev/.... list of all devices in the array

 This will create sparse files in /tmp/foo containing just the md
 metadata from those devices.  Use "losetup /dev/loop0 /tmp/foo/sdb1" etc
 to create loop-back device for all those files (there are multiple hard
 links to each file - just choose 1 each).
 Then you can experiment with mdadm on those /dev/loopXX files to see
 what happens.

Once you have the array reverted, you can start a new --grow, but don't
specify a --backup file.  That should DoTheRightThing.

This still leaves the question of why it didn't start a reshape in the
first place.  If someone would like to experiment (probably with
loop-back files) and produce a test case that reliably (or even just
occasionally) hangs, then I'm happy to have a look at it.

It also doesn't answer the question of why mdadm doesn't create the
backup file in a format that it knows is safe to ignore.  Maybe someone
could look into that.


Good luck :-)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW320CAAoJEDnsnt1WYoG5+ZMP/RcvxTJfw3O4enA+b/DjCR38
tFAJHwEpezReE5IXzU0hOcgQsl9TEGeFVhEslhhcM+/ZqHdfe9AsKjxO/92T84Ju
1Cy88BgcnHCg2sThAFGDxRQxMhv1Lk5pjttZNyFeicn4lem/SyN5q8ZR7Omqi8X9
LRAEG4zloK2e8zMRq4lnsC1BdZSvMsnHw/HWELhS2qHud7XyeiH4kyvy6MojaCCN
ed8MOaQnAT7dZriOuetJYtsbWrFvR+NPqmQ05jbdJdQC0ZvxqA4wmc5HIc92wOwP
EIMHtgm4txnezkPj2bC5WxoMRS5SUFmo2HEYvwUmmi94R7uA9SDeTXgotrQyMMhW
JdDBRGU9Yj2XDl9l3FQPDufC6B1t+d2BFhQwhd+vpd9t7GELsCaFgx/yVffopAFP
4BLtd9Qcw+ZlbxMSsGjgOfFOrfjqt2uNyLrtH18Mqh0+e47LSOE+k5wuHwZzOjli
yEBAs7bhRner8Tt4puUj4pvNIldZXTrU8SMCiIOakwET3trIDpEc0ExVZXr7mzVc
ojWfPHwiFLOJRty4VNdroQ0QnJO3YsStQUK4Ndnjieu0y7FoLqU+ZzwDN7TilAEM
+MGFEbrcuPKT1G2Co1xCrG/ji5cT6s84CY8WXP5INwgzL6JYfXl7IgzpP4JcVeXm
0FD1D1I4/cElD7paC6WO
=kkiW
-----END PGP SIGNATURE-----
--=-=-=--
