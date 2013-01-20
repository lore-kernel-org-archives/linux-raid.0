From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Suboptimal raid6 linear read speed
Date: Sat, 19 Jan 2013 17:16:56 -0700
Message-ID: <6675858F-43FC-48CE-B146-856F50481289@colorremedies.com>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se> <50F90857.3010305@hardwarefreak.com> <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se> <50F9D32F.7090606@hardwarefreak.com> <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se> <50FB22D8.5000803@hardwarefreak.com> <50FB3185.7060009@ultratux.net>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50FB3185.7060009@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 19, 2013, at 4:51 PM, Maarten <maarten@ultratux.net> wrote:

> On 01/19/13 23:48, Stan Hoeppner wrote:
>> On 1/19/2013 1:43 AM, Mikael Abrahamsson wrote:
>>=20
>>> With a BER of 10^-14 you have a 16% risk of getting URE when readin=
g an
>>> entire 2TB drive.
>> On 1/19/2013 7:21 AM, Roy Sigurd Karlsbakk wrote:
>>=20
>>> ok, perhaps, maybe, but then it's 17% chance of losing data after a
>>> mirror or raid-5 rebuild with 2TB drives...
>> Where are you guys coming up with this 16-17% chance of URE on any
>> single full read of this 2TB, 10E14 drive?  The URE rate here is 1 b=
it
>> for every 12.5 trillion bytes.  Thus, statistically, one must read t=
his
>> drive more than 6 times to encounter a URE.  Given that, how is any
>> single full read between the 1st and the 6th going to have a 16-17%
>> chance of encountering a URE for that one full read?  That doesn't m=
ake
>> sense.
> Sorry but now I have to speak up too. Of course that 16-17% figure is
> right! Did you miss out on math classes ? It is all statistics. There=
 is
> a chance of '1.0' to get one URE reading 12.5 TB. That URE may be
> encountered at the very start of the first TB, or it may not come at
> all, because that is how statistics work. But *on*average*, you'll ge=
t
> 1.0 URE per 12.5 TB, ergo, 0.16 per 2.0 TB. Basic simple math=85 jeez=
=2E

Please explain this basic, simple math, where a URE is equivalent to 1 =
bit of information. And also, explain the simple math where bit of erro=
r is equal to a URE. And please explain the simple math in the context =
of a conventional HDD 512 byte sector, which is 4096 bits.

If you have a URE, you have lost not 1 bit. You have lost 4096 bits. A =
loss of 4096 bits in 12.5TB (not 12.5TiB) is an error rate of 1 bit of =
error in 2.44^10 bits. That is a gross difference from published error =
rates.

And then explain how the manufacturer spec does not actually report the=
 URE in anything approaching "on average" terms, but *less than* 1 bit =
in 10^14. If you propose the manufacturers are incorrectly reporting th=
e error rate, realize you're basically accusing them of a rather massiv=
e fraud because less than 1 bit of error in X, is a significantly diffe=
rent thing than "on average" 1 bit of error in X. This could be up to, =
but not including, a full order magnitude higher error rate than the pu=
blished spec. It's not an insignificant difference.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
