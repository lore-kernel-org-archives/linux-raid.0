From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Busted disks caused healthy ones to fail
Date: Wed, 15 Dec 2004 00:04:20 -0500
Message-ID: <200412150504.iBF54P912209@www.watkins-home.com>
References: <41BFC19E.2020906@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41BFC19E.2020906@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Brad Campbell' <brad@wasp.net.au>, 'Jim Paris' <jim@jtan.com>
Cc: comsatcat@earthlink.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maxtor drives....and no problems....You must be crazy!  :)

Well then, uh, it could...., humm....  That only leaves crazy!  :)

I give up!  You defended yourself well.  I have no idea.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
Sent: Tuesday, December 14, 2004 11:46 PM
To: Jim Paris
Cc: Guy; comsatcat@earthlink.net; linux-raid@vger.kernel.org
Subject: Re: Busted disks caused healthy ones to fail

Jim Paris wrote:
>>It's not that hard.
>>I have 4 drives loaded in the rear bays and 2 x 5 Way SATA Hotswap bays in

>>the 6 front 5.25 inch bays. 14 Drives. And yes, they are on a single 420w 
>>PSU along with the motherboard, Athlon XP 2600+. and 5 80mm fans. Not much

>>else though.
> 
> 
> !!!!!!  Holy crap!
> 
> Let's pick a random typical hard drive, a Seagate 120GB SATA:
> http://www.mittoni.com.au/catalog/product_info.php/products_id/1690
> It lists maximum current draw as 2.8 A on the +12V line.
> Multiply that by 14 drives and we get __39.2 amps__.

Now, lets actually pick my hard drives shall we?

Max current draw on the 12v line is 1.56A at spinup, dropping to 600mA at
seek and 556mA at Idle.

So _worst_ case is 21.84A for about 2 seconds (which does actually exceed
the PSU ratings by nearly 
3 amps). This machine only gets power cycled about once every three months
and I did actually 
monitor the 12V rail with a CRO to check specs and ripple and they never
budged.

Worst case running load is 8.4A which leaves ~10A on my 12V rail for my
motherboard. Ample.


> Now let's pick a random 420W power supply:
>
http://www.newegg.com/app/viewproductdesc.asp?submit=Go&description=N82E1681
7103445
> Note how it's +12V output is rated for only __15 amps__.

Now lets pick my power supply http://www.wasp.net.au/~brad/p1000256.jpg

So yes, on spinup I'm exceeding my 12V rail by 3 Amps for about 1.5 Seconds
(Which this supply has 
amply proven capable of handling). Outside that I don't see an issue.

> Your numbers might differ a bit.  But it is NO surprise that your
> drives are failing.  The surprising part is that they and your power
> supply have worked this long.

I never said anything about failing disks! In fact, if you check back you
will see me commenting I 
have a bucket load of Maxtor Maxline-II drives in there that have been
flawless to date. (In fact I 
have just ordered 25 more, 15 for me and 10 for a mate. That should increase
the sample a little) 
They all sit at below 40 Degrees C and the PSU remains quite cool. (I'm an
electronic technician by 
trade and have several thermocouples I use to verify measurements).

Here is the reason the drives stay nice and cool.
http://www.wasp.net.au/~brad/p1000250.jpg

-- 
Brad
                    /"\
Save the Forests   \ /     ASCII RIBBON CAMPAIGN
Burn a Greenie.     X      AGAINST HTML MAIL
                    / \
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

