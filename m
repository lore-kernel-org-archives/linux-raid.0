From: Niobos <niobos@dest-unreach.be>
Subject: Re: List of mismatched blocks?
Date: Mon, 05 Jul 2010 12:16:01 +0200
Message-ID: <i0sbd1$upv$1@dough.gmane.org>
References: <i0nr7l$jge$1@dough.gmane.org> <slrni2vate.mgo.Mario.Holbe@darkside.dyn.samba-tng.org> <i0pn2r$nir$1@dough.gmane.org> <slrni31knc.mgo.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrni31knc.mgo.Mario.Holbe@darkside.dyn.samba-tng.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2010-07-04 20:29, Mario 'BitKoenig' Holbe wrote:
> Niobos <niobos@dest-unreach.be> wrote:
>> I'm running cmp on an active RAID. My guess is that this cause a large
>> number of false positives: cmp reading both members at a different time,
>> and hence reading a different version. That was the main reason to ask
>> for another way to get the mismatching blocks through the raid-layer.

> On high-frequent changes this can unfortunately happen with RAID1 due to
> the handling of dirty pages (there's a thread back in 2k6 here on the
> list where Heinz Mauelshagen explained this quite nice - somewhere below
> the Subject: No syncing after crash. Is this a software raid bug?).
> I didn't notice it anymore since >2.6.26, so I thought it was fixed, but
> this could also be because the probability shrunk due to new hardware.
> 
>> I'm running cmp on an active RAID. My guess is that this cause a large
>> number of false positives: cmp reading both members at a different time,
>> and hence reading a different version. That was the main reason to ask
> 
> Not very likely unless your filesystem is under very high load. To be
> more specific: I did cmp -l my mirrors regularly before the "check"
> sync_action had been developed (and still do it from time to time -
> never trust... :)) and never experienced such things.

I just did 5 cmp's sequentially, with minutes in between them:

-rw-r--r-- 1 root  root      15016204 2010-07-05 09:18 sd[ab]1.1.diff
-rw-r--r-- 1 root  root      21404544 2010-07-05 09:49 sd[ab]1.2.diff
-rw-r--r-- 1 root  root      40538120 2010-07-05 09:54 sd[ab]1.3.diff
-rw-r--r-- 1 root  root     415879184 2010-07-05 10:39 sd[ab]1.4.diff
-rw-r--r-- 1 root  root      24811696 2010-07-05 11:45 sd[ab]1.5.diff

From the output-size alone, one can see that something is not working as
described. There are millions of bytes that mismatched at 10:39, that
magically were "fixed" an hour later...
I'm not sure how to quantify "very heavy filesystem load", but I don't
thing it is.

thanks,
Niobos

