From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID halting
Date: Fri, 24 Apr 2009 13:03:26 -0400
Message-ID: <CBD259F5-4214-4C0C-A1D7-16ABC0A2BA89@redhat.com>
References: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-80-292401879"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-80-292401879
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 24, 2009, at 12:52 AM, Leslie Rhorer wrote:
> I've done some reading, and it's been suggested a 128K chunk size  
> might be a
> better choice on my system than the default chunk size of 64K, so I  
> intend
> to create the new array on the raw devices with the command:
>
> mdadm --create --raid-devices=10 --metadata=1.2 --chunk=128 --level=6
> /dev/sd[a-j]

Go with a bigger chunk size.  Especially if you do lots of big file  
manipulation.  During testing (many years ago now, admittedly) with  
Dell for some benchmarks, it was determined that when using linux  
software raid, larger chunk sizes would tend to increase performance.   
In those tests, we settled on a 2MB chunk size.  I wouldn't recommend  
you go *that* high, but I could easily see 256k or 512k chunk sizes.   
However, you are using raid6 and that might impact the optimal chunk  
size towards smaller sizes.  A raid6 expert would need to comment on  
that.

> Does anyone have any better suggestions or comments on creating the  
> array
> with these options?  It is going to start as an 8T array and  
> probably grow
> to 30T by the end of this year or early next year, increasing the  
> number of
> drives to 12 and then swapping out the 1T drives for 3T drives,  
> hopefully
> after the price of 3T drives has dropped considerably.

I'm a big fan of the bitmap stuff.  I use internal bitmaps on all my  
arrays except boot arrays where they are so small it doesn't matter.   
However, the performance reduction you get from a bitmap is  
proportional to the granularity of the bitmap.  So, I use big bitmap- 
chunk sizes too (32768k is usually my normal bitmap size, but I'm  
getting ready to do some testing soon to see if I want to modify that  
for recent hardware).

> I intend to create an XFS file system on the raw RAID device, which  
> I am
> given to understand offers few if any disadvantages compared to
> partitioning the array, or partitioning the devices below the array,  
> for
> that matter, given I am devoting each entire device to the array and  
> the
> entire array to the single file system.  Does anyone strongly  
> disagree?  I
> see no advantage to LVM in this application, either.  Again, are  
> there any
> dissenting opinions?

Sounds right.

> Also, in my reading it was suggested by several researchers the best
> performance of an XFS file system is achieved if the stripe width of  
> the FS
> is set to be the same as the RAID array using the su and sw switches  
> in
> mkfs.xfs.

This is true of any raid aware file system.  I know how to do this for  
ext3, but not for xfs, so I won't comment further on that.  However,  
the stripe size is always chunk size * number of non-parity drives on  
a parity based array.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-80-292401879
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknx8N8ACgkQQ9aEs6Ims9i0EQCgsb5JZYTG0HOO7LkzUO2NoZGX
ibIAoIIefvvZ0jdxictT+9yPCgxu4l2K
=Ftwf
-----END PGP SIGNATURE-----

--Apple-Mail-80-292401879--
