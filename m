From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Thu, 1 Oct 2009 20:46:12 -0700
Message-ID: <babafd2f0910012046i46f77e82lc1a75bbee3b1a6d8@mail.gmail.com>
References: <babafd2f0910011827l2bc62facpc5fe15ab3994b512@mail.gmail.com>
	<19141.28828.24109.570050@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19141.28828.24109.570050@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Thu, Oct 1, 2009 at 8:16 PM, Neil Brown <neilb@suse.de> wrote:
> ...

Thanks for clearing things up for me.  Very helpful.

Shame about not being able to boot from RAID-10 -- yet.  It'd make the
setup simpler, I think.

> I haven't used any of those installers in ages

Just out of curiosity, what DO you use? A different installer (I
notice you're at Suse), or a completely manual approach?


> I would probably go for 'c' as it is most flexible. =A0If, however, y=
ou
> are going to be hitting swap a lot, and cannot afford extra memory,
> 'a' might be the better option.

These are 8-24GB RAM boxes.  (c), then, should be OK.

> 1.2 isn't "newer". =A01.0, 1.1, 1.2 are similar but put the metadata =
in different places.
> I has been suggested that we call them 1.end, 1.start and 1.offset (o=
r
> something like that) and while it might be a good idea, it hasn't
> happened.

I knew that metadata location was different between them, but had
misunderstood that to be 'progress', with the newer version being
'better'.

> You almost certainly want 1.0 for /boot otherwise you probably won't =
be able to boot.

Glad you confirmed that!  I missed any docs that said "must be1.0 to bo=
ot".

> =A0I would suggest 1.1 for your RAID10.

I'm guessing that's for performance reasons, and is no more/less
'recoverable' in the case of a disaster?

>> (5) In whatever config is "best" in (3), above, is it still good
>> advice to install the bootlader into multiple MBRs? For example, if =
I
>> extend the RAID-1 over all 4-disks, then, I install the loader into
>> all four MBRs?
>
> Yes. =A0Else you might be able to boot if the first device dies.

That's what I'll do.  I've not seen any examples of RAID-1 over
4-disks.  Usually just 2.  Recovery process is the same for 4 vs 2,
right?  I figure I won't get, or notice, much performance difference
between 2- or 4- disk.  I just assume it'll be a bit more robust

> Good luck,

THanks!

Ben
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
