From: Jesse Wheeler <jwwstpete@gmail.com>
Subject: Re: system update killed /boot RAID-1 array auto-assembly/mount. why?
Date: Mon, 2 Nov 2009 18:36:10 -0500
Message-ID: <f1ef83020911021536p725c33c2raa995b71d130270c@mail.gmail.com>
References: <babafd2f0911021224w6adf8453we7ba4f166102044f@mail.gmail.com>
	 <f1ef83020911021325uf1be098ia4567931771f88ae@mail.gmail.com>
	 <babafd2f0911021433j340add0bu5dae2c388efadfd6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <babafd2f0911021433j340add0bu5dae2c388efadfd6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben DJ <bendj095124367913213465@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ben:

> I can't say I've made any of those comparisons.  Given a choice, I'm
> sticking with openSUSE ...

Totally understandable :o).

> That might be simply because I'm a bit paranoid now what with the
> recent FAIL.

That would make anyone nervous.  As someone who has lost quite a
bit-o'-data within a span of a few years, I can understand that
feeling.  Failures always suck.

> I'm trying to figure out if using kernel-desktop, rather than
> kernel-server, might have anything to do with this.  I'm guessing, bu=
t
> RAID1 + RAID10 is not your usual "desktop" config, so though it might
> be worth a check.  So far, I haven't found enough detail on the
> differences

I just re-read your original post.  I guess I read too fast before I
noticed that it was OpenSuSE 11.2 rather than the SLES distribution.
=46or that, again, I apologize.  However, is this deployment for server
purposes, desktop, or just learning your way around the Linux
way-of-functioning?  Please keep in mind that OpenSuSE is Novell's
equivalent of Red Hat's Fedora -- a proving ground/sandbox with some
form of additional public QA before it makes it into their mainline
Enterprise kernel.  I would shy away from anything that hasn't gone
through a formal QA process before putting it into production use.

Of course, I say that after a production CentOS install of 5.4 which
is the equivalent of RHEL 5.4, of which Fedora 10 was derived.

Point taken.  You've gotta love open source!

Have you checked Novell's OpenSUSE mailing list and community forums?
The last time I checked, there were a few people that were quite
knowledgeable.  I might be able to give you some e-mail addressee's if
you're at a dead-end.  If so, send me a msg off of list and I'd be
glad to help you.

In regards,

--
Jesse W. Wheeler
Member-Owner
Devotio Consulting, L.LC.
--


On Mon, Nov 2, 2009 at 5:33 PM, Ben DJ
<bendj095124367913213465@gmail.com> wrote:
> Jesse
>
> On Mon, Nov 2, 2009 at 1:25 PM, Jesse Wheeler <jwwstpete@gmail.com> w=
rote:
>> I've observed some similar behavior on RAID-5 w/ SuSE Enterprise
>> Server 10.2 SP2 with our eDirectory boxes. =A0While this is differen=
t
>> from my current issue that I posted today, I will say that I have ha=
d
>> -- on average -- better luck with with RHEL based distributions than
>> SuSE variants.
>
> I can't say I've made any of those comparisons. =A0Given a choice, I'=
m
> sticking with openSUSE ...
>
> 11.2's RAID behavior 'feels' a bit more fragile than it was on 11.1.
> That might be simply because I'm a bit paranoid now what with the
> recent FAIL.
>
> I'm trying to figure out if using kernel-desktop, rather than
> kernel-server, might have anything to do with this. =A0I'm guessing, =
but
> RAID1 + RAID10 is not your usual "desktop" config, so though it might
> be worth a check. =A0So far, I haven't found enough detail on the
> differences.
>
> BenDJ
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
