From: Chris Worley <worleys@gmail.com>
Subject: Re: Load-balancing mirrors w/ asymmetric performance
Date: Fri, 16 Oct 2009 13:07:50 -0600
Message-ID: <f3177b9e0910161207n70eeddaar4157a2887fa55cdf@mail.gmail.com>
References: <f3177b9e0910041240h4dba8771vb5ba07216c9c8189@mail.gmail.com>
	 <170fa0d20910120722o2347f119g9e3c48b52bc4efef@mail.gmail.com>
	 <f3177b9e0910120800y56d01e77u50c95c918e02d602@mail.gmail.com>
	 <170fa0d20910121833s50776aaer6f5feefb47fc3028@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20910121833s50776aaer6f5feefb47fc3028@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 12, 2009 at 7:33 PM, Mike Snitzer <snitzer@gmail.com> wrote=
:
> On Mon, Oct 12, 2009 at 11:00 AM, Chris Worley <worleys@gmail.com> wr=
ote:
>> On Mon, Oct 12, 2009 at 8:22 AM, Mike Snitzer <snitzer@gmail.com> wr=
ote:
>>> On Sun, Oct 4, 2009 at 3:40 PM, Chris Worley <worleys@gmail.com> wr=
ote:
>>>> When you mirror two devices, they may not have the same performanc=
e.
>>>> For example, if one device is local and the other remote.
>>>>
>>>> There's nothing you can do about writes, as everything needs writt=
en.
>>>>
>>>> But, reads shouldn't be split 50/50: they should be balanced depen=
ding
>>>> relative performance of each mirror to optimize overall read
>>>> performance.
>>>
>>> And MD already has the ability to flag the slow paths as write-most=
ly, see:
>>>
>>> mdadm ... --write-mostly
>>>
>>> There is also '--write-behind' support for devices that have been
>>> tagged as 'write-mostly'.
>>
>> Will "write-mostly" optimize the "read", such that both devices will
>> be accessed in proportion to their performance?
>>
>> The man page says:
>>
>> "...and means that the =92md=92 driver will avoid reading from these
>> devices if at all possible."
>>
>> Even a slow device can take some of the load and increase performanc=
e.
>
> AFAIK, with current MD raid1, reads are only balanced across all
> non-'write-mostly' drives. Having raid1's reads be issued proportiona=
l
> to each underlying devices' performance is not currently possible.
>
> I'd imagine that the per-bdi dirty-page accounting of each underlying
> device could be used to train raid1's reads (score each raid1 member
> over time) but I'm not aware of any effort toward that end.

Off the top of my head: the user could control this w/ a per-device
read queue depth.  Set it small for the remote and large for the
local.  Let the use optimize for their case.

Chris
>
> Mike
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
