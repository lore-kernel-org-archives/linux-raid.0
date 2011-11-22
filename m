From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Question about mdadm commit d6508f0cfb60edf07b36f1532eae4d9cddf7178b
 "be more careful about add attempts"
Date: Tue, 22 Nov 2011 10:45:22 +0200
Message-ID: <CAGRgLy4QYRgNVii+UJi_1o_MxmRDi2kZUBcZGwSAj9b6t9Qjfg@mail.gmail.com>
References: <CAGRgLy6Q9Qq8TeykEseXX45goi4kS8wOwrUOo1+tNZyxdyFHkw@mail.gmail.com>
	<20111027085125.747691a9@notabene.brown>
	<CAGRgLy7biNy4Tj9wXhBosjC4QNy7dXC2aoimu7ezGqdL82Axxg@mail.gmail.com>
	<20111031101649.657a1ab3@notabene.brown>
	<CAGRgLy7G_M=FtdZ9mmDvxxN52+AF+L=0+OaEP=dK7Z+Z5YBYKw@mail.gmail.com>
	<20111031201933.314d130f@notabene.brown>
	<CAGRgLy5zkfy2bfrJnC_eKQ_-VAcdaKCyeSounjZ3FjBb83T0mQ@mail.gmail.com>
	<20111102095204.024dc6b2@notabene.brown>
	<CAGRgLy5WaOAg2R0FW1=cPgn+sK+PA_=T=GrLj+KWb5HVxbndzQ@mail.gmail.com>
	<20111109104128.7b6f098f@notabene.brown>
	<CAGRgLy49X7KUMdY8hj-99Z46vfzvSnB6LhNZpsN5XedjTdBu1Q@mail.gmail.com>
	<20111121134429.7a6f46cc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111121134429.7a6f46cc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil, for looking into this.

On Mon, Nov 21, 2011 at 4:44 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 17 Nov 2011 13:13:20 +0200 Alexander Lyakas <alex.bolshoy@gma=
il.com>
> wrote:
>
>> Hello Neil,
>>
>> >> However, at least for 1.2 arrays, I believe this is too restricti=
ve,
>> >> don't you think? If the raid slot (not desc_nr) of the device bei=
ng
>> >> re-added is *not occupied* yet, can't we just select a free desc_=
nr
>> >> for the new disk on that path?
>> >> Or perhaps, mdadm on the re-add path can select a free desc_nr
>> >> (disc.number) for it (just as it does for --add), after ensuring =
that
>> >> the slot is not occupied yet? Where it is better to do it?
>> >> Otherwise, the re-add fails, while it can perfectly succeed (only=
 pick
>> >> a different desc_nr).
>> >
>> > I think I see what you are saying.
>> > However my question is: is this really an issue.
>> > Is there a credible sequence of events that results in the current=
 code makes
>> > an undesirable decision? =A0Of course I do not count deliberately =
editing the
>> > metadata as part of a credible sequence of events.
>>
>> Consider this scenario, in which the code refuses to re-add a drive:
>>
>> Step 1:
>> - I created a raid1 array with 3 drives: A,B,C (and their desc_nr=3D=
0,1,2)
>> - I failed drives B and C, and removed them from the array, and
>> totally forgot about them for the rest of the scenario.
>> - I added to the array two new drives: D and E, and waited for the
>> resync to complete. The array now has the following structure:
>> A: descr_nr=3D0
>> D: desc_nr=3D3 (was selected during the "add" path in mdadm, as expe=
cted)
>> E: desc_nr=3D4 (was selected during the "add" path in mdadm, as expe=
cted)
>>
>> Step 2:
>> - I failed drives D and E, and removed them from the array. The E
>> drive is not used for the rest of the scenario, so we can forget abo=
ut
>> it.
>>
>> I wrote some data to the array. At this point, the array bitmap is
>> dirty, and will not be cleared, since the array is degraded.
>>
>> Step 3:
>> - I added one new drive (last one, I promise!) to the array - drive =
=46,
>> and waited for it to resync. The array now has the following
>> structure:
>> A: descr_nr=3D0
>> F: desc_nr=3D3
>>
>> So F took desc_nr of D drive (desc_nr=3D3). This is expected accordi=
ng
>> to mdadm code.
>>
>> Event counters at this point:
>> A and F: events=3D149, events_cleared=3D0
>> D: events=3D109
>>
>> Step 4:
>> At this point, mdadm refuses to re-add the drive D to the array,
>> because its desc_nr is already taken (I verified that via gdb). On t=
he
>> other hand, if we would have simply picked a fresh desc_nr for D, th=
en
>> it could be re-added I believe, because:
>> - slots are not important for raid1 (D's slot was taken actually by =
=46).
>> - it should pass the check for bitmap-based resync (events in D' sb =
>=3D
>> events_cleared of the array)
>>
>> Do you agree with this, or perhaps I missed something?
>>
>> Additional notes:
>> - of course, such scenario is relevant only for arrays with more tha=
n
>> single redundancy, so it's not relevant for raid5
>> - to simulate such scenario for raid6, need at step 3 to add the new
>> drive to the slot, which is not the slot of the drive we're going to
>> re-add in step4 (otherwise, it takes the D's slot, and then we reall=
y
>> cannot re-add). This can be done as we discussed earlier.
>>
>> What do you think?
>
> I think some of the details in your steps aren't really right, but I =
do see
> the point you are making.
> If you keep the array degraded, the events_cleared will not be update=
d so any
> old array member can safely be re-added.
>
> I'll have a look and see how best to fix the code.
>
> Thanks.
>
> NeilBrown
>
>
>
>>
>> Thanks,
>> Alex.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
