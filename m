From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: raid5+hotspare: request for recommended procedure
Date: Wed, 29 Sep 2010 08:39:28 -0700 (PDT)
Message-ID: <356617.98037.qm@web51306.mail.re2.yahoo.com>
References: <4CA3565A.8050802@xunil.at>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CA3565A.8050802@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, lists@xunil.at
List-Id: linux-raid.ids


--- On Wed, 29/9/10, Stefan G. Weichinger <lists@xunil.at> wrote:

> From: Stefan G. Weichinger <lists@xunil.at>
> Subject: Re: raid5+hotspare: request for recommended procedure
> To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
> Cc: Jon@eHardcastle.com, "Jon Hardcastle" <jd_hardcastle@yahoo.com>
> Date: Wednesday, 29 September, 2010, 16:08
> Am 2010-09-29 16:29, schrieb Jon
> Hardcastle:
> 
> > Personally I would trust nothing less than a dammed
> good thrashing 
> > from badblocks -svw ideally or -svn if the drive has
> data on it.
> > Then an smart offline check to be sure the
> pending/reallocated
> > sector counts have no increased.
> > 
> > Before commissioning a new drive a do a badblocks -svw
> atleast 3 
> > times without any counters increasing (something there
> are bad 
> > sectors I just want to flush them out early) then I do
> some short, 
> > long and offline smart tests.
> > 
> > Then I add to the array, then I run check a couple of
> times.
> 
> To be explicit:
> 
> This would mean to run "badblocks -svn" on md3 or sdb or
> sdb3 ?
> 
> just to make sure I understand you correctly ...
> 
> Does that step take long?
> 
> Stefan
> 

This step is run on the drives that form the array so sdb... and it can take a long time.. depends on how many times you run it through and how the drive is connected...


      
