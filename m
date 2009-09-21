From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Re: LVM and Raid5
Date: Mon, 21 Sep 2009 10:38:01 -0700
Message-ID: <f5d1f90a0909211038l2d450033p173fa17e3e5c5da1@mail.gmail.com>
References: <f5d1f90a0909160122j32569fb8g9e2a212532ea8604@mail.gmail.com>
	 <4AB22DA3.2090901@ziu.info>
	 <170fa0d20909210733p2e3e797cvb60af2e9bd153fda@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20909210733p2e3e797cvb60af2e9bd153fda@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: Michal Soltys <soltys@ziu.info>, linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

Can I use LVM2 with kernel 2.6.27?

Thanks everyone!

On Mon, Sep 21, 2009 at 7:33 AM, Mike Snitzer <snitzer@gmail.com> wrote=
:
> On Thu, Sep 17, 2009 at 8:37 AM, Michal Soltys <soltys@ziu.info> wrot=
e:
>> Linux Raid Study wrote:
>>>
>>> Hello:
>>>
>>> Has someone experimented with LVM and Raid5 together (on say, 2.6.2=
7)?
>>> Is there any performance drop if LVM/Raid5 are combined vs Raid5 al=
one?
>>>
>>> Thanks for your inputs!
>>
>> Few things to consider when setting up LVM on MD raid:
>>
>> - readahead set on lvm device
>>
>> It defaults to 256 on any LVM device, while MD will set it according=
ly to
>> the amount of disks present in the raid. If you do tests on a filesy=
stem,
>> you may see significant differences due to that. YMMV depending on t=
he type
>> of used benchmark(s).
>>
>> - filesystem awareness of underlying raid
>>
>> For example, xfs created on top of raid, will generally get the para=
meters
>> right (stripe unit, stripe width), but if it's xfs on lvm on raid, t=
hen it
>> won't - you will have to provide them manually.
>>
>> - alignment between LVM chunks and MD chunks
>>
>> Make sure that extent area used for actual logical volumes start at =
the
>> boundary of stripe unit - you can adjust the LVM's metadata size dur=
ing
>> pvcreate (by default it's 192KiB, so with non-default stripe unit it=
 may
>> cause issues, although I vaguely recall posts that current LVM is MD=
 aware
>> during initialization). Of course LVM must itself start at the bound=
ary for
>> that to make any sense (and it doesn't have to be the case - for exa=
mple if
>> you use partitionable MD).
>
> All of the above have been resolved in recent LVM2 userspace (2.02.51
> being the most recent release with all these addressed). =C2=A0The la=
st
> issue you mention (partitionable MD alignment offset) is also resolve=
d
> when a recent LVM2 is coupled with Linux 2.6.31 (which provides IO
> Topology support).
>
> Mike
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
