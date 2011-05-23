From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 06:21:50 -0500
Message-ID: <4DDA434E.0@hardwarefreak.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com> <4DD99FF2.2030609@fnarfbargle.com> <4DDA2FD9.3020303@hardwarefreak.com> <4DDA37F5.1000003@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDA37F5.1000003@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/23/2011 5:33 AM, Ed W wrote:

> If the cheap WD drives weren't the main issue then perhaps at least this
> example shouldn't be used as an example of why NOT to use those drives?

On the contrary, it's the *perfect* example.  A system's reliability is
no greater than that of the least reliable component.  The fact that WD
Green drives are so cheap dictates that anyone using them in a RAID
setup is going to use a cheap backplane or individual hot swap carriers.
 There is zero doubt here.  No one will buy a $1500 *empty* HP hot swap
JBOD chassis/backplane and then slap 14 x $80 = $1120 of WD 2TB Green
drives in it.

The soundness of design, manufacturing, and QC of cheap backplanes and
drive carriers is quite low in many/most cases.  Traces not routed
properly on a backplane PCB can generate timing skew or not reject
noise.  This can cause excessive CRC errors on the link, causing the
drive to be kicked off line.  This but one possible flaw that shows up
regularly in cheap backplanes and individual carriers.  The absolute
worst are cheap *active* backplanes.  These are the units with SAS/SATA
expanders on the PCB and/or I2C chips.  If you go cheap on your
backplane, you probably want to make sure you get a passive unit.

>> Either way, cheap
>> not-fit-for-RAID drives were stuffed into a cheap RAID box and disaster
>> was the result.
> 
> But likely due to what boils down to "cables falling out" is what you
> seem to be guessing?

No.  I'm saying he purchased a low ball solution and got low quality.
Some component puked momentarily and he lost a lot of data because on
top of that, he didn't know wtf he was doing and wiped the disks that
were actually ok.  We don't know exactly what caused the problem.  Root
cause analysis was never performed, or, if it was, it was never made
public.  I'm guessing the former.  The type of people who do root cause
analysis typically don't buy low ball gear.

>> WDC
>> itself says not to use the Green drives in RAID arrays. 
> 
> The problem with taking the manufacturers word on this is that they
> provide two products and claim one is "good enough" and that the other
> "lasts way longer", and then price them quite significantly differently

Welcome to the real world.  Been this way a long time.  Why do you think
health care in America is so expensive?  Because the same probe that is
sold to vets to be stuck up a horses ass is the same one sold for human
application.  Horses aren't litigious, but humans are.  That's one
reason why the same ass probe sold for human use costs 300 times more.
One is charged for the intended use of many products today, not
necessarily the capabilities of the product.  AMD builds both the Phenom
and Opteron on the same line, both chips are identical until the last
phase of production.  There, one of two (can't recall exactly) of the HT
links are disabled to make a Phenom, and you pay twice as much for the
Opteron.  Same chip, different "intended uses".  They gouge the business
customer because they know they can.  I'm a huge AMD fan, so please
don't think I'm down on them.  EVERYONE in business does this, Intel,
WDC, Seagate, the lot of them.

> Now, without even looking inside the two identical metal chassis, you
> have to admit: a) there is incentive for them to tell fibs here in order
> to gain a price premium and b) given the "reliable" drives are roughly
> twice the cost then there should be sufficient extra engineering in
> there that we can look for third party documentation, patents and other
> supplemental information to learn more about what that engineering is
> and gain confidence that the money is well spent?

I don't think they tout them necessarily as being more reliable, but
more capable or "compatible" in certain applications.  Drives used in
hardware RAIDs need TLER and some other specific firmware tweaks.  The
mechanicals of most "enterprise" SATA drives are shared with a number of
consumer counterarts.  Just different firmware and sticker color on the
top plate.

-- 
Stan
