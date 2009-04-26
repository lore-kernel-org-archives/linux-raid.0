From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sun, 26 Apr 2009 07:52:15 -0400
Message-ID: <302D7194-F25F-48B8-95E3-1A0A054A411F@redhat.com>
References: <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090421181519.GA4114@lazy.lzy> <1240416414.10178.1.camel@cichlid.com> <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com> <20090424191509.GA28484@lazy.lzy>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-91-446530184"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090424191509.GA28484@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-91-446530184
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 24, 2009, at 3:15 PM, Piergiorgio Sartor wrote:
> On Wed, Apr 22, 2009 at 09:20:49PM -0400, Doug Ledford wrote:
>>
>> # This file causes block devices with Linux RAID (mdadm) signatures  
>> to
>> # automatically cause mdadm to be run.
>> # See udev(8) for syntax
>>
>> SUBSYSTEM=="block", ACTION=="add",  
>> ENV{ID_FS_TYPE}=="linux_raid_member",
>> \
>> 	IMPORT{program}="/sbin/mdadm --examine --export $tempnode", \
>> 	RUN+="/bin/bash -c '[ ! -f /dev/.in_sysinit ] && mdadm -I
>> $env{DEVNAME}'"
>
> It seems the missing "change" is causing problems too.
>
> In fact, the first time the array is connected (it's
> hotpluggable), devices are "added", but the second
> time the devices are already there (not removed by
> unplug) and there is no "add" anymore, so the array
> is not assembled.

I'm guessing that you didn't completely stop all usage of the hotplug  
devices before you removed them as this works fine for me.  If the  
devices aren't completely stopped before removal, then the stack can't  
delete the devices.

> If the devices are deleted (rm /dev/md/...), then
> it works again (somehow, not really, to be honest).


Removing the /dev/md/ device files does nothing of value.  However, I  
will note that I've seen udev take up to 30 or 45 seconds to process a  
bunch of md raid removals at the same time (aka, I did mdadm -S /dev/ 
md/* and it took udev that long to remove all the old device files).   
So, make sure you have completely stopped arrays before removing the  
devices, then watch /dev/md/ to wait until udev does its job, then  
only replug the array after that has happened and things should work  
fine.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-91-446530184
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAkn0SvgACgkQQ9aEs6Ims9glUwCghb8kyrDqj5Biuwk9LA29C0zL
mroAn00sYEaLFl2uiWcweZJUW+gtgSzI
=5nxS
-----END PGP SIGNATURE-----

--Apple-Mail-91-446530184--
