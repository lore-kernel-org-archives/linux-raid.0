From: Maarten <maarten@ultratux.net>
Subject: Re: Suboptimal raid6 linear read speed
Date: Sun, 20 Jan 2013 01:49:56 +0100
Message-ID: <50FB3F34.3000302@ultratux.net>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se> <50F90857.3010305@hardwarefreak.com> <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se> <50F9D32F.7090606@hardwarefreak.com> <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se> <50FB22D8.5000803@hardwarefreak.com> <50FB3185.7060009@ultratux.net> <6675858F-43FC-48CE-B146-856F50481289@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6675858F-43FC-48CE-B146-856F50481289@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/20/13 01:16, Chris Murphy wrote:
>=20
> On Jan 19, 2013, at 4:51 PM, Maarten <maarten@ultratux.net> wrote:
>=20
>> On 01/19/13 23:48, Stan Hoeppner wrote:
>>> On 1/19/2013 1:43 AM, Mikael Abrahamsson wrote:
>>>
>>>> With a BER of 10^-14 you have a 16% risk of getting URE when readi=
ng an
>>>> entire 2TB drive.
>>> On 1/19/2013 7:21 AM, Roy Sigurd Karlsbakk wrote:
>>>
>>>> ok, perhaps, maybe, but then it's 17% chance of losing data after =
a
>>>> mirror or raid-5 rebuild with 2TB drives...
>>> Where are you guys coming up with this 16-17% chance of URE on any
>>> single full read of this 2TB, 10E14 drive?  The URE rate here is 1 =
bit
>>> for every 12.5 trillion bytes.  Thus, statistically, one must read =
this
>>> drive more than 6 times to encounter a URE.  Given that, how is any
>>> single full read between the 1st and the 6th going to have a 16-17%
>>> chance of encountering a URE for that one full read?  That doesn't =
make
>>> sense.
>> Sorry but now I have to speak up too. Of course that 16-17% figure i=
s
>> right! Did you miss out on math classes ? It is all statistics. Ther=
e is
>> a chance of '1.0' to get one URE reading 12.5 TB. That URE may be
>> encountered at the very start of the first TB, or it may not come at
>> all, because that is how statistics work. But *on*average*, you'll g=
et
>> 1.0 URE per 12.5 TB, ergo, 0.16 per 2.0 TB. Basic simple math=85 jee=
z.
>=20
> Please explain this basic, simple math, where a URE is equivalent to =
1 bit of information. And also, explain the simple math where bit of er=
ror is equal to a URE. And please explain the simple math in the contex=
t of a conventional HDD 512 byte sector, which is 4096 bits.
>=20
> If you have a URE, you have lost not 1 bit. You have lost 4096 bits. =
A loss of 4096 bits in 12.5TB (not 12.5TiB) is an error rate of 1 bit o=
f error in 2.44^10 bits. That is a gross difference from published erro=
r rates.
>=20
> And then explain how the manufacturer spec does not actually report t=
he URE in anything approaching "on average" terms, but *less than* 1 bi=
t in 10^14. If you propose the manufacturers are incorrectly reporting =
the error rate, realize you're basically accusing them of a rather mass=
ive fraud because less than 1 bit of error in X, is a significantly dif=
ferent thing than "on average" 1 bit of error in X. This could be up to=
, but not including, a full order magnitude higher error rate than the =
published spec. It's not an insignificant difference.

All very nice, but that is not the point, is it. The point is, to
calculate (or rather: estimate) the odds of an URE encounter when
reading 2TB, based on the figure one has for reading 12,5 TB. Whether
that 12,5 figure is correct or not, whether endorsed by manufacturers o=
r
not, is totally irrelevant.  It simply boils down to, if there are 10
X's in every 10G Y's, then there are 2 X's in every 2G Y's. Yes ?

cheers,
Maarten

>=20
> Chris Murphy
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
