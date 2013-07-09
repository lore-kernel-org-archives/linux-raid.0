From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: question about the best suited RAID level/layout
Date: Tue, 09 Jul 2013 10:50:04 -0500
Message-ID: <51DC312C.6070503@hardwarefreak.com>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>  <51D5EC8A.40509@turmel.org> <1372978687.5249.52.camel@fermat.scientia.net>  <51D61D71.5090406@hardwarefreak.com>  <1373071585.5395.45.camel@fermat.scientia.net>  <51D7D72B.4070401@hardwarefreak.com>  <1373123051.5217.19.camel@fermat.scientia.net>  <51D99B36.6040106@hardwarefreak.com> <1373217980.5246.9.camel@fermat.scientia.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373217980.5246.9.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/7/2013 12:26 PM, Christoph Anton Mitterer wrote:
> On Sun, 2013-07-07 at 11:45 -0500, Stan Hoeppner wrote:
>> Maybe an example will help.  Is a 12 drive array faster than a 10 drive
>> array?  Yes, of course.  If your chassis holds 12 drives and you assign
>> two as spares, then you have 10 drives in your array.  That's 20%
>> slower.  If you keep spares on a shelf and hot swap them in after
>> failure, you can have all 12 drives in your array and not lose that 20%
>> performance.

> Ah... okay I see what you were talking about ... sure... 

> but it's not
> the hot swap that will (directly) degrade performance...  

You seem to be having significant trouble parsing/digesting the
information given to you.  I didn't state, nor suggest, nor imply that
hot swap degrades performance.  Not sure how you ended up with this
idea.  I'll chalk it up to lack of knowledge/experience.

> ist because you
> don't use all your slots and thereby not getting out the maxmimum
> performance gain possible due to the striping...

Yes.  I stated this twice now.  Glad you finally got it. ;)

>> Well of course.  By designing your storage with dissimilar drives to
>> avoid a rare, show stopping, firmware bug that may or may not be present
>> in a specific drive model, you're simultaneously exposing yourself to
>> other issues because the firmware doesn't match.  Performance will be
>> suboptimal as your drives will have difference response times.

> Sure, but as said performance isn't the main goal...

It would benefit you greatly if you'd stop rebutting the information
presented to you, digest the information, commit it to memory, and use
it or not, now or in the future.  I am not a salesman trying to convince
you to use one method or another.  I am a teacher presenting you with
both pros and cons of multiple configuration options.  There is no need
for argument or rebuttal here.

>> Additionally, timeout and error handling will likely be different,
>> causing the same.  Interpreting S.M.A.R.T. data will be difficult
>> because each of the drives will report various metrics differently, etc,
>> etc.  So instead of only being required to become intimately familiar
>> with one drive model, you must do so for 4 or 5 drive models.

> Sure..

You're discounting expert insight out of hand because it doesn't agree
with your predisposition, and you are being adversarial with those
presenting conflicting information.  You're acting a bit like the
immature Kim Jong-un, but you are presumably unable to have those who
disagree with you executed or imprisoned.  Thankfully.

-- 
Stan

