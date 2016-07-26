From: pg@lxra2.for.sabi.co.uk (Peter Grandi)
Subject: Re: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Tue, 26 Jul 2016 19:33:35 +0100
Message-ID: <22423.44287.974770.114127@tree.ty.sabi.co.uk>
References: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]
> migrate all my data from a raid 5 of 4x2TB (actually 3 because
> i'm degraded right now) to a raid 6 of 4x4TB so exactly i got :
> - raid 5, should be 4 disk of 2T but got problem and so right
>   now it's just 2x2T and a 2Tb disk image in a 4T disk (the
>   raid crashed and is not start right now but is clean)
> - 2 disk of 4TB
> - the raid 5 use lvm2 on top of mdadm
> I want a raid 6 [ ... ]

In general an in-place migration is a very dangerous operation
because it stresses existing hardware a lot plus it uses code
that is rarely used and is quite complex. Given that your
situation is already compromised.

Plus your goal does not make a lot of sense: from a RAID5 of 4
drives to a RAID6 of 4 drives. Very strange.

Also I note that you currently don't have 4 drives of 4TB, but
3, so there you get your wish 2 drives of 2TB as the fourth
member as in =AB2 2TB as a raid 0=BB

The good thing about your plan is to use the larger drives to
make a *copy* of your data, so you don't quite do an in-place
migration.

So, the questions really are how much data you have on your
existing 4x (degraded) 2TB RAID5, which will be at most 6TB, and
how many drives you can connect *at the same time*. You seem
sure to be able to connect all 5 drives: the 3x 4TB and the 2x
2TB. I really hope none of them is USB.

So in total you have 2x 2TB drives and 3x 4TB drives, of which
currently the 2TB drive are full and 1x 4TB drive is half full,
thus you have 6TB of data without redundancy and 10TB of free
space. In a very ideal world you would get an extra 4TB disk,
but you seem unable to do so...

Also, given that you are are seriously considering all of this,
I must assume that you are a very experienced RAID and storage
guru knowing all the little details that matter to success, and
to recovery in case of problems arising.

Let's call A and B the 2x 2TB disks, C the 4TB disk with the 2TB
disk image, and D and E the empty 4TB disks.

The least scary option might be:

* Split into two partitions D and E.
* Block copy the image on C to D1 and E2.
* Re-partition C also in two.
* Block copy B to C1.
* Block copy A to E2.
* Now we have greatly increased redundancy, as we have the 3x
  2TB data slices on two separate sets, A, C1, D1 and D2, B,
  E2.
* Add E1 as a spare to the A, C1, D1 RAID5 set, and start it so
  you end up with a full RAID5 set on A, C1, D1, E1 after
  resync end.
* Now that the first RAID5 set is not degraded, you can erase
  the copies on D2, B, E2, and create a second RAID5 set on
  B, C2, D2, E2, which will be empty.

A slight improvement to your scheme:

* Add a second 2TB disk image to C.
* Add the second 2TB disk image to the existing RAID5 and wait
  until resync to end, creating a full RAID5 set; having two
  members on the same disk is far from ideal, but better than
  nothing, and temporary.
* Make D and E as a degraded RAID6 or RAID10.
* Copy the data to the newly created RAID6 or RAID10.
* Reset A, B, C.
* Make A and B into a RAID0.
* Add A+B and C to the RAID6/RAID10 as spares and wait for the
  resync to end.

A scheme that relies on in-place conversion from RAID5 to RAID6:

* Copy the image on C to E.
* Copy B to D.
* Copy A to C.
* Create an empty RAID0 of A+B.
* Add A+B as spare to to C, D, E, and wait for the resync to
  end, creating a full RAID5.
* In-place expand the RAID5 to 4TB members, that should take
  no time.
* In-place convert the RAID5 to RAID6.

But all these seem to me at the limit of plausibility.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
