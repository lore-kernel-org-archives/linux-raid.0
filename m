From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Fri, 24 Apr 2009 12:46:39 -0400
Message-ID: <5FD80727-8CE9-47DF-8985-0E8E036C5557@redhat.com>
References: <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090421181519.GA4114@lazy.lzy> <1240416414.10178.1.camel@cichlid.com> <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com> <20090423055132.GA29487@maude.comedia.it> <F296B205-3CE7-4130-813D-66D63D78AE89@redhat.com> <20090423213155.GA7993@maude.comedia.it>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-79-291394551"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090423213155.GA7993@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-79-291394551
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 23, 2009, at 5:31 PM, Luca Berra wrote:
> On Thu, Apr 23, 2009 at 07:05:04AM -0400, Doug Ledford wrote:
>>>> # This file causes block devices with Linux RAID (mdadm)  
>>>> signatures to
>>>> # automatically cause mdadm to be run.
>>>> # See udev(8) for syntax
>>>>
>>>> SUBSYSTEM=="block", ACTION=="add",  
>>>> ENV{ID_FS_TYPE}=="linux_raid_member", \
>>>> 	IMPORT{program}="/sbin/mdadm --examine --export $tempnode", \
>>>> 	RUN+="/bin/bash -c '[ ! -f /dev/.in_sysinit ] && mdadm -I  
>>>> $env{DEVNAME}'"
>>>>
>>>>
>>>
>>> i believe i saw this as well, but not at startup, it was when i  
>>> manually
>>> run mdadm -As, so while your hack to prevent udev from assembling
>>> devices while in sysinit may not be a full solution.
>>
>> No, it is.  In your situation, the rules line must have read  
>> ACTION="add|change".  The fact that the incremental assembly rule  
>> would
> you are probably right about that, i tried with your ruleset and it
> looks like the problem was due to the change ACTION
> just out of curiosity what is the use of the IMPORT statement, is it
> needed by some other rule?

The IMPORT statement just causes udev to add the output of the program  
to its own list of environment variables.  Since vol_id doesn't pick  
up all the information that mdadm might care about, we use mdadm to  
supplant those environment variables.

>
>>> my solution was "rm -f /etc/udev/rules.d/70-mdadm.rules",
>>> works like a charm :P
>>>
>>> probably the best solution is preventing concurrent mdadm rules  
>>> with a
>>> lock.
>
> do you think the last suggestion of having mdadm protect from itself
> would be of use?

Not really.  The problem is that assemble and incremental use two  
different methods of bringing an array online and you can't mix the  
two.  With assemble, it will open all the devices until it gets a  
complete set, then open up a control channel to the md stack, init the  
array, add all the devices in one go, then start the array.  It was  
the scanning of the devices for superblocks that was getting picked up  
by the change event portion of the rule and causing udev to try and  
add the device to an incremental array before mdadm had collected all  
the devices and added them to its assembly based array.  Now, since  
assembly mode does everything in one go, you could conceivably lock  
against other assembly runs, but in practice that isn't a problem  
because mdadm will attempt to get an exclusive open on the constituent  
devices before starting the array.

Incremental mode is different in that it will take a single device,  
scan it for info, if it is a constituent device for an array that  
hasn't been seen yet (as per the md stack, which is true while  
assembly mode is busy scanning drives), then it will create a place  
holder array to stick the drive into, but won't attempt to start the  
array.  When assembly mode gets around to trying to start populate its  
array, the incremental array already exists (although unstarted) and  
so it picks another array.  Mdadm does not assume that you might call  
assemble on an already partially assembled incremental array.  After  
mdadm puts the device into the incremental array, it exits.  So,  
incremental wouldn't actually be able to hold a lock through the  
incremental process because each new device spawns a new mdadm, and we  
don't really know when that spawn will happen.

> I think it might still happen when stacking arrays
> i.e. mirror of stripes
> running mdadm -As would activate the first striped md and generate  
> and 'add'
> event, then while it is assembling the second one udev will trigger  
> and
> create a degraded mirror containing only the first one.

The udev rule is designed to handle exactly this type of situation.   
If you manually assemble the first array, then udev will see that and  
*start* to create the striped array on top, but because all devices  
aren't there yet, it will only put the first into the place holder  
array and not attempt to start it.  Then, when you manually create the  
second one, another add event for the second array happens, udev picks  
it up, sees that it's for the same array it's already been working on,  
and adds that device to the partially assembled array it created  
before.  Now both constituent devices are there and mdadm will go  
ahead and start the array.  So, it works like it should.  It's only a  
problem when you try to mix incremental and assembly mode operation on  
the *exact* same array.  Since udev only processes on add events now,  
in order to race with udev on manually starting a hot plugged array,  
you would likely have to be a quick typist or be trying to beat udev  
to the punch.

>
> Regards,
> L.
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





--Apple-Mail-79-291394551
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknx7O8ACgkQQ9aEs6Ims9h/1ACeJMRBduA69z++4Fb5ykbbxLI0
casAoLSCRKNKDEhIGZ1HC/QEGEufAgG/
=Q+sQ
-----END PGP SIGNATURE-----

--Apple-Mail-79-291394551--
