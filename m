From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: Why does one get mismatches?
Date: Wed, 20 Jan 2010 15:01:37 -0800
Message-ID: <7bc80d501001201501o41eb194fgae8b3d40d8c48f0e@mail.gmail.com>
References: <387070.15704.qm@web51305.mail.re2.yahoo.com>
	 <hj77p7$rsr$1@ger.gmane.org>
	 <70ed7c3e1001201244k3c734336y8e145bb50f88de26@mail.gmail.com>
	 <hj7vta$nvq$1@ger.gmane.org>
	 <70ed7c3e1001201430i72023a9fq1341b671073ac53c@mail.gmail.com>
	 <hj80v1$rap$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hj80v1$rap$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brett Russ <bruss@netezza.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I keep misreading the the subject of this email thread as:

"Why does one get mustaches?"

cc

On Wed, Jan 20, 2010 at 2:43 PM, Brett Russ <bruss@netezza.com> wrote:
> On 01/20/2010 05:30 PM, Majed B. wrote:
>>
>> He needs to run a full offline or long test before checking with
>> smartctl -a -- since it won't show any sector errors if those tests
>> weren't run at least once.
>
> Not sure I agree with that. =A0The md checks he's been doing will cau=
se a read
> of all data regions of the relevant partition and if the disk is thro=
wing
> errors, those sectors should be marked probational. =A0Then, if a sub=
sequent
> repair ends up remapping them, those sectors will show up as remapped=
=2E
>
> The grep will show both probational and remapped sector counts for ea=
ch
> drive.
>
> BTW, the cmd should also include an echo so it's easy to tell which d=
rive is
> being reported:
>
> for di in a b c d e f g; do echo $di; smartctl -a /dev/sd$di | grep -=
i
> _sect; done
>
> -BR
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Chris Chen <muffaleta@gmail.com>
"The fact that yours is better than anyone else's
is not a guarantee that it's any good."
-- Motivational Poster
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
