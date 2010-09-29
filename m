From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: raid5+hotspare: request for recommended procedure
Date: Wed, 29 Sep 2010 17:08:10 +0200
Message-ID: <4CA3565A.8050802@xunil.at>
References: <285938.34612.qm@web51302.mail.re2.yahoo.com>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <285938.34612.qm@web51302.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: Jon@eHardcastle.com, Jon Hardcastle <jd_hardcastle@yahoo.com>
List-Id: linux-raid.ids

Am 2010-09-29 16:29, schrieb Jon Hardcastle:

> Personally I would trust nothing less than a dammed good thrashing 
> from badblocks -svw ideally or -svn if the drive has data on it.
> Then an smart offline check to be sure the pending/reallocated
> sector counts have no increased.
> 
> Before commissioning a new drive a do a badblocks -svw atleast 3 
> times without any counters increasing (something there are bad 
> sectors I just want to flush them out early) then I do some short, 
> long and offline smart tests.
> 
> Then I add to the array, then I run check a couple of times.

To be explicit:

This would mean to run "badblocks -svn" on md3 or sdb or sdb3 ?

just to make sure I understand you correctly ...

Does that step take long?

Stefan
