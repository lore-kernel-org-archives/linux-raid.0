From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Spares and partitioning huge disks
Date: Fri, 14 Jan 2005 00:32:46 +0100
Message-ID: <u1djb2-d2j.ln1@news.it.uc3m.es>
References: <u0nib2-4i2.ln1@news.it.uc3m.es> <200501132038.j0DKcB905895@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy <bugzilla@watkins-home.com> wrote:
> Maybe you missed my post from yesterday.

Possibly I did - I certainly don't read everything and not everything
gets to me. Or maye I saw it and could not decipher it. I don't know!

> http://marc.theaimsgroup.com/?l=3Dlinux-raid&m=3D110559211400459&w=3D=
2

> No superblock was to prevent overwriting data on the failing componen=
t of

You say that no superblock in one of the raid1 subarray's disks stops
overwriting data on a top raid5 array?  This really sounds like double
dutch!  And if it does (What?  How?  Why?), so what?

> the top RAID5 array.  If you build the top array with degraded RAID1 =
arrays,
> then use a super block for the RAID1 arrays.

There possibly a missing verb in that sentence.  Or maybe not.  It is
hard to tell. Hmmmmmmmm .......... nope, I really can't see where that
sentence is trying to go.

Let's suppose it really does have the form of a computer language IF
THEN, so the conditional test would be "you build the top array with
degraded RAID1 arrays".

Well, I can interpret that to say that I build the top array (which is
RAID5) OF degraded RAID1 arrays, and then that would match what I
suggested.

OK.  So that would mean "IF you do what you suggest THEN ...".  Then
what?  Then "an imperative".  An imperative?  Why should I obey an
imperative?  Well, what does this imperative say anyway?=20

It says "use a super block for the RAID1 arrays".

OK, that could be "use RAID1 arrays with superblocks".  That is "do the
normal thing with RAID1".  So the whole sentence says "IF you do what
you suggest THEN do the normal thing with RAID1".  OK - I agree.  You
are trying to say "IF I do things my way THEN I don't have to do
anything strange at the RAID1 level".

OK?

Whew! I can see why I skipped whatever you said before if that is what
it takes to decipher it!

Bt then the entire sentence says nothing strange or exciting.

> Also, so all of the RAID1 arrays don't seem degraded, configure them =
with
> only 1 device.=20

Whaaaaaaat? Oh no, I give up - I really can't parse this.=20

Hang on - maybe the tenses are wrong.  Maybe you are trying to say "you
don't have to configure the RAID1 arrays as having 1 good disk and 1
failed disk".

Well, I disagree. Correct me if I am wrong but as far as I know you
cannot change the number of disks in a raid array. I'd be happy to
learn you can, but for all I know if you start with n disks comprised
of m good and p failed disks, then n =3D m + p and the total can never
change. In my 2.6.3 codebase for raid there is only one point where=20
conf->raid_disks is changed, and it is in the "run" routine, where=20
it is set once and for all and never changed.


> Grow them to 2 devices when needed.  Then shrink them back
> to 1 when done.

If it were possible I'd be happy to hear of it. Maybe it is possible -
but it would be in a newer codebase than the 2.6.3 code I have running
here.

If so, why this convoluted way of saying that?

> The RAID1 idea will not work since a bad block will take out the RAID=
1.  But

Uh - yes it will work, no a bad block will not "take out the RAID1",
whatever you mean by that.=20

I presume you mean that a bad block in the disk being read will mess up
the raid1 subarray. No it won't - it will just prevent a block being
copied. I see nothing terrible in that. The result will be that
everything else but that block will be copied. If you like we can even
arrange that the missing block be corrected THEN at that moment from
data available in the superarray, but I don't see that as necessary.

Why?

Well,=20

1) because now that you have told me that the disk you want to swap out
is bad, then the top level array has morally lost its redundancy
already!  So just take the disk out and replace it - you won't be
degrading the top array any more than it already is while you do this.

2) oh - but you say that yes we are losing redundancy on the good
sectors of the disk. Oh? And which are those? Well let's just go ahead
with the RAID1 sync and whenever we hit an unreadable sector then
launch a request to the top level array for a read from the rest of the
RAID5 for that sector only.

3) oh, but you don't like to do that during resync? Shrug .. then mar
the place on a bitmap and after the resync has finished as best you are
able then launch an extra cleanup phase from the RAID5  to cover the
blocks marked bad in the bitmap (one can do this periodically anyway).

I don't see that one really needs to do 3 in place of 2, but I am
experimenting.

Anyway, the point is that =FFour "it will not work" is wrong.

> there are more issues, see the above URL.

Does it contain more of the same?

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
