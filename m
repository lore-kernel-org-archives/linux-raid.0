From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid 5 crashed
Date: Fri, 3 Jun 2016 09:52:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1606030947180.28955@uplift.swm.pp.se>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com> <20160511131524.GA11811@cthulhu.home.robinhill.me.uk> <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com> <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
 <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com> <574C8EB9.3070706@youngman.org.uk> <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com> <574D958F.8060209@turmel.org> <574DDCBD.40801@youngman.org.uk>
 <95079572-f319-ca57-a3e9-e8d00ef40248@fnarfbargle.com> <CACsGCyQuPEXtgeW6QH-s_-eW9-SZ3J5s2s7CUzZRNemexTt3aw@mail.gmail.com> <20b1858b-0cd7-a7de-82af-9167dbcfb09e@fnarfbargle.com> <574F00F5.80801@youngman.org.uk> <2f3e2fe6-1810-e7bd-7dc0-483ed4f0d46b@fnarfbargle.com>
 <57503C3F.6020005@youngman.org.uk> <40b1ed1e-b0bd-a496-b5c8-6ad1f370b3ee@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40b1ed1e-b0bd-a496-b5c8-6ad1f370b3ee@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 3 Jun 2016, Brad Campbell wrote:

> If we took the bad block list from the dd_rescue, and fed it to hdparm 
> to create bad sectors in all those locations on the cloned disk, md 
> would get a bad sector on read and attempt a recovery rather than 
> returning zero, This would "in theory" cause a re-write of good data 
> back to that disk and minimise the chance of data loss.

Why would you use dd_rescue on a drive unless you're doing it because 
you're getting UREs on your remaining component drives on your degraded 
RAID5 so it won't complete resync? That's at least the most common 
use-case for ddrescue I've seen in md-raid scenarios.

> This might be a useful "last ditch" recovery method to allow you to 
> bring up an array with a cloned disk and minimise data loss. On the 
> other hand, lets say you are using it to bring up a RAID 5 with 2 failed 
> disks. One completely dead and one that you managed to clone most of. 
> When you extract the data from the running and degraded array, md will 
> pass the read error up the stack when it encounters the bad sectors, 
> allowing your copy or rsync session to log which files are affected as 
> you backup the remaining contents rather than just return silently 
> corrupted files.

This use case makes a lot more sense to me than the first one. Knowing 
what files are now bad would be very useful.

But wouldn't it be better to put the known errors in the new bad_blocks 
list in md that I believe is a fairly recent feature?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
