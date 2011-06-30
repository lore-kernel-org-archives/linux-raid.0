From: David Brown <david@westcontrol.com>
Subject: Re: Software RAID and TRIM
Date: Thu, 30 Jun 2011 09:50:28 +0200
Message-ID: <iuh9vg$v86$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>	<BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>	<alpine.OSX.2.00.1106291119200.257@trogdor.csi.cam.ac.uk>	<20110629204519.419474d2@notabene.brown>	<iuf6tp$bhd$1@dough.gmane.org> <20110630102846.610534af@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110630102846.610534af@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/06/2011 02:28, NeilBrown wrote:
> On Wed, 29 Jun 2011 14:46:08 +0200 David Brown<david@westcontrol.com>=
  wrote:
>
>> On 29/06/2011 12:45, NeilBrown wrote:
>>> On Wed, 29 Jun 2011 11:32:55 +0100 (BST) Tom De Mulder<tdm27@cam.ac=
=2Euk>
>>> wrote:
>>>
>>>> On Tue, 28 Jun 2011, Mathias Bur=E9n wrote:
>>>>
>>>>> IIRC md can already pass TRIM down, but I think the filesystem ne=
eds
>>>>> to know about the underlying architecture, or something, for TRIM=
 to
>>>>> work in RAID.
>>>>
>>>> Yes, it's (usually/ideally) the filesystem's job to invoke the TRI=
M
>>>> command, and that's what ext4 can do. I have it working just fine =
on
>>>> single drives, but for reasons of service reliability would need t=
o get
>>>> RAID to work.
>>>>
>>>> I tried (on an admittedly vanilla Ubuntu 2.6.38 kernel) the same o=
n a two
>>>> drive RAID1 md and it definitely didn't work (the blocks didn't ge=
t marked
>>>> as unused and zeroed).
>>>>
>>>>> There's numerous discussions on this in the archives of
>>>>> this mailing list.
>>>>
>>>> Given how fast things move in the world of SSDs at the moment, I w=
anted to
>>>> check if any progress was made since. :-) I don't seem to be able =
to find
>>>> any reference to this in recent kernel source commits (but I'm a c=
omplete
>>>> amateur when it comes to git).
>>>
>>>
>>> Trim support for md is a long way down my list of interesting proje=
cts (and
>>> no-one else has volunteered).
>>>
>>> It is not at all straight forward to implement.
>>>
>>> For stripe/parity RAID, (RAID4/5/6) it is only safe to discard full=
 stripes at
>>> a time, and the md layer would need to keep a record of which strip=
es had been
>>> discarded so that it didn't risk trusting data (and parity) read fr=
om those
>>> stripes.  So you would need some sort of bitmap of invalid stripes,=
 and you
>>> would need the fs to discard in very large chunks for it to be usef=
ul at all.
>>>
>>> For copying RAID (RAID1, RAID10) you really need the same bitmap.  =
There
>>> isn't the same risk of reading and trusting discarded parity, but a=
 resync
>>> which didn't know about discarded ranges would undo the discard for=
 you.
>>>
>>> So is basically requires another bitmap to be stored with the metad=
ata, and a
>>> fairly fine-grained bitmap it would need to be.  Then every read an=
d resync
>>> checks the bitmap and ignores or returns 0 for discarded ranges, an=
d every
>>> write needs to check and if the range was discard, clear the bit an=
d write to
>>> the whole range.
>>>
>>> So: do-able, but definitely non-trivial.
>>>
>>
>> Wouldn't the sync/no-sync tracking you already have planned be usabl=
e
>> for tracking discarded areas?  Or will that not be find-grained enou=
gh
>> for the purpose?
>
> That would be a necessary precursor to DISCARD support: yes.
> DISCARD would probably require a much finer grain than I would otherw=
ise
> suggest but I would design the feature to allow a range of granularit=
ies.
>

I suppose the big win for the sync/no-sync tracking is when initialisin=
g=20
an array - arrays that haven't been written don't need to be in sync.=20
But you will probably be best with a list of sync (or no-sync) areas fo=
r=20
that job, rather than a bitmap, as there won't be very many such blocks=
=20
(a few dozen, perhaps, for multiple partitions and filesystems like XFS=
=20
that write in different areas) and as the disk gets used, the "no-sync"=
=20
areas will decrease in size and number.  For DISCARD, however, you'd ge=
t=20
no-sync areas scattered around the disk.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
