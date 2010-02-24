From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Wed, 24 Feb 2010 18:28:54 +0100
Message-ID: <4B8561D6.3020106@xunil.at>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at> <20100224152228.GB11039@cthulhu.home.robinhill.me.uk> <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at> <4B855987.1010605@xunil.at> <20100224170951.GC11039@cthulhu.home.robinhill.me.uk>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100224170951.GC11039@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 24.02.2010 18:09, schrieb Robin Hill:

> It's degraded because you only have 2 disks in the array, presumably the
> event count on the other disks doesn't match up.  If you've replaced sdc
> and sdd never got rebuilt onto, then you only have the two disks
> available for the array anyway.

Yep.

> If these are the only disks with up-to-date data, and sda4 is still
> failing, I can only suggest stopping the array and using dd/dd_rescue to
> copy sda4 onto a working disk.  You should then be able to reassemble
> the array with sdb4 and the new disk, then add in a hot spare to
> recover.

OK, that's plan B. For now I try to get data aside.

md4 is a PV in an LVM-VG ... the main data-LV seems to trigger the
errors, but another LV seems more stable (other sectors or something).

This other LV contains rsnapshots of the main data-LV ... so if I am
lucky I only lose about 2hrs of work if I get the latest snapshot
copied. rsync is down to character "s" already ........

For sure there's a third LV as well, containing VMware-VMs ... oh my.

Let's pray this one is OK as well, at least while copying stuff.

> Alternately, bite the bullet, recreate the array and restore.

hmm

> Either way, it looks like you ought to be running regular checks on the
> array to try to pick up/fix these background failures.

smartd lead me to the failing sdc ... no note of sda though ...

A bad taste after all.

Thanks anyway, Stefan
