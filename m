From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Re: Resize Raid5 devices
Date: Sun, 21 Jun 2009 11:40:11 +0200
Message-ID: <427AC024-D923-4D56-9286-BD42ACA4A1F2@bj-ig.de>
References: <62E07ACC-0F47-4B5F-94C7-29199ECE46FE@bj-ig.de> <87tz2e7xqt.fsf@frosties.localdomain> <4CB2808F-EB88-458A-9D2B-22E31A97EB4F@bj-ig.de> <19002.61619.121746.923481@notabene.brown> <F1460A31-578A-4F80-8209-C56B47FBA367@bj-ig.de> <2a8e1e3ff2ac1abf41673992b3b24c47.squirrel@neil.brown.name>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2a8e1e3ff2ac1abf41673992b3b24c47.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids


Am 20.06.2009 um 23:26 schrieb NeilBrown:

> On Sun, June 21, 2009 12:21 am, Ralf M=FCller wrote:
>> Am 19.06.2009 um 03:58 schrieb Neil Brown:
>>>> Do you have an idea why this bitmap has been ignored?
>>>
>>> Probably a kernel bug.  There have been a couple of fixes relating =
=20
>>> to
>>> this since 2.6.25.  Hopefully it is all working in 2.6.30...
>>>
>>> The bug that you hit was probably the one fixed by
>>> commit a0da84f35b25875870270d16b6eccda4884d61a7
>>> which is in 2.6.27.
>>
>> Just for your information: I updated to OpenSuSE 11.1
>> (kernel 2.6.27.23-0.1) and tried to remove, grow, re-add the other
>> devices. For the first disk it worked - re-add took nearly no time
>> because of the bitmap. For the second disk - it did not work: =20
>> complete
>> resync triggered. No idea why. It has been the same sequence of
>> commands on the same kind of device. There were no filesystem write
>> operations on the raid while updating.
>
> Thanks for keeping us informed.
> The was another bug related to this that was fixed much more =20
> recently -
> in 2.6.30 I think.
> commit d0a4bb492772ce5c4bdfba3744a99ed6f6fb238f
>
> I think it was a lot harder to hit, but maybe you hit it.

Ok - when you said it was a lot harder to hit I thought "Hey - hit two
bugs in a row was a great deal, hit a seldom bug a second time ... this
will not happen" and I tried the 4th disk with fail/grow/re-add too.

I hit this bug again ... so it seems having a bitmap at these arrays
saved 10 out of 40 hours for me. Not that impressive ;)

The array does not have a lot of write load (actually write operations
happen in _multi_ GB chunks one to four times a year).

>> Would there have been a way to update the recorded device-size of
>> the member devices online? If the fail/grow/re-add cycle would
>> have worked, I still would have superblocks with the old
>> size - right?
>
> With a recent kernel, you can write "0" (or some other size
> in sectors) to /sys/block/mdX/md/dev-YYY/size, and it will update the
> device size online.  That functionality appeared in 2.6.26 so
> OpenSUSE 11.1 should have it.

It does. And as far as I can say it works. The new device size is
reported in /sys/.../dev-YYY/size and with mdadm -E. So I expect
these values to actually be written to the superblocks.

Regards
Ralf

--=20
Van Roy's Law: -------------------------------------------------------
        An unbreakable toy is useful for breaking other toys.



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
