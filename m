From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Read algorithm-raid1/raid10
Date: Tue, 18 Jan 2011 14:15:16 -0200
Message-ID: <AANLkTikUgkuYjr5ChovwE6srnK=_h1MVT1bhposmo3tB@mail.gmail.com>
References: <AANLkTin+Kd+RfuEUyBrvnunBbQ+2uzzdy57Xy-LEJ_6J@mail.gmail.com>
	<AANLkTi=ULecH9g9Mt+axPY_KsyvZU=KdawphxpJ2kDGi@mail.gmail.com>
	<20110118150149.GB602@www2.open-std.org>
	<AANLkTinJNLYd6uYp+zjrQsWiwKS9ZWMuhMQfcpg-4rj4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinJNLYd6uYp+zjrQsWiwKS9ZWMuhMQfcpg-4rj4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

yes i found it in my /sys filesystem, a rotational information 0 for
hd 1 for ssd

i write a long time ago a more interesting algorithm but complex... a
minimal time algorithm, it should have information about head position
time, read time (per bit, per byte, per units....) and calculate the
time to make a read in each disk considering that it could be reading
(time to stop read current requestion) and after this get the smallest
time -> the best read performace

if we use only ssd disk today implementation isn=B4t good, if we use hd=
d
maybe a good (if we don=B4t use 7200rpm + 10000rpm + 15000rpm disks), i=
f
we use a mixed ssd+hdd it will not work very good too... this should
be a per disk optimization (minimal time to read) a round robin is a
good feature (for ssd only) but a mixed array should allow minimal
time algorithm

any idea how to implement a round robin and a algorithm (per raid
device) selection using sysfs?
there=B4s a patch but i didn=B4t found information about how to patch t=
he
kernel with it
can anyone help me?
thanks

2011/1/18 Mathias Bur=E9n <mathias.buren@gmail.com>:
> 2011/1/18 Keld J=F8rn Simonsen <keld@keldix.com>:
>> On Tue, Jan 18, 2011 at 12:00:49PM -0200, Roberto Spadim wrote:
>>> like this patch (a long time ago)
>>> http://www.spinics.net/lists/raid/msg30003.html
>>>
>>>
>>> 2011/1/18 Roberto Spadim <roberto@spadim.com.br>:
>>> > hi guys, could we implement a load_balance read algorithm for SSD=
?
>>> > nearest head isn't as fast as round robin for ssd.
>>> > i'm talking about raid1 (raid10 too)
>>> > what's my problem?
>>> > as i can see, raid0 is faster than raid1
>>> > for example:
>>> > two disks raid0 is faster than
>>> > two disks raid1.
>>> >
>>> > why?
>>> > nearest head
>>> > instead of a balanced read algorithm (like raid0) the nearest hea=
d
>>> > make raid1 use only one disk for searchs where we could use two d=
isks
>>> > (like raid0)
>>> >
>>> > could we implement a round robin for ssd? and make raid1 as fast =
as
>>> > raid0 for ssd?
>>> > i didn't tested the raid10 algorithm yet.
>>> > thanks a lot.
>>
>> This should only be in use for SSDs. For disks it would be a waste o=
f IO
>> bandwidth. How do we detect whether it is a SSSD.
>> Another way to accomplish an improvement os to use the offset layout=
 of
>> raid10.
>>
>> best regards
>> Keld
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> Hi,
>
> There is a way to check if the device is an SSD or not; the rotationa=
l
> queue flag in sysfs. See
> http://amailbox.org/mailarchive/git-commits-head/2009/1/30/4859834/th=
read
> .
>
> // Mathias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
