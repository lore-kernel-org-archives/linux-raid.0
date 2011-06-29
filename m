From: David Brown <david@westcontrol.com>
Subject: Re: Software RAID and TRIM
Date: Wed, 29 Jun 2011 14:46:08 +0200
Message-ID: <iuf6tp$bhd$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>	<BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>	<alpine.OSX.2.00.1106291119200.257@trogdor.csi.cam.ac.uk> <20110629204519.419474d2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110629204519.419474d2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/06/2011 12:45, NeilBrown wrote:
> On Wed, 29 Jun 2011 11:32:55 +0100 (BST) Tom De Mulder<tdm27@cam.ac.u=
k>
> wrote:
>
>> On Tue, 28 Jun 2011, Mathias Bur=E9n wrote:
>>
>>> IIRC md can already pass TRIM down, but I think the filesystem need=
s
>>> to know about the underlying architecture, or something, for TRIM t=
o
>>> work in RAID.
>>
>> Yes, it's (usually/ideally) the filesystem's job to invoke the TRIM
>> command, and that's what ext4 can do. I have it working just fine on
>> single drives, but for reasons of service reliability would need to =
get
>> RAID to work.
>>
>> I tried (on an admittedly vanilla Ubuntu 2.6.38 kernel) the same on =
a two
>> drive RAID1 md and it definitely didn't work (the blocks didn't get =
marked
>> as unused and zeroed).
>>
>>> There's numerous discussions on this in the archives of
>>> this mailing list.
>>
>> Given how fast things move in the world of SSDs at the moment, I wan=
ted to
>> check if any progress was made since. :-) I don't seem to be able to=
 find
>> any reference to this in recent kernel source commits (but I'm a com=
plete
>> amateur when it comes to git).
>
>
> Trim support for md is a long way down my list of interesting project=
s (and
> no-one else has volunteered).
>
> It is not at all straight forward to implement.
>
> For stripe/parity RAID, (RAID4/5/6) it is only safe to discard full s=
tripes at
> a time, and the md layer would need to keep a record of which stripes=
 had been
> discarded so that it didn't risk trusting data (and parity) read from=
 those
> stripes.  So you would need some sort of bitmap of invalid stripes, a=
nd you
> would need the fs to discard in very large chunks for it to be useful=
 at all.
>
> For copying RAID (RAID1, RAID10) you really need the same bitmap.  Th=
ere
> isn't the same risk of reading and trusting discarded parity, but a r=
esync
> which didn't know about discarded ranges would undo the discard for y=
ou.
>
> So is basically requires another bitmap to be stored with the metadat=
a, and a
> fairly fine-grained bitmap it would need to be.  Then every read and =
resync
> checks the bitmap and ignores or returns 0 for discarded ranges, and =
every
> write needs to check and if the range was discard, clear the bit and =
write to
> the whole range.
>
> So: do-able, but definitely non-trivial.
>

Wouldn't the sync/no-sync tracking you already have planned be usable=20
for tracking discarded areas?  Or will that not be find-grained enough=20
for the purpose?

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
