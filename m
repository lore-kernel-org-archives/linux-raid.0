From: William Morgan <therealbrewer@gmail.com>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Sun, 19 Jan 2020 11:07:29 -0600
Message-ID: <CALc6PW5gQDNvL4qP_QEiGkuXYR5Zp3j9_-CuBdWdyKwc-fCA9Q@mail.gmail.com>
References: <CALc6PW4OKR2KVFgzoEbRJ0TRwvqi5EZAdC__HOx+vJKMT0TXYQ@mail.gmail.com>
 <959ca414-0c97-2e8d-7715-a7cb75790fcd@youngman.org.uk> <CALc6PW7276uYYWpL7j2xsFJRy3ayZeeSJ9kNCGHvB6Ndb6m1-Q@mail.gmail.com>
 <5E17D999.5010309@youngman.org.uk> <CALc6PW5DrTkVR7rLngDcJ5i8kTpqfT1-K+ki-WjnXAYP5TXXZg@mail.gmail.com>
 <CALc6PW7hwT9VDNyA8wfMzjMoUFmrFV5z=Ve+qvR-P7CPstegvw@mail.gmail.com>
 <5E1DDCFC.1080105@youngman.org.uk> <CALc6PW5Y-SvUZ5HOWZLk2YcggepUwK0N===G=42uMR88pDfAVA@mail.gmail.com>
 <5E1FA3E6.2070303@youngman.org.uk> <CALc6PW4-yMdprmube0bKku0FJVKghYt4tjhep26sy3F9Q5cB4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALc6PW4-yMdprmube0bKku0FJVKghYt4tjhep26sy3F9Q5cB4g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here is a better formatted output from lsblk:

bill@bill-desk:~$ sudo lsblk -fi
NAME    FSTYPE            LABEL       UUID
    FSAVAIL FSUSE% MOUNTPOINT
.
.
.
sdj
`-sdj1  linux_raid_member bill-desk:0
06ad8de5-3a7a-15ad-8811-6f44fcdee150
  `-md0 ext4
ceef50e9-afdd-4903-899d-1ad05a0780e0
sdk
`-sdk1  linux_raid_member bill-desk:0
06ad8de5-3a7a-15ad-8811-6f44fcdee150
  `-md0 ext4
ceef50e9-afdd-4903-899d-1ad05a0780e0
sdl
`-sdl1  linux_raid_member bill-desk:0
06ad8de5-3a7a-15ad-8811-6f44fcdee150
  `-md0 ext4
ceef50e9-afdd-4903-899d-1ad05a0780e0
sdm
`-sdm1  linux_raid_member bill-desk:0
06ad8de5-3a7a-15ad-8811-6f44fcdee150
  `-md0 ext4                          ceef50e9-afdd-4903-899d-1ad05a0780e0
