From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Sun, 19 Jan 2020 17:41:07 +0000
Message-ID: <5E2494B3.9010006@youngman.org.uk>
References: <CALc6PW4OKR2KVFgzoEbRJ0TRwvqi5EZAdC__HOx+vJKMT0TXYQ@mail.gmail.com>
 <959ca414-0c97-2e8d-7715-a7cb75790fcd@youngman.org.uk>
 <CALc6PW7276uYYWpL7j2xsFJRy3ayZeeSJ9kNCGHvB6Ndb6m1-Q@mail.gmail.com>
 <5E17D999.5010309@youngman.org.uk>
 <CALc6PW5DrTkVR7rLngDcJ5i8kTpqfT1-K+ki-WjnXAYP5TXXZg@mail.gmail.com>
 <CALc6PW7hwT9VDNyA8wfMzjMoUFmrFV5z=Ve+qvR-P7CPstegvw@mail.gmail.com>
 <5E1DDCFC.1080105@youngman.org.uk>
 <CALc6PW5Y-SvUZ5HOWZLk2YcggepUwK0N===G=42uMR88pDfAVA@mail.gmail.com>
 <5E1FA3E6.2070303@youngman.org.uk>
 <CALc6PW4-yMdprmube0bKku0FJVKghYt4tjhep26sy3F9Q5cB4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALc6PW4-yMdprmube0bKku0FJVKghYt4tjhep26sy3F9Q5cB4g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Morgan <therealbrewer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/01/20 17:02, William Morgan wrote:
> But then I get confused about the UUIDs. I'm trying to automount the
> array using fstab (no unusual settings in there, just defaults), but
> I'm not sure which of the two UUIDs above to use. So I look at mdadm
> for help:
> 
> bill@bill-desk:~$ sudo mdadm --examine --scan
> ARRAY /dev/md/0  metadata=1.2 UUID=06ad8de5:3a7a15ad:88116f44:fcdee150
> name=bill-desk:0
> 
> However, if I use this UUID starting with "06ad", then I get an error:

Looking at your output (and no I'm not that good at reading traces) it
looks to me like this 06ad8de5 uuid should be that of ONE of your
partitions. But it looks like it's been cloned to ALL partitions.

You didn't do anything daft like partitioning one disk, and then just
dd'ing or cp'ing the partition table across? Never a good idea.
> 
> bill@bill-desk:~$ sudo mount -all
> mount: /media/bill/STUFF: mount(2) system call failed: Structure needs cleaning.
> 
> But I don't know how to clean it if fsck says it's OK.
> 
> On the other hand, if I use the UUID above starting with "ceef", then
> it mounts and everything seems OK.

Yup. That looks like the correct UUID for the array.
> 
> Basically, I don't understand why lsblk lists two UUIDs for the array,
> and why mdadm gives the wrong one in terms of mounting. This is where
> I was confused before about the UUID changing. Any insight here?
> 
Well it LOOKS to me like something has changed all the partition UUIDs
to the array UUID, and then the array UUID has changed to avoid a
collision.

I dunno - let's hope someone else has some ideas ...

Cheers,
Wol
