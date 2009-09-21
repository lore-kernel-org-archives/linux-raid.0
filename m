From: "Majed B." <majedb@gmail.com>
Subject: Re: LVM and Raid5
Date: Mon, 21 Sep 2009 22:14:19 +0300
Message-ID: <70ed7c3e0909211214p3f38a602s2b0fac77a3da5cc1@mail.gmail.com>
References: <f5d1f90a0909160122j32569fb8g9e2a212532ea8604@mail.gmail.com>
	<4AB22DA3.2090901@ziu.info> <170fa0d20909210733p2e3e797cvb60af2e9bd153fda@mail.gmail.com>
	<f5d1f90a0909211038l2d450033p173fa17e3e5c5da1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5d1f90a0909211038l2d450033p173fa17e3e5c5da1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

On Mon, Sep 21, 2009 at 8:38 PM, Linux Raid Study
<linuxraid.study@gmail.com> wrote:
> Can I use LVM2 with kernel 2.6.27?
>
> Thanks everyone!

Can you be more specific?! If it's just in general, then yes. If you
want to use with RAID, then also yes.

>> On Mon, Sep 21, 2009 at 7:33 AM, Mike Snitzer <snitzer@gmail.com> wr=
ote:
>> On Thu, Sep 17, 2009 at 8:37 AM, Michal Soltys <soltys@ziu.info> wro=
te:
>>> Linux Raid Study wrote:
>>>>
>>>> Hello:
>>>>
>>>> Has someone experimented with LVM and Raid5 together (on say, 2.6.=
27)?
>>>> Is there any performance drop if LVM/Raid5 are combined vs Raid5 a=
lone?
>>>>
>>>> Thanks for your inputs!
>>>
>>> Few things to consider when setting up LVM on MD raid:
>>>
>>> - readahead set on lvm device
>>>
>>> It defaults to 256 on any LVM device, while MD will set it accordin=
gly to
>>> the amount of disks present in the raid. If you do tests on a files=
ystem,
>>> you may see significant differences due to that. YMMV depending on =
the type
>>> of used benchmark(s).
>>>
>>> - filesystem awareness of underlying raid
>>>
>>> For example, xfs created on top of raid, will generally get the par=
ameters
>>> right (stripe unit, stripe width), but if it's xfs on lvm on raid, =
then it
>>> won't - you will have to provide them manually.
>>>
>>> - alignment between LVM chunks and MD chunks
>>>
>>> Make sure that extent area used for actual logical volumes start at=
 the
>>> boundary of stripe unit - you can adjust the LVM's metadata size du=
ring
>>> pvcreate (by default it's 192KiB, so with non-default stripe unit i=
t may
>>> cause issues, although I vaguely recall posts that current LVM is M=
D aware
>>> during initialization). Of course LVM must itself start at the boun=
dary for
>>> that to make any sense (and it doesn't have to be the case - for ex=
ample if
>>> you use partitionable MD).
>>
>> All of the above have been resolved in recent LVM2 userspace (2.02.5=
1
>> being the most recent release with all these addressed). =C2=A0The l=
ast
>> issue you mention (partitionable MD alignment offset) is also resolv=
ed
>> when a recent LVM2 is coupled with Linux 2.6.31 (which provides IO
>> Topology support).
>>
>> Mike
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
