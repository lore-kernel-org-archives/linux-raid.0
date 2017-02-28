From: Les Stroud <les@lesstroud.com>
Subject: Re: Process stuck in md_flush_request (state: D)
Date: Mon, 27 Feb 2017 21:58:37 -0500
Message-ID: <4743144107696292033@unknownmsgid>
References: <36A8825E-F387-4ED8-8672-976094B3BEBB@lesstroud.com>
 <99A92F4D-338D-4486-BB1C-C114A8524403@lesstroud.com> <20170217200644.amaxgira4nqlbchh@kernel.org>
 <9589FA71-C458-4B44-B2F3-3D42E8B0885D@lesstroud.com> <829563C6-A2AF-4E5F-B5AF-D33D2E5A734E@lesstroud.com>
 <20170227182806.jntxzhyw3nkohl5r@kernel.org> <ED1913CC-96EF-4A25-A1F3-E664396A2710@lesstroud.com>
 <1224510038.17134.1488242683070@vsaw28.prod.google.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1224510038.17134.1488242683070@vsaw28.prod.google.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sent from my iPhone

> On Feb 27, 2017, at 7:44 PM, Shaohua Li <shli@kernel.org> wrote:
>
>> On Mon, Feb 27, 2017 at 01:48:00PM -0500, Les Stroud wrote:
>>
>>
>>
>>
>>> On Feb 27, 2017, at 1:28 PM, Shaohua Li <shli@kernel.org> wrote:
>>>
>>> On Mon, Feb 27, 2017 at 09:49:59AM -0500, Les Stroud wrote:
>>>> After a period of a couple of weeks with one of our test instances hav=
ing this problem every other day, they were all nice enough to operate with=
out an issue for 9 days.  It finally reoccurred last night on one of the ma=
chines.
>>>>
>>>> It exhibits the same symptoms and the call traces look as they did pre=
viously.  This particular instance is configured with a deadline scheduler.=
  I was able to capture the inflight you requested:
>>>>
>>>> $ cat /sys/block/xvd[abcde]/inflight
>>>> =E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 0=E2=80=82=E2=
=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820
>>>> =E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 0=E2=80=82=E2=
=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820
>>>> =E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 0=E2=80=82=E2=
=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820
>>>> =E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 0=E2=80=82=E2=
=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820
>>>> =E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82 0=E2=80=82=E2=
=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=820
>>>>
>>>> I=E2=80=99ve had this happen on instances with the deadline scheduler =
and the noop scheduler.  At this point, I have not had this happen on an in=
stance that is noop and the raid filesystem (ext4) is mounted with nobarrie=
r.  The instances with noop/nobarrier have not been running long enough for=
 me to make any sort of conclusion that it works around the problem. Frankl=
y, I=E2=80=99m not sure I understand the interaction between ext4 barriers =
and raid0 block flushes well enough to theorize whether it should or should=
n=E2=80=99t make a difference.
>>>
>>> If nobarrier, ext4 doesn't send flush request.
>>
>> So, could ext4=E2=80=99s flush request deadlock with an md_flush_request=
?  Do they share a mutex of some sort? Could one of them be failing to acqu=
ire a mutex and not handling it?
>
> No, it shouldn't deadlock. I don't have other reports for such issue. You=
rs are the only one.
>
>>>
>>>> Does any of this help with identifying the bug?  Is there anymore info=
rmation I can get that would be useful?
>>>
>>>
>>> Unfortunately I can't find anything fishing. Does the xcdx disk correct=
ly
>>> handle flush request? For example, you can do the same test with a sing=
le such
>>> disk and check if anything wrong.
>>
I'll test a single disk config.


>> Until recently, we had a number of these systems setup without raid0.  T=
his issue never occurred on those systems.  Unfortunately, I can=E2=80=99t =
find a way to make it happen other than stand a server up and let it run.
>>
>> I suppose I could try a different filesystem and see if that makes a dif=
ference (maybe ext3, xfs, etc).
>
> You could format a xcdx disk and do a test against it, and check if there=
 is
> anything wrong. To be honest, I don't think it's a problme in ext4 side t=
oo,
> but better try other filesystems. If the xcdx is a proprietory driver, I =
highly
> recommend a check with a single such disk first.
>

These disks are AWS EBS. So, maybe it is an issue in the xen virtual
driver? I'll see if amazon support can give me any information about
what's happening below the OS.

Is there any other output that might tell me what the process is waiting on=
?

Thanx,
LES


> Thanks,
> Shaohua
