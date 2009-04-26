From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sun, 26 Apr 2009 14:06:31 -0400
Message-ID: <3649DFAC-EFCA-4E81-B459-7A601156B5A6@redhat.com>
References: <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090421181519.GA4114@lazy.lzy> <1240416414.10178.1.camel@cichlid.com> <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com> <20090424191509.GA28484@lazy.lzy> <302D7194-F25F-48B8-95E3-1A0A054A411F@redhat.com> <20090426121412.GA11921@lazy.lzy> <20090426125852.GA14517@lazy.lzy>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-94-468986927"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090426125852.GA14517@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-94-468986927
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 26, 2009, at 8:58 AM, Piergiorgio Sartor wrote:
> On Sun, Apr 26, 2009 at 02:14:12PM +0200, Piergiorgio Sartor wrote:
>> On Sun, Apr 26, 2009 at 07:52:15AM -0400, Doug Ledford wrote:
>>>
>>> I'm guessing that you didn't completely stop all usage of the  
>>> hotplug
>>> devices before you removed them as this works fine for me.  If the
>>> devices aren't completely stopped before removal, then the stack  
>>> can't
>>> delete the devices.
> [...]
>
> This is the same F10 standard, but without the "change"
> option in the "ACTION".

F10 still has some issues.  For things to work well, you need both the  
64-md-raid.rules file from the latest udev package and also the 65-md- 
incremental.rules file from the F11 mdadm package.

> On hotplug, I get a mess in the arrays, not all and
> not always they are properly added.
> This is similar to what happen with "change" in place.
> Already at this point, something is fishy.
>
> The /dev/md contains:
>
> vol00    vol00p4  vol01p3  vol02p2  vol03p1  vol04    vol04p4   
> vol05p3  vol06p2
> vol00p1  vol01    vol01p4  vol02p3  vol03p2  vol04p1  vol05     
> vol05p4  vol06p3
> vol00p2  vol01p1  vol02    vol02p4  vol03p3  vol04p2  vol05p1   
> vol06    vol06p4
> vol00p3  vol01p2  vol02p1  vol03    vol03p4  vol04p3  vol05p2  vol06p1

The partitions are there because of the --auto=yes in the incremental  
command in the udev rules file.  For F11 and later, since we no longer  
specifically need partitionable arrays as all block devices are now  
partitionable, you don't get this unless partitions actually exist on  
the device.

> Note that these arrays have no partitions and no
> filesystem, since they are PV of LVM.
> The vol0X are the names of the arrays.
>
> I manually remove the arrays, with "mdadm --stop --scan".
> Now, the files are still there after removing the arrays,
> even if there is no sign of the RAID in /proc/mdstat.
> After un-plug, they are still there.

This is also because of the --auto=yes line in the incremental command  
combined with the older 64-md-raid.rules file from udev.  In the  
latest version, udev creates all the files, mdadm creates none.  Also,  
it might be caused by the md devices never really getting deleted at  
the kernel level.  I'm not sure what kernel version the code to  
actually fully delete an md device on stop went in, but without that,  
udev doesn't know to remove the old files.

> If I hot plug again the device, nothing happens, the arrays
> are not auto-started by udev.
> If I remove the /dev/md/vol* files, then it does something,
> even if not correctly, as mentioned above.
>
> If I tried, from command line:
>
> mdadm -I --auto=yes /dev/sdd1
>
> I get:
>
> mdadm: failed to open /dev/md/vol00: File exists.
>
> If I delete the /dev/md/vol* files, and I do manually
> the "-I" thing with all the proper devices, the array
> is assembled properly.
>
> mdadm -I --auto=yes /dev/sdd1
> /dev/md_vol00p1: File exists
> /dev/md_vol00p2: File exists
> /dev/md_vol00p3: File exists
> /dev/md_vol00p4: File exists
> mdadm: /dev/sdd1 attached to /dev/md/vol00, not enough to start (1).
>
> Note that the /dev/md/ was empty before the command
> was given.
>
> I tried, right now, to re-add "change", and I get the same
> result, so it seems the "add|change" or "add" alone are
> doing the same, but still there are two problems.
> One is that the arrays are not assembled properly, the
> other is that they're not assembled at all if the files
> are there.


You can update the two udev rules files and things should work fine  
after that.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-94-468986927
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAkn0oq4ACgkQQ9aEs6Ims9jb1gCg3ogWeOOqikhr8P7Jm6o2Q7fo
XEEAni+atqxByRxRiyelL02RjlOd68Td
=ee+J
-----END PGP SIGNATURE-----

--Apple-Mail-94-468986927--
