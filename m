From: Michael Busby <michael.a.busby@gmail.com>
Subject: Re: Raid5 to another raid level??
Date: Fri, 2 Sep 2011 14:11:57 +0100
Message-ID: <CAFsPQ__91WvzJ1Xd1cnExkdQKVaPEHfdzrfm2RQPWSQfR-Ve=w@mail.gmail.com>
References: <-7094796685559591664@unknownmsgid>
	<CAFsPQ_97jNixHoYbMfxg9=FqXPWrsz_F1ZPSu1LTdGJA7N7Zcg@mail.gmail.com>
	<20110902121959.173a1aa9@notabene.brown>
	<CAFsPQ_8dA6B9yA4ZWZgAjZggNCBbcprAZrdHeJbPv+UvRz17mA@mail.gmail.com>
	<20110902202235.0194d779@notabene.brown>
	<CAFsPQ_-CfsAbqj-m3biVas0Cyv_+gkrNhHWWR_FkVNSDPB6dMg@mail.gmail.com>
	<20110902224938.74c30811@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110902224938.74c30811@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: john.robinson@anonymous.org.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am using the 3.0.0 kernel so that should not be a issue, have just
upgraded mdadm on my box to 3.2.2 from 3.1.4

would i be right in thinking that to get from raid0 to raid5 i would
first have to change from raid0 to raid4 and add the extra disk for
parity, once i am at this level i would need a command to get the
parity data striped over the raid5 and not in a single disk like raid4
or maybe there is a way to go from raid0 direct to raid5 by adding the
extra disk and then having the parity data created and spread over the
disks....

On 2 September 2011 13:49, NeilBrown <neilb@suse.de> wrote:
> On Fri, 2 Sep 2011 11:35:30 +0100 Michael Busby <michael.a.busby@gmai=
l.com>
> wrote:
>
>> Great, will test that in a bit
>>
>> will mdadm 3.2.2 support converting raid4 to raid5
>>
>> "A RAID4 can change the number of devices or the size of individual
>> devices. It cannot be converted to RAID5 yet (though that should be
>> trivial to implement)"
>
> I guess the man page needs updating. =A0You would need a reasonably r=
ecent
> kernel... 2.6.30 or later. =A0I guess that isn't so recent any more.
>
> NeilBrown
>
>
>>
>> On 2 September 2011 11:22, NeilBrown <neilb@suse.de> wrote:
>> > On Fri, 2 Sep 2011 10:12:32 +0100 Michael Busby <michael.a.busby@g=
mail.com>
>> > wrote:
>> >
>> >> Thanks Neil
>> >>
>> >> Is there anyway back from raid0 to raid4 as i know once at raid0 =
i
>> >> will no longer be able to add any disks, in theory i could change
>> >> echo raid0 > /sys/block/md0/md/level,but this would require addin=
g a
>> >> missing disk to the raid4 at the same time, not sure how easy tha=
t
>> >> would be todo
>> >>
>> >
>> > Yes, you can switch from RAID0 to RAID4 in much the same way as yo=
u switch
>> > from RAID4 to RAID0.
>> > You can then freeze/add-disk/change-size/unfreeze/wait/switch-back=
-to-RAID0
>> > to add more devices.
>> >
>> > mdadm-3.2.2 should be able to do all this for you. =A0i.e. you ask=
 it to --grow
>> > a RAID and --add some disks at the same time, and it will do all t=
he required
>> > magic.
>> >
>> > This hasn't been tested extensively, but should work in simple cas=
es.
>> >
>> > Of course the more devices you have in a RAID0, the less reliabili=
ty you have
>> > - but e.g. as a cache for a tape backup system a large RAID0 is fi=
ne.
>> >
>> > NeilBrown
>> >
>> >
>> >
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
