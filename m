From: "NeilBrown" <neilb@suse.de>
Subject: Re: weird issues with raid1
Date: Tue, 23 Dec 2008 08:07:31 +1100 (EST)
Message-ID: <8a3fbc034da936df0f430739bacbf28b.squirrel@neil.brown.name>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
    <cccedfc60812172050h58697665y975a18550842aebb@mail.gmail.com>
    <cccedfc60812172055n58181ad4lcdff8f172c6a496c@mail.gmail.com>
    <18761.56537.935250.561921@notabene.brown>
    <cccedfc60812172147q240466a8w53c5bd2540edf6a4@mail.gmail.com>
    <18761.60380.938542.26851@notabene.brown>
    <cccedfc60812181815oa63b526tb51c3bee558fbdf@mail.gmail.com>
    <cccedfc60812190851x446a6046p2578b8de72edc93b@mail.gmail.com>
    <cccedfc60812191240m185d5f49td1ec2070c70c88e4@mail.gmail.com>
    <cccedfc60812191318w18de5dfbs28bf476bd5d88359@mail.gmail.com>
    <cccedfc60812220640m53f668q56fcf765286bedd4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60812220640m53f668q56fcf765286bedd4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, December 23, 2008 1:40 am, Jon Nelson wrote:
> More updates:
>
> 1. I upgraded to openSUSE 11.1 over the weekend. The kernel is
> 2.6.27.7-9 as of this writing.
>
> 2. When I fired up the machine which hosts the network block device,
> the machine hosting the raid properly noticed and --re-added /dev/nbd0
> to /dev/md11.
>
> 3. /dev/md11 went into "recover" mode (not resync).
>
> 4. I'm using persistent metadata and a write-intent bitmap.
>

It does seem like you are doing the right thing....

Can you show me the output of both --examine and ----examine-bitmap
on both /dev/sda and /dev/nbd0 just before you --re-add nbd0 to
the array that already contains sda ??
For recovery to use the bitmap, "Events Cleared" on sda must be no
more than "Events" (from --examine) of nbd0.

What you sent doesn't quite have all this information, but it does
show that for nbd0 before it is added to the array:

--examine;
         Events : 7042

--examine-bitmap:
          Events : 5518
  Events Cleared : 5494

This shouldn't happen.  The 'events' from --examine and from
--examine-bitmap should always be the same.  That is how md knows
that the bitmap is still accurate.
This seems to suggest that nbd0 was, for a while, assembled into an
array which did not have an active bitmap.

Thanks,
NeilBrown


