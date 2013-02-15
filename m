From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Fri, 15 Feb 2013 13:34:00 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302151327170.32644@uplift.swm.pp.se>
References: <20130214213908.282850@gmx.net> <alpine.DEB.2.00.1302151055500.32644@uplift.swm.pp.se> <511E1890.6060708@fnarfbargle.com> <alpine.DEB.2.00.1302151220060.32644@uplift.swm.pp.se> <511E263C.6070704@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511E263C.6070704@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 15 Feb 2013, Brad Campbell wrote:

> Please don't get me wrong. There is no nice way of protecting fools from 
> themselves short of revoking their license to breed, it's just from my 
> severely opinionated viewpoint that this looks like a sane idea. I'm quite 
> prepared to be slapped, and in fact probably need it.

Well, yes, it's a sane idea.

Right now it seems a significant part of new threads started on this list 
is about people doing --create --assume-clean with a different version of 
mdadm (so offset/chunk-size/whatever is wrong) or they have the wrong 
order. In order to help them, I believe the default behaviour of 
--zero-superblock without any additional flags, should be to give hdparm 
style message so that the user understands what is really going to happen, 
and when the superblocks are zeroed, a mdadm --examine and --detail (if 
the array is running) with a UUID/date should be saved somewhere.

The aim would be to drive two things:

People should think thrice about using --create --assume-clean. If they do 
(or do --zero-superblock), detailed information should be saved for the 
array and components before the operation was performed.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
