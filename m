From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Thu, 23 Apr 2009 07:05:04 -0400
Message-ID: <F296B205-3CE7-4130-813D-66D63D78AE89@redhat.com>
References: <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090421181519.GA4114@lazy.lzy> <1240416414.10178.1.camel@cichlid.com> <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com> <20090423055132.GA29487@maude.comedia.it>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-63-184499863"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090423055132.GA29487@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-63-184499863
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 23, 2009, at 1:51 AM, Luca Berra wrote:
> On Wed, Apr 22, 2009 at 09:20:49PM -0400, Doug Ledford wrote:
>> On Apr 22, 2009, at 12:06 PM, Andrew Burgess wrote:
>>> On Tue, 2009-04-21 at 20:15 +0200, Piergiorgio Sartor wrote:
>>>
>>>> This might be a Fedora 10 issue, so maybe Doug would like
>>>> to comment.
>>>>
>>>> After reboot, someone, I guess udev, tries to automagically
>>>> start a RAID, so it assembles /dev/md_d127 with one of the
>>>> two components of /dev/md/boot (randomly, it seems).
>>>> Later, when /dev/md/boot is assembled, one drive is "busy",
>>>> because it belongs to /dev/md_d127, and the array is put
>>>> together degraded, i.e. with the other disk only.
>>>
>>> Just a "me too". I also started seeing this after upgrading to  
>>> fedora
>>> 10. I had to create a startup script to stop md_d0 and reassemble
>>> everything else.
>>
>>
>> Yeah, I found the cause for this while working on F11.  The problem  
>> is a race condition between udev and a call to mdadm -As in the  
>> rc.sysinit.  For F11, I solved this by making udev not process  
>> devices using incremental mode if we are still in the rc.sysinit  
>> script.  You can change /etc/udev/rules.d/70-mdadm.rules (I think  
>> that's the right name, it might be slightly off) to read something  
>> like this:
>>
>> # This file causes block devices with Linux RAID (mdadm) signatures  
>> to
>> # automatically cause mdadm to be run.
>> # See udev(8) for syntax
>>
>> SUBSYSTEM=="block", ACTION=="add",  
>> ENV{ID_FS_TYPE}=="linux_raid_member", \
>> 	IMPORT{program}="/sbin/mdadm --examine --export $tempnode", \
>> 	RUN+="/bin/bash -c '[ ! -f /dev/.in_sysinit ] && mdadm -I  
>> $env{DEVNAME}'"
>>
>>
>
> i believe i saw this as well, but not at startup, it was when i  
> manually
> run mdadm -As, so while your hack to prevent udev from assembling
> devices while in sysinit may not be a full solution.

No, it is.  In your situation, the rules line must have read  
ACTION="add|change".  The fact that the incremental assembly rule  
would watch a change event means that when mdadm opens any device to  
scan for a superblock and then closes it, it would trigger the rule  
(yes, just opening and closing the device special file will trigger a  
change event), which would then race with mdadm using it for its own  
purposes.  The rule above does not watch change events, only add  
events.  Those only happen once when the device is added, not when  
mdadm scans the devices looking for superblocks.  Any time mdadm races  
with itself, one trying to assemble and one trying to do incremental  
assembly, you get split arrays with neither one started.

>
> my solution was "rm -f /etc/udev/rules.d/70-mdadm.rules",
> works like a charm :P
>
> probably the best solution is preventing concurrent mdadm rules with a
> lock.
>
> Regards,
> L.
>
>
>
>
> -- 
> Luca Berra -- bluca@comedia.it
>        Communication Media & Services S.r.l.
> /"\
> \ /     ASCII RIBBON CAMPAIGN
>  X        AGAINST HTML MAIL
> / \
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-63-184499863
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknwS2cACgkQQ9aEs6Ims9iKLwCfejm0D3nrZmdlQsxek3eZNsaW
N40AoIi0B5yuz1tw+FGq87OSInUhiB4T
=YfsI
-----END PGP SIGNATURE-----

--Apple-Mail-63-184499863--
