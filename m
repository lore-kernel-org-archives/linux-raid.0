From: William Morgan <therealbrewer@gmail.com>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Sun, 19 Jan 2020 14:12:38 -0600
Message-ID: <CALc6PW6r8jn7nJcq-ceTboRkP5TYj0863bo856SS3TAus0mTSA@mail.gmail.com>
References: <CALc6PW4OKR2KVFgzoEbRJ0TRwvqi5EZAdC__HOx+vJKMT0TXYQ@mail.gmail.com>
 <959ca414-0c97-2e8d-7715-a7cb75790fcd@youngman.org.uk> <CALc6PW7276uYYWpL7j2xsFJRy3ayZeeSJ9kNCGHvB6Ndb6m1-Q@mail.gmail.com>
 <5E17D999.5010309@youngman.org.uk> <CALc6PW5DrTkVR7rLngDcJ5i8kTpqfT1-K+ki-WjnXAYP5TXXZg@mail.gmail.com>
 <CALc6PW7hwT9VDNyA8wfMzjMoUFmrFV5z=Ve+qvR-P7CPstegvw@mail.gmail.com>
 <5E1DDCFC.1080105@youngman.org.uk> <CALc6PW5Y-SvUZ5HOWZLk2YcggepUwK0N===G=42uMR88pDfAVA@mail.gmail.com>
 <5E1FA3E6.2070303@youngman.org.uk> <CALc6PW4-yMdprmube0bKku0FJVKghYt4tjhep26sy3F9Q5cB4g@mail.gmail.com>
 <5E2494B3.9010006@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E2494B3.9010006@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> You didn't do anything daft like partitioning one disk, and then just
> dd'ing or cp'ing the partition table across? Never a good idea.

No, I didn't. Here are the partition UUIDs for disks j,k,l,m:

bill@bill-desk:~$ for i in {j,k,l,m} ; do udevadm info --query=all
--name=/dev/sd"$i" | grep -i UUID ; done
E: ID_PART_TABLE_UUID=bbccfe6f-739d-42de-9b84-99ca821f3291
E: ID_PART_TABLE_UUID=f42fd04d-96e3-4b0c-b20c-5286898b104f
E: ID_PART_TABLE_UUID=f467adc9-dba4-4ee9-95cc-f1a93e4a7d98
E: ID_PART_TABLE_UUID=4805ef03-5bd1-46d1-a0e1-5dde52b096ec

> Well it LOOKS to me like something has changed all the partition UUIDs
> to the array UUID, and then the array UUID has changed to avoid a
> collision.
>
> I dunno - let's hope someone else has some ideas ...

Well, here is some further info that shows 2 UUIDs for the single array md0:

bill@bill-desk:~$ udevadm info --query=all --name=/dev/md0 | grep -i UUID
S: disk/by-uuid/ceef50e9-afdd-4903-899d-1ad05a0780e0
S: disk/by-id/md-uuid-06ad8de5:3a7a15ad:88116f44:fcdee150
E: MD_UUID=06ad8de5:3a7a15ad:88116f44:fcdee150
E: ID_FS_UUID=ceef50e9-afdd-4903-899d-1ad05a0780e0
E: ID_FS_UUID_ENC=ceef50e9-afdd-4903-899d-1ad05a0780e0
E: UDISKS_MD_UUID=06ad8de5:3a7a15ad:88116f44:fcdee150
E: DEVLINKS=/dev/md/0 /dev/disk/by-id/md-name-bill-desk:0
/dev/disk/by-uuid/ceef50e9-afdd-4903-899d-1ad05a0780e0
/dev/disk/by-id/md-uuid-06ad8de5:3a7a15ad:88116f44:fcdee150

Still not sure why /dev/disk/by-id/ and /dev/disk/by-uuid/ would have
differing UUIDs, but maybe that's normal.

Maybe someone can shed some light here?

Cheers,
Bill
