From: Eric Rumer <eric.rumer@level3.com>
Subject: Re: RAID recovery question
Date: Wed, 27 Aug 2003 10:50:48 -0600 (MDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50.0308271042340.8892-100000@scrappy.it.l3.com>
References: <Pine.LNX.4.50.0308262115130.6333-100000@scrappy.it.l3.com>
 <bWpzdHVtcGY=.ad924856996f27b71d0056adbf646113@1061990055.cotse.net>
Reply-To: Eric Rumer <eric.rumer@level3.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bWpzdHVtcGY=.ad924856996f27b71d0056adbf646113@1061990055.cotse.net>
To: mjstumpf@pobox.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yep.  I got mdadm after I had sent this.  It's still a bit flaked out (I'm
having a lot of trouble getting the filesystem back), but the devices are
online.

BTW - The event counter on the failed device was 0000000c, and I did not
re-attach it.  The file-system should have been stable (few writes)

-- Eric

On Wed, 27 Aug 2003, mjstumpf wrote:

>
> > /dev/md3 = RAID5, /dev/sde1 + /dev/sdf1 + /dev/sdg1 + /dev/sdh1
> > /dev/md4 = RAID5, /dev/sdi1 + /dev/sdj1 + /dev/sdk1 + /dev/sdl1
> > /dev/md5 = RAID0, /dev/md3 + /dev/md4
>
> > When I try to run raidstart /dev/md3 I get -
> >
> > Aug 26 20:37:15 davis kernel:  [events: 0000000f]
> > Aug 26 20:37:15 davis kernel:  [events: 0000000f]
> > Aug 26 20:37:15 davis kernel:  [events: 0000000d]
>
> I am most definitely NOT the expert, however I would recommend getting
> "mdadm" (search this list for the tool) and using it exclusively from now
> on.  The FAQ/howto is badly out of date.
>
> It would be interesting to see the event counter on the failed device.
>
> With mdadm you can reassemble the array and start it even though the event
> counters disagree.  I had to do this recently when a failed drive caused a
> partial boot, and my array (on attempting to boot) was incrementing the
> first of the drives' event counters.  I knew nothing had changed, so it
> was very safe to force.
>
> This might be a similar situation.  I'd guess the worst thing you would
> face is a few corrupted files.
>
>
>
>
