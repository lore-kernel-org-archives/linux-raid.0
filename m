From: Neil Brown <neilb@suse.de>
Subject: Re: RAID1 write-behind not working?
Date: Fri, 27 Mar 2009 15:25:55 +1100
Message-ID: <18892.21843.355089.953191@notabene.brown>
References: <72dbd3150903251739q21de8a2ew835860f9e3b11d14@mail.gmail.com>
	<49CB7CB2.1020105@tmr.com>
	<72dbd3150903261028idacb20esc9e56854379d76bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Rees on Thursday March 26
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 26, drees76@gmail.com wrote:
> (re-adding linux-raid to Cc)
>=20
> On Thu, Mar 26, 2009 at 6:01 AM, Bill Davidsen <davidsen@tmr.com> wro=
te:
> > David Rees wrote:
> >> My only guess is that by specifying fdatasync on the dd command, t=
hat
> >> forces the data to be written out to all members of the array. =A0=
Not
> >> quite intuitive if that is by design - because otherwise, when are=
 you
> >> able to take advantage of the write-behind feature.

That is not the design.  md/raid doesn't know anything about
fdatasync.

When a write request arrives at a raid1 with write-behind, a copy is
made of the data, and that copy is written to the "write-mostly"
devices while the original is written to the other devices (or
something like that.  When the writes to the non-write-mostly devices
complete, the filesystem is told that the write is complete.

The write-behind devices can only cause a delay if:

 - the number of outstanding write exceeds the maximum given
   with --write-behind=3D to mdadm
 - memory gets tight and we fail to malloc space to make a copy of
   the data.

So if your write-behind device has high latency, that should be
masked.  If however it has low throughput, that cannot be masked.  The
throughput of the raid1 will always be limited by the throughput of
the slowest component device.

>=20
> In this case, all I really care is that the data has been written to
> the non-write-mostly disks and that the write-mostly disks can lag by
> the number of IOs I've specified.

That is exactly how it is designed to work (providing malloc doesn't
fail).

If you have numerical evidence that it is behaving otherwise, I'd be
keen to see it.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
