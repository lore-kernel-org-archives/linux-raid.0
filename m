From: Matthias Urlichs <smurf@smurf.noris.de>
Subject: Re: RAID 16?
Date: Thu, 02 Feb 2006 17:17:05 +0100
Message-ID: <pan.2006.02.02.16.17.03.859560@smurf.noris.de>
References: <43E19FAB.4000603@cogweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, David Liontooth wrote:

> 
> We're wondering if it's possible to run the following --
> 
>   * define 4 pairs of RAID 1 with an 8-port 3ware 9500S card * the OS will
>   see these are four normal drives * use md to configure them into a RAID
>   6 array
> 
Hmm. You'd have eight disks, five(!) may fail at any time, giving you
two disks of capacity.

Ouch. That's not "very high" redundancy, that's "insane". ;-)

In your case, I'd install the eight disks as a straight 6-disk RAID6 with
two spares. Four disks may fail (just not within the time it takes to
reconstruct the array...), giving you four disks of capacity.

A net win, I'd say, esp. since it's far more likely that your two power
supplies will both die within the time you'd need to replace one.

But it's your call.

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
... Logically incoherent, semantically incomprehensible, and legally ...
impeccable!


