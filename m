From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Wed, 22 Apr 2009 21:20:49 -0400
Message-ID: <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com>
References: <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090417183952.GA6090@lazy.lzy> <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090421181519.GA4114@lazy.lzy> <1240416414.10178.1.camel@cichlid.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-60-149444599"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1240416414.10178.1.camel@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-60-149444599
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 22, 2009, at 12:06 PM, Andrew Burgess wrote:
> On Tue, 2009-04-21 at 20:15 +0200, Piergiorgio Sartor wrote:
>
>> This might be a Fedora 10 issue, so maybe Doug would like
>> to comment.
>>
>> After reboot, someone, I guess udev, tries to automagically
>> start a RAID, so it assembles /dev/md_d127 with one of the
>> two components of /dev/md/boot (randomly, it seems).
>> Later, when /dev/md/boot is assembled, one drive is "busy",
>> because it belongs to /dev/md_d127, and the array is put
>> together degraded, i.e. with the other disk only.
>
> Just a "me too". I also started seeing this after upgrading to fedora
> 10. I had to create a startup script to stop md_d0 and reassemble
> everything else.


Yeah, I found the cause for this while working on F11.  The problem is  
a race condition between udev and a call to mdadm -As in the  
rc.sysinit.  For F11, I solved this by making udev not process devices  
using incremental mode if we are still in the rc.sysinit script.  You  
can change /etc/udev/rules.d/70-mdadm.rules (I think that's the right  
name, it might be slightly off) to read something like this:

# This file causes block devices with Linux RAID (mdadm) signatures to
# automatically cause mdadm to be run.
# See udev(8) for syntax

SUBSYSTEM=="block", ACTION=="add",  
ENV{ID_FS_TYPE}=="linux_raid_member", \
	IMPORT{program}="/sbin/mdadm --examine --export $tempnode", \
	RUN+="/bin/bash -c '[ ! -f /dev/.in_sysinit ] && mdadm -I  
$env{DEVNAME}'"



--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-60-149444599
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknvwnEACgkQQ9aEs6Ims9g3fwCg1fjjipxBIre5CnEUJY8NHDuF
dpUAni43I39zSpS6c1iYlMo4LkBamO0L
=Iv87
-----END PGP SIGNATURE-----

--Apple-Mail-60-149444599--
