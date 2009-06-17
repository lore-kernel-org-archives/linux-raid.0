From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH] md linear: Protecting mddev with rcu locks to avoid
     races  in
Date: Wed, 17 Jun 2009 16:50:13 +1000 (EST)
Message-ID: <750ace456f740751a36dc62f891e2ea0.squirrel@neil.brown.name>
References: <37d33d830906060824u1bf71f1ej22efc3e8bbcaf2b9@mail.gmail.com>
    <18997.32786.206008.486995@notabene.brown>
    <37d33d830906162335j2dda043dn7e5c19d3b40de103@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830906162335j2dda043dn7e5c19d3b40de103@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, June 17, 2009 4:35 pm, SandeepKsinha wrote:
>>
>> 2/ mddev->raid_disks should really be dereferenced before 'conf'.
>> =A0Doing it the way you have done it, the 'raid_disks' value could b=
e
>> =A0larger than the value supported by the 'conf' so things could
>> =A0go wrong.
>>
> Agreed. I hope you are referring to the case where a disk is in the
> process of being added to an array. Is that right ?
> Kindly confirm.

Yes, that is correct.

>> 4/ We don't need the rcu protection here as we hold ->reconfig_mutex
>> =A0 both in linear_add and linear_stop, so they cannot race.
>> =A0 Adding a comment to this effect might be a good idea though.
>>
>
> Fine. Shall do this as well.
>
> The new patch will follow soon.
>


Thanks!
NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
