From: Sarah Newman <srn@prgmr.com>
Subject: Re: Fwd: RAID6 Array crash during reshape.....now will not
 re-assemble.
Date: Thu, 3 Mar 2016 09:48:24 -0800
Message-ID: <56D878E8.1060409@prgmr.com>
References: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
 <56D6E883.50801@youngman.org.uk>
 <CAOS+5GHof=F94x58SKqFojV26hGpDSLF85dFfm8Xc6M43sN6jA@mail.gmail.com>
 <CAOS+5GEfQ2p0xguguKC3uXW8GYBDCxt2vk=-Ci6+nTKwkcWtdQ@mail.gmail.com>
 <CAOS+5GGX8QBo3=s+Mcj=Kd6VSmZyatfZ30NXBy8E=4WJE6z0sA@mail.gmail.com>
 <CAOS+5GGB5gVSFJbYwwJu+z0C0oyYPzsLRhnjD6FkmLEWFFquFA@mail.gmail.com>
 <56D8348E.9070802@youngman.org.uk>
 <CAOS+5GH1Rcu8zGk1dQ+aSNmVzjo=irH65KfPuq1ZGruzqX_=vg@mail.gmail.com>
 <CAOS+5GHUKD63M90zWfiv14QkJunj2QF+gYqDMrg208-S4oXE2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GHUKD63M90zWfiv14QkJunj2QF+gYqDMrg208-S4oXE2Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/03/2016 06:07 AM, Another Sillyname wrote:
> Plenty of hits....but no clear fixes and as I said I'm not willing to
> 'try' things from google hits until someone with better insight can
> give me a view.
> 
> Trying things is fine in many instances, but not with a 20+TB data set
> as I'm sure you can understand.
> 

I have not tried this personally, but it may be of interest:
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file I found this explanation
of the dmsetup commands to be more easy to follow: http://www.flaterco.com/kb/sandbox.html

