From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 00/17] mdadm: SCSI enclosure based array
Date: Thu, 17 Dec 2015 08:35:42 +1100
Message-ID: <87h9ji9ivl.fsf@notabene.neil.brown.name>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com> <87d1u7b188.fsf@notabene.neil.brown.name> <CAPcyv4g47ZUZfCEeLRtwZkXudArRVRyFLar4RrDg1iM=kjK6iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4g47ZUZfCEeLRtwZkXudArRVRyFLar4RrDg1iM=kjK6iQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Dec 17 2015, Dan Williams wrote:

> On Tue, Dec 15, 2015 at 6:01 PM, NeilBrown <neilb@suse.com> wrote:
>> On Wed, Dec 02 2015, Song Liu wrote:
>>
>>> These patches by Dan Williams enable creating RAID array based on
>>> SCSI enclosures.
>>
>> Is there any background reading available so I can have some idea what
>> these patches are supposed to do.
>
> "Blink the light when the disk dies", is the terse summary.
>
>> I have a vague idea what an "enclosure" is but I didn't know that Linux
>> knew about them.  Is there a link to the LWN article about them or some
>> other useful documentation?  "git grep -i enclosur Documentation/"
>> didn't show anything likely to be useful.
>
> The interface these patches use is presented by the "ses" driver
> (drivers/scsi/ses.c) which leverages the sysfs interface presented by
> the "enclosure" driver (drivers/misc/enclosure.c).  I don't recall
> their being much in the way of documentation.
>
> For each disk in an enclosure the driver exposes an enclosure object
> with the following attributes:
> fault
> status
> active
> locate
> power_status
> type
> slot
>
> Where 'fault', 'active', and 'locate' select different led signal
> patterns.  The 'power_status' attribute allows power to be turned off
> to the slot.  The 'slot' attribute is meant to match the slot
> identifier that is on the board's silk screen or some physical label a
> technician can observe.

 cat > Documentation/scsi/ses.txt ???

Thanks.  That is useful background.

>
>> And what is "/dev/disk/by-slot"?? I've never come across it before
>> and google doesn't help much.  Just these patches and
>>   http://comments.gmane.org/gmane.linux.scsi/93809
>
> /dev/disk/by-slot are new proposed symlinks for udev.  The new udev
> rules for this are in patch1.

If this is proposed, then there must be a proposal - right?
Written?? (I doubt it).

So "by-path" is about the data-path that leads to the device, but
"by-slot" is about the physical location of the device (which may
correlate with the path, but is conceptually different).  I guess I can
accept that.
I don't suppose "by-location" was considered?
Can a "disk" have other locations that "slots"?
I guess 'sd' cards live in slots.
But USB sticks plug into sockets (or are sockets just slots?)
CDROMs live in trays.

Is there some convention for naming slots?
  enclosure-rank-row-column ??
Is there some convention for naming enclosures?  Bob, Jane, Ahmed?
>
> When the scsi core is probing devices and finds an enclosure target
> device it associates enclosure slot objects with the scsi_target.
> With that association we can create a symlink for the resulting disk
> based on its physical slot identifier.
>
> At the time mdadm was chosen to house these rules for convenience, but
> I think they should be submitted to upstream udev.

Yes, I would definitely like to see this "by-location" ;-) proposal
accepted by upstream udev before committing to it in mdadm.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWcdkuAAoJEDnsnt1WYoG541UP/1hjarYI1ay5qeQjNGaXJUzd
q7r99NYPBjzxFLbtOUkSSHETJdDeanYJ+DG5kssJOfFjg597eu6yRRDJvqbcgsdB
f2Y3Kj9tlhloQGnhfe7n8UNhIsLBUsqtU/EQjq84EIbiQcIICId10shXwzWCAFiG
7q+QhZfAZA/WY0biQV6oue4IpcHD5gALHbGKy91ld9se2YJPnRnhD516qxnoGo41
ZLkM4zQKtd/eTrpOeQAsvvXy1owjNzwuw1cQ55hkZdb+G+o/beoBk1Rk8Njui3Zk
CpKp+wN7nNnkmEGtXlIiineIQF1wQ94XxNfsi1hb8RZXXJDOOjLKXE2B3p/gKlBi
pK7YHv004iMMVFVWqcBDIGLuXolkGL+usxlAyYiBQ1Gm3iebsuL7Zc7/Zhn0Tukk
9xcCz7RQ9DAaZaJ7h+hCa/p+Swasr+xWoG6GoK9B5Tt95amJGdwrVjvEArDo/a2p
c9O8Wxha7PUcU/qPEE9p0UuvRk2FzNhoLAaQ0mTX/w+f/Q+gZKgzicqL49oRaaQS
Y+OjXzwSzkUgsT5IMUyI9sr+yFr8wlAxnI2z2Tn7MYgU5lvlDEyN8g8KOye6Ey1V
rbU3iKds6TvRqZA8owsOm3+ehHAKq5+uLwIAZHCi9psk1F1W9WKJM4SrMHxAvLcb
Zijn0iZTset3taTyv0GC
=peN9
-----END PGP SIGNATURE-----
--=-=-=--
