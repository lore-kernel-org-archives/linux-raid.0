From: Raz <raziebe@gmail.com>
Subject: Re: Subject: [PATCH] mdadm: raid0: support chunks of 4K*n for raid0
Date: Fri, 15 May 2009 17:45:25 +0200
Message-ID: <5d96567b0905150845i32cbc772sc6cb0227c9aa0d80@mail.gmail.com>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	 <1242297833-13908-2-git-send-email-maan@systemlinux.org>
	 <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
	 <20090514121042.GH11504@skl-net.de>
	 <4743925b38e2d64317e0b6d7c8005a29.squirrel@neil.brown.name>
	 <1242321131.11444.23.camel@raz>
	 <921ca19c0905142059u3c16ca2bk6d830d1f74c58ee3@mail.gmail.com>
	 <5d96567b0905142301v144f428dsb110d9e81e3ad592@mail.gmail.com>
	 <921ca19c0905142345u36729c38t9ca1e39824703728@mail.gmail.com>
	 <e0376270c41e5a8a15f06849aaae8863.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e0376270c41e5a8a15f06849aaae8863.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, sjt.kar@gmail.com
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Well, first, anyone that  somehow in someway got confused or insulted
please accept my applogies.
This all thing is just a big missunderstanding, and from my part.
please see inline.
I hope we are ok now Sujit.

On 5/15/09, NeilBrown <neilb@suse.de> wrote:
> On Fri, May 15, 2009 4:45 pm, Sujit Karataparambil wrote:
> > On Fri, May 15, 2009 at 11:31 AM, Raz <raziebe@gmail.com> wrote:
> >> where else ?
> >
> > See you were the one who has sent out the patch. Ok? Then you should
> > know the reason for patch? What I had asked from Neil is an RFC Cross
> > Checking the Patch. So I donot expect an Reply From You. Ok?
> >>> taking care of 4k*n data sets.
> >>> What I see of this patch is that it specifically checks for some sort
> >>> of 4K Boundaries.
> >
> >
> >> instead of 4K*2^n where n>=0
> >> correct and recompure IO posistion.
> >>>>                                fprintf(stderr, Name ": invalid
> >>>> chunk/rounding value: %s\n",
> >
> > Could you tell me how 4K*2^n is  used to do the patch what ever it was
> > sent for? Or
> > is it that the patch is incomplete.
> >
> > Kindly Maintain Some sort of mailing list courtesy.Ok? Reply only when
> > you are asked to.
> > Ok?
>
> That really isn't an appropriate thing to say.  If people want to
> reply (politely) this questions directed at other people on a public
> list, I think that is quite appropriate.  In fact I value it as it
> often means I don't need to reply because someone else has done
> it for me.
>
> Now I agree that "where else" is not a very helpful reply, but I'm
ok. sorry about that. i just do not understand what the problem.
> not sure that the original question was crystal clear either.  Maybe
> there is a bit of a language barrier - I'm sure not everyone on this
> list has English as their first language, yet English is the language
> we use (for which I'm very thankful as I don't speak anything else).
> So a little bit of patience all around would be good.
>
> Also it would help if explanations were a little more detailed, and
> even if questions contained more detail too.
>
> In the case of the original patch, I'm not really sure of the point
> of the patch myself.
>
> The text
>  "I do not know what is policy for mdadm patches. I would thankful for some
> instructions."
>
> is clear enough.  The answer is "send them to me" in much the same format
> as the kernel patches you have seen sent by e.g. Andre Noll.
> The text
>   "The bellow is the patch I applied to support raid0 chunk sizes 4K*n."
>
> confuses me as it doesn't seem add anything, it only removes.
> i.e. it removes the possibility of passing a non-power-of-2
> chunk size to raid levels other than 0.
lol.... patch is my mistake. patch wat not against your original code .
Original mdadm.c code is:
if (!optarg[0] || *c || chunk<4 || ((chunk-1)&chunk))  ...

All I want is to enable the chunk fix only to raid0. This is all my
mistake because i am not working under your mdadm git repository but
under a private svn repository. Would you be so kind to direct me to
your git's url ( there are several mdadm gits i found in google ), I
will repost this fix.

Thank you.
raz
> That might be an appropriate thing to do, but the commentary that
> came with the patch doesn't say it does that, and says something
> quite different, so I'm not really sure what to make of it.  Which
> is one of the reasons I didn't reply straight away - I wanted to give
> myself time to read it again and make sure I wasn't missing anything.
>
>
> NeilBrown
>
> >
> > --
> > -- Sujit K M
> >
>
>
