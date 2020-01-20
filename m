From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Mon, 20 Jan 2020 08:49:44 +0000
Message-ID: <20200120084944.GA8538@cthulhu.home.robinhill.me.uk>
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
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALc6PW4-yMdprmube0bKku0FJVKghYt4tjhep26sy3F9Q5cB4g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Morgan <therealbrewer@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun Jan 19, 2020 at 11:02:54AM -0600, William Morgan wrote:

> bill@bill-desk:~$ sudo lsblk -f
> NAME    FSTYPE            LABEL       UUID
>     FSAVAIL FSUSE% MOUNTPOINT
> .
> .
> .
> sdj
> └─sdj1  linux_raid_member bill-desk:0
> 06ad8de5-3a7a-15ad-8811-6f44fcdee150
>   └─md0 ext4
> ceef50e9-afdd-4903-899d-1ad05a0780e0
> sdk
> └─sdk1  linux_raid_member bill-desk:0
> 06ad8de5-3a7a-15ad-8811-6f44fcdee150
>   └─md0 ext4
> ceef50e9-afdd-4903-899d-1ad05a0780e0
> sdl
> └─sdl1  linux_raid_member bill-desk:0
> 06ad8de5-3a7a-15ad-8811-6f44fcdee150
>   └─md0 ext4
> ceef50e9-afdd-4903-899d-1ad05a0780e0
> sdm
> └─sdm1  linux_raid_member bill-desk:0
> 06ad8de5-3a7a-15ad-8811-6f44fcdee150
>   └─md0 ext4                          ceef50e9-afdd-4903-899d-1ad05a0780e0
> 
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
> 
> bill@bill-desk:~$ sudo mount -all
> mount: /media/bill/STUFF: mount(2) system call failed: Structure needs cleaning.
> 
> But I don't know how to clean it if fsck says it's OK.
> 
> On the other hand, if I use the UUID above starting with "ceef", then
> it mounts and everything seems OK.
> 
> Basically, I don't understand why lsblk lists two UUIDs for the array,
> and why mdadm gives the wrong one in terms of mounting. This is where
> I was confused before about the UUID changing. Any insight here?
> 

One is the UUID for the array (starting with "06ad") - this is what you
use in /etc/mdadm.conf. The second is the UUID for the filesystem you
have on the array (starting with "ceef") - that's used in /etc/fstab. If
you recreate the filesystem then you'll get a different filesystem UUID
but keep the same array UUID.

Cheers,
    Robin
-- 
     ___        
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |
