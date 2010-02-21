From: chris <tknchris@gmail.com>
Subject: Re: Weird Issue with raid 5+0
Date: Sun, 21 Feb 2010 05:35:42 -0500
Message-ID: <31e44a111002210235y3cdb0035gfbea7d75b16e1764@mail.gmail.com>
References: <31e44a111002202033m4a9dfba9yf8aef62b8b39933a@mail.gmail.com>
	 <20100221164805.5bdc2d60@notabene.brown>
	 <31e44a111002202326x407c814dsaa60e51a8a0ff049@mail.gmail.com>
	 <20100221191640.39b68b01@notabene.brown>
	 <20100221192107.2ede0267@notabene.brown>
	 <31e44a111002210117y7b6164ebl8383bbae14f07c87@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <31e44a111002210117y7b6164ebl8383bbae14f07c87@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Another thought, I have several boxes running raid1's and raid5's
under the same kernel. Does this bug affect only dom0 or only the way
im nesting the raids? I will try a more recent dom0 kernel and see if
that makes any difference in the meantime.

- chris

On Sun, Feb 21, 2010 at 4:17 AM, chris <tknchris@gmail.com> wrote:
> Neil,
>
> The raid is being done in dom0, any idea how to set that from the
> kernel cmdline?
>
> - chris
>
> On Sun, Feb 21, 2010 at 3:21 AM, Neil Brown <neilb@suse.de> wrote:
>> On Sun, 21 Feb 2010 19:16:40 +1100
>> Neil Brown <neilb@suse.de> wrote:
>>
>>> On Sun, 21 Feb 2010 02:26:42 -0500
>>> chris <tknchris@gmail.com> wrote:
>>>
>>> > That is exactly what I didn't want to hear :( I am running
>>> > 2.6.26-2-xen-amd64. Are you sure its a kernel problem and nothing=
 to
>>> > do with my chunk/block sizes? If this is a bug what versions are
>>> > affected, I'll build a new domU kernel and see if I can get it wo=
rking
>>> > there.
>>> >
>>> > - chris
>>>
>>> I'm absolutely sure it is a kernel bug.
>>
>> though it just occurs to me that you might be able to work around it=
=2E
>> If, in the guest, you set "max_sectors_kb" to "4"
>> in /sys/block/whatever/queue, it might avoid the problem.
>>
>> NeilBrown
>>
>>
>>> I have no idea what version might be affected. =A0Probably all, but
>>> as xen isn't fully in main line it isn't easy for me to explore.
>>>
>>> I suggest you contact the xen developers (or whoever you got xen fr=
om).
>>> I'm happy to discuss the problem with someone who knows about xen b=
lock
>>> device access, but I don't want to go hunting to find such a person=
=2E
>>>
>>> NeilBrown
>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
