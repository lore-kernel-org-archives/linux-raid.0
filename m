From: CoolCold <coolthecold@gmail.com>
Subject: Re: RAID Class Drives`
Date: Mon, 19 Apr 2010 14:11:59 +0400
Message-ID: <h2rf19d625d1004190311qefcc12f3q599acd47d8732046@mail.gmail.com>
References: <7db987b31003170648j19e3346bi1050e703ef8c811c@mail.gmail.com>
	 <7db987b31003181243n159eb7e9re2b614295221eee@mail.gmail.com>
	 <y2if19d625d1004180511m5f4032cp99f866024f76d93a@mail.gmail.com>
	 <4BCB6484.7040500@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCB6484.7040500@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Apr 18, 2010 at 11:59 PM, Stefan /*St0fF*/ H=FCbner
<stefan.huebner@stud.tu-ilmenau.de> wrote:
> Hi!
>
> Am 18.04.2010 14:11, schrieb CoolCold:
>> I don't really understand one point - why it failed? Did the
>> controller dropped device because it wasn't responsible or md did
>> this? Rephrasing my question - this is really "tuning" for controlle=
r
>> not to drop device and report error or for md?
>
> If a desktop class drive starts its error recovery, it becomes
> unresponsive. =A0MD thinks this, but it isn't smart. =A0It tries to r=
ewrite
> the sector while the drive itself is still in error recovery mode and=
 by
> that unresponsive. =A0The write fails, MD drops the device.
Stop-stop. It is clear that timeouting "read" request in short period
is good idea, but i wanna know about writes
Does write fail because controller returns smth like "media error" or
md has internal operation timeouts?
Even if drive doens't become irresponsible and returns "error on
write" it will be dropped anyway.

So, SCT-ERC setting will prevent drive to be irresponsible for long
time which may be desirable in case of:
a) md doesn't have it's own timeouting mechanism and the whole md
device will be stucked
b) drive ( another partition ) is part of another array/lvm
pv/whatever and that device will be stucked too.


>
>> And if drive has errors anyway, why it shouldn't be dropped, is it f=
or
>> just in case we have read error, we can try to rewrite it from the
>> alive array part? If we have write error, we gonna drop drive from
>> array anyway..
>>
> Because that is the reason hdd manufacturers built in spare sectors a=
nd
> internal error recovery procedures. =A0Think about the write density =
of
> todays drives, think about the many influences which it must work wit=
h.
> =A0The nearly atomically-sized bits on the platter.
> IT IS NOT POSSIBLE to build a perfect drive on todays specifications.
> That's why this exists in the first place. =A0And as we can see it is=
 a
> very easy way for hdd manufacturers to make extra money. =A0Just labe=
l
> those drives that also passed the very last quality test (not only th=
e
> other 10 tests before) "superdrive", sell them for nearly double the
> price and give them a firmware, where the advanced features are just
> enabled as default...
>
> /stefan
>
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
