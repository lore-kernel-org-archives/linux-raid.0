From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 07:59:16 -0700
Message-ID: <7bc80d500910240759x443e7a00n4fdcb41f60ec9d73@mail.gmail.com>
References: <4AE276EC.5020506@tmr.com>
	 <165717.22819.qm@web38804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <165717.22819.qm@web38804.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You're the guy with the two disk raid 10, right?

That immediately makes my eyebrows furrow. If you have two disks, you
may as well make a raid 1 and keep it simple. While JFS is not exactly
new, this is foremost a list about mdadm and linux software raid, not
necessarily JFS.

Now, software raid is a funny thing. Some people love it, some people
hate it, and I don't want to be in the same room with either. I've had
great experiences with it, on raid sets of up to 56 disks at a time,
and generally think it's great. However, like everything else, YOU CAN
shoot yourself in the foot. Because it's a layered system, the kernel
won't get in your way if you decide to, say, dd the underlying block
devices and obliterate the superblock, or what have you.

Part of this sounds like you're looking for best practices. I imagine
that's why you made a raid 10, and why you're using JFS. It's probably
why you've been fiddling around with blockdev --setra and all that
too, maybe some elevator tweaks too. Not to get pedantic, but all
these techniques and technologies were designed around specific
workloads and hardware types. RAID 10 doesn't really win until you
have 4 spindles and higher. I have no doubt that JFS is a great file
system, but most people on here use ext3/4 and are happy with that
too--and probably have more demanding workloads than you.

The issue is, you're shooting in the dark unless you really understand
what you want to do and why. You also said HTPC. Is this basically a
large bucket for videos and other media? Some might say that's not as
important to keep online as, say, your email or personal documents.
It's your call. You also have to consider what kind of performance you
need--you probably won't see a performance increase here because you
only have two disks, and for redundancy every write will take place on
two disks, and at best, every read will be interleaved.

I'm going to go on a limb here and say for anyone (with data they want
to preserve), no matter what, backups make sense and are cost
effective. I'm going to be crazy and say that there's no reason that
someone who thinks they can afford a 8TB disk array and dual SLI video
cards, etc, etc, can't also consider some sort of disk or tape backup.
Cumbersome? Can be. But having worked with datasets and filesystems
that run into the hundreds of terabytes, and having backed them up to
tape, it makes sense. If you have something on the order of tens of
disks, sure, go ahead, take that next step and back them up somewhere
else to another set of disks. If you have more disks, seriously
consider tape--in terms of capacity and power consumption (and data
integrity), tape wins.

This is, of course, only really valid if you've got data worth preservi=
ng.

And don't even get me started on "silent corruption" and bit rate
errors on 2TB drives. But, heh, at least you didn't ask about raid 5
or 6. :)

This stuff, when starting out, rewards experimentation, and failures
(especially at home--this HTPC is at home, right?) are often great
sources for learning. So, good luck!

Cheers

cc

On Sat, Oct 24, 2009 at 5:01 AM, adfas asd <chimera_god@yahoo.com> wrot=
e:
> Actually it it your solution which seems best at this point. =A0But I=
've been testing to see whether anyone else advocates it or another alt=
ernative.
>
> The division is stark; =A0some have been nothing but helpful, while o=
thers have done nothing but complain. =A0You are the only one right bet=
ween.
>
>
> --- On Fri, 10/23/09, Bill Davidsen <davidsen@tmr.com> wrote:
>> I told him where and how to back up his data for about
>> 8-10% of the price he said it would cost. I explained (as
>> several other have) why no raid level is the same as a
>> backup.
>>
>> Sorry if that wasn't the thing you wanted to learn, but
>> after it has been explained multiple time, it doesn't seem
>> to have been sinking in. And clearly didn't this time. I
>> won't waste my time trying to educate people here any more.
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Chris Chen <muffaleta@gmail.com>
"The fact that yours is better than anyone else's
is not a guarantee that it's any good."
-- Seen on a wall
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
