From: CoolCold <coolthecold@gmail.com>
Subject: Re: man mdadm regarding --assume-clean says it's OK to use with RAID1
	or 10, when creating:
Date: Wed, 26 Aug 2009 03:34:04 +0400
Message-ID: <f19d625d0908251634g43a51263m7829554f3a0fb00f@mail.gmail.com>
References: <43d009740908220701j25b26bd8o4ac0030121544c32@mail.gmail.com>
	 <c268e4660908221046x6e461de1u3c6e36f1a7e4021c@mail.gmail.com>
	 <43d009740908221048w2b76f14fwae6abdec1b098bcf@mail.gmail.com>
	 <b5c57585f8e55bf526f86418980dfbb4.squirrel@neil.brown.name>
	 <43d009740908222221w5f5ae3b4qa224322ce0e763c6@mail.gmail.com>
	 <19092.25831.449670.747732@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19092.25831.449670.747732@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: for.poige+linux@gmail.com, Drew <drew.kay@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 26, 2009 at 2:25 AM, Neil Brown <neilb@suse.de> wrote:
>
> On Sunday August 23, for.poige+linux@gmail.com wrote:
> > 2009/8/23 NeilBrown <neilb@suse.de>:
> > [...]
> > > Yes it will be updated. =A0But if it is updated with a
> > > read-modify-write cycle then an old incorrect value will be updat=
ed
> > > to a new incorrect value, which doesn't help you much.
> >
> > =A0 =A0 =A0 I see. Thank you for the answer. My assumption was due =
thinking that
> > parity is never being used when RAID5 is in "healthy" mode.
> >
> > =A0 =A0 =A0 But anyway, please clear it up: if I've made --asume-cl=
ean RAID5
> > array, formatted it with some FS (or even LVM), and put OS/data to =
it,
> > then (in idle at night, for e. g.) run "resync", would that be the
> > same valid result (overall data integrity) as if I had previously
> > created it without "--asume-clean" at all? (Let's suppose hard disk=
s
> > were healthy in both cases :-)
>
> If by 'run "resync"' you mean
> =A0 echo repair > /sys/block/mdXX/md/sync_action
> then yes, what will have the same effect as not using --assume-clean
> to start with.
>
> >
> > =A0 =A0 =A0 And Neil, using the chance to have your reply :-) I'd l=
ike to ask one
> > more question: is that true (I think and hope it is!) that MD doesn=
't
> > read/write full chunk size when it's just to read/write another blo=
ck
> > of data and hence chunk size only affects data interleaving on disk=
s.
>
> That is correct - chunk size only affect data layout, not IO size.
> md/raid5 always reads or writes a whole page (normally 4K) at a time.
>
> NeilBrown
>
>

Hmm...so how read from some program -> fs -> md happens then? I.e. -
if FS has stride/stripe/swidth for, say, 64kb (and md chunk size is
64kb), some program requests 128kb of data to be read, does it mean
we'll do 16 reads for 4kb from two drives? Even if we do, is it
right/good ?


--
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
