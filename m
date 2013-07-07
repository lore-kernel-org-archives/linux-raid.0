From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: question about the best suited RAID level/layout
Date: Sun, 07 Jul 2013 11:45:42 -0500
Message-ID: <51D99B36.6040106@hardwarefreak.com>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>  <51D5EC8A.40509@turmel.org> <1372978687.5249.52.camel@fermat.scientia.net>  <51D61D71.5090406@hardwarefreak.com>  <1373071585.5395.45.camel@fermat.scientia.net>  <51D7D72B.4070401@hardwarefreak.com> <1373123051.5217.19.camel@fermat.scientia.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373123051.5217.19.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/6/2013 10:04 AM, Christoph Anton Mitterer wrote:
> On Sat, 2013-07-06 at 03:36 -0500, Stan Hoeppner wrote:
>>>> hot/warm/cold spares in the chassis.
>>>>   This simply degrades performance.

>>> Why should it? If the spare is unused?
>> The answer is rather obvious.  If spares are in the chassis one has
>> fewer active array spindles.

> Sorry... still don't get it...

Maybe an example will help.  Is a 12 drive array faster than a 10 drive
array?  Yes, of course.  If your chassis holds 12 drives and you assign
two as spares, then you have 10 drives in your array.  That's 20%
slower.  If you keep spares on a shelf and hot swap them in after
failure, you can have all 12 drives in your array and not lose that 20%
performance.

...
> "It was agreed that WD would operate with WD Technologies and HGST as
> wholly owned subsidiaries and they would compete in the marketplace with
> separate brands and product lines."

I don't have the time, and this is not the appropriate forum, for me to
educated you WRT disk drive business...

> But the next sentence about Toshiba may indicate that HGST stops 3.5"
> business?!

You're confusing 3.5" with consumer.  HGST will still be producing 3.5"
enterprise SAS and SATA drives.  The transfer to Toshiba was limited to
consumer product.

>>> and Toshiba got something from the
>>> WD/HGST trade and already announced a 3.5" enterprise disk out of that.
>> Toshiba has been producing 3.5" enterprise drives for years.  Got a link
>> showing that Toshiba received technology from the WD/Hitachi acquisition?
> Again, see Wikipedia.

As I stated, Toshiba had already been producing 3.5" enterprise drives
for many years.  They had a tiny fraction of the consumer market as WD
and Seagate owned nearly all of it after Seagate's acquisition of
Maxtor.  Toshiba got a consumer line of drives out of this deal which is
what they needed.

The whole purpose of this divestiture was the FTC's goal of preventing
WD and Seagate from owning essentially the entire consumer disk drive
market.  They already had over ~80% of it worldwide between them.  WD
got what it wanted, which was Hitachi's enterprise disk drive line.  WD
has been trying for over a decade to crack the enterprise OEM nut and
was unable to do so, as Seagate, IBM/Hitachi, and Toshiba had it locked
up.  On day one after this acquisition, WD was selling enterprise drives
to the likes of EMC, Dell, HP, IBM, etc, customers they'd been trying to
grab for over a decade without success.

Hitachi's consumer drive biz was never serious competition to WD so they
lost little sleep when the FTC forced them to divest that product line.
 Again, they got what they wanted:  enterprise 15K, SAS, FC drives, and
an existing large OEM customer base for these products.

>> I already stated many of them.  You don't seem to be following along
>> very well.

> Well you only named one may need to use partitions (which I do not see
> why this should be a disadvantage)... and that in few years... there
> might be only some vendors left and (by then) the idea wouldn't work
> anymore; but even if that would happen, that's still no reason for not
> doing it now?

> Anything else I've missed or didn't understand as a disadvantage?

Well of course.  By designing your storage with dissimilar drives to
avoid a rare, show stopping, firmware bug that may or may not be present
in a specific drive model, you're simultaneously exposing yourself to
other issues because the firmware doesn't match.  Performance will be
suboptimal as your drives will have difference response times.

Additionally, timeout and error handling will likely be different,
causing the same.  Interpreting S.M.A.R.T. data will be difficult
because each of the drives will report various metrics differently, etc,
etc.  So instead of only being required to become intimately familiar
with one drive model, you must do so for 4 or 5 drive models.

In summary, in an attempt to avoid one specific potential rare problem
you create many other problems.  I'm not saying this strategy is
"wrong", I'm simply pointing out that it comes with its share of other
problems you'll have to deal with.

-- 
Stan

