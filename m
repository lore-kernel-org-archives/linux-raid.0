From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Western Digital Green 3TB SATA3 experiences
Date: Fri, 22 Mar 2013 10:57:21 -0600
Message-ID: <F21277E6-0F6B-4FA4-9DFC-554A3B58A0AB@colorremedies.com>
References: <32413553.16.1363962140126.JavaMail.root@zimbra>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <32413553.16.1363962140126.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 22, 2013, at 8:22 AM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:

> ----- Opprinnelig melding -----
>> On Mar 21, 2013, at 10:17 AM, Roy Sigurd Karlsbakk <roy@karlsbakk.net>
>> wrote:
>>> 
>>> This is true. The only real difference between the blacks and the
>>> 'enterprise' drives, is that the firmware isn't crippled.
>> 
>> No, another difference is the RE drives have another order magnitude
>> lower URE. So they're statistically more reliable. And they don't have
>> the implicit proscription to not use them in RAID other than 1 and 0.
> 
> They have a *reported* order of magnitude lower URE, but I'm not sure if that's *real*.

It's a statistically derived spec, and that's much more reliable than reality.

If you were to do a real test to find out, it would take for fricking ever, it would be really expensive, and it would collect noisy data such that two independent studies wouldn't exactly agree with each other. You'd have to do it on a large population of drives, because drives are obviously not exactly identical. The spec applies to a population of the model, not a particular unit. And since the real test would have to be done over the service life of the drive model, the study results wouldn't be available for ~5 years after the ship date of an enterprise drive model.

So what's real?

There are all sorts of ways to reliably predict the failure of various parts in a product, and how that affects the whole theoretical unit and thus the model. When those predictions are found to be flawed, the statistical model is used to see if and what revisions the product needs to maintain its design specs, including the URE spec.

The whole point of the URE isn't about what will happen to a particular drive. It's a reflection of a model population. Clearly, unrecoverable read error is rather massive with a totally dead drive.


Chris Murphy