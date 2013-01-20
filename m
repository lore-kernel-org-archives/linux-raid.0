From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Suboptimal raid6 linear read speed
Date: Sun, 20 Jan 2013 02:44:12 -0700
Message-ID: <EA019A09-5DD6-463C-8331-F7BDCDA66F80@colorremedies.com>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se> <50F90857.3010305@hardwarefreak.com> <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se> <50F9D32F.7090606@hardwarefreak.com> <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se> <50FB22D8.5000803@hardwarefreak.com> <50FB3185.7060009@ultratux.net> <6675858F-43FC-48CE-B146-856F50481289@colorremedies.com> <50FB3F34.3000302@ultratux.net>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50FB3F34.3000302@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 19, 2013, at 5:49 PM, Maarten <maarten@ultratux.net> wrote:

> On 01/20/13 01:16, Chris Murphy wrote:
>> 
>> And then explain how the manufacturer spec does not actually report the URE in anything approaching "on average" terms, but *less than* 1 bit in 10^14. If you propose the manufacturers are incorrectly reporting the error rate, realize you're basically accusing them of a rather massive fraud because less than 1 bit of error in X, is a significantly different thing than "on average" 1 bit of error in X. This could be up to, but not including, a full order magnitude higher error rate than the published spec. It's not an insignificant difference.
> 
> All very nice, but that is not the point, is it.

It is the point. You stated simple math and yet the math appears to be wrong and you haven't explained otherwise.

> The point is, to
> calculate (or rather: estimate) the odds of an URE encounter when
> reading 2TB, based on the figure one has for reading 12,5 TB. Whether
> that 12,5 figure is correct or not, whether endorsed by manufacturers or
> not, is totally irrelevant.  It simply boils down to, if there are 10
> X's in every 10G Y's, then there are 2 X's in every 2G Y's. Yes ?

So when in doubt just change the entire argument? That's absurd.

What is a bit?
What is a URE?
How much data, in bits, is lost when a URE occurs?
How often does a URE occur?


Chris Murphy