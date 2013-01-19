From: Maarten <maarten@ultratux.net>
Subject: Re: Suboptimal raid6 linear read speed
Date: Sun, 20 Jan 2013 00:51:33 +0100
Message-ID: <50FB3185.7060009@ultratux.net>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se> <50F90857.3010305@hardwarefreak.com> <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se> <50F9D32F.7090606@hardwarefreak.com> <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se> <50FB22D8.5000803@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50FB22D8.5000803@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/19/13 23:48, Stan Hoeppner wrote:
> On 1/19/2013 1:43 AM, Mikael Abrahamsson wrote:
>
>> With a BER of 10^-14 you have a 16% risk of getting URE when reading an
>> entire 2TB drive.
> On 1/19/2013 7:21 AM, Roy Sigurd Karlsbakk wrote:
>
>> ok, perhaps, maybe, but then it's 17% chance of losing data after a
>> mirror or raid-5 rebuild with 2TB drives...
> Where are you guys coming up with this 16-17% chance of URE on any
> single full read of this 2TB, 10E14 drive?  The URE rate here is 1 bit
> for every 12.5 trillion bytes.  Thus, statistically, one must read this
> drive more than 6 times to encounter a URE.  Given that, how is any
> single full read between the 1st and the 6th going to have a 16-17%
> chance of encountering a URE for that one full read?  That doesn't make
> sense.
Sorry but now I have to speak up too. Of course that 16-17% figure is
right! Did you miss out on math classes ? It is all statistics. There is
a chance of '1.0' to get one URE reading 12.5 TB. That URE may be
encountered at the very start of the first TB, or it may not come at
all, because that is how statistics work. But *on*average*, you'll get
1.0 URE per 12.5 TB, ergo, 0.16 per 2.0 TB. Basic simple math... jeez.

Can we now give it a rest? Or do I need to unsubscribe ?

Cheers,
Maarten

