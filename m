From: Ed W <lists@wildgooses.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 11:33:25 +0100
Message-ID: <4DDA37F5.1000003@wildgooses.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com> <4DD99FF2.2030609@fnarfbargle.com> <4DDA2FD9.3020303@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDA2FD9.3020303@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/05/2011 10:58, Stan Hoeppner wrote:
> Multiple drives definitely went offline, but I doubt
> it's due to a real RAID ASIC with custom firmware and a TLER issue.
> More likely, given the price, it was a backplane signal quality problem,
> for which cheap backplanes are notorious.

I think we shouldn't bang this one to death any further, but your
statement above could be interpreted that whilst the drives may not be
ideal, likely they weren't the issue in this case?

If the cheap WD drives weren't the main issue then perhaps at least this
example shouldn't be used as an example of why NOT to use those drives?


> Either way, cheap
> not-fit-for-RAID drives were stuffed into a cheap RAID box and disaster
> was the result.

But likely due to what boils down to "cables falling out" is what you
seem to be guessing?


> WDC
> itself says not to use the Green drives in RAID arrays. 

The problem with taking the manufacturers word on this is that they
provide two products and claim one is "good enough" and that the other
"lasts way longer", and then price them quite significantly differently

Now, without even looking inside the two identical metal chassis, you
have to admit: a) there is incentive for them to tell fibs here in order
to gain a price premium and b) given the "reliable" drives are roughly
twice the cost then there should be sufficient extra engineering in
there that we can look for third party documentation, patents and other
supplemental information to learn more about what that engineering is
and gain confidence that the money is well spent?

I guess you have two near equal priced options:

a) 12 disk RAID6 using "enterprise" drives
b) 12x 2 disk RAID 1, plus 12x RAID6 on the top of that (some variant of
RAID61 basically)

Does having twice the number of "cheap" drives make the thing more or
less reliable?  (More drives = higher probability of individual drive
failing, but additional redundancy decreases chance of total loss).  I
need to crank some numbers in excel to try and get my head around which
is better for a given failure probability

Cheers

Ed W
