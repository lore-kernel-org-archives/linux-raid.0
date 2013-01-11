From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Trouble adding disk to degraded array
Date: Fri, 11 Jan 2013 15:07:41 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301111505110.12098@uplift.swm.pp.se>
References: <CAJ=LqmbYG8H45M196ZuRcDMu9Ucz0t_pQenQbZtMKM9AhSqrpQ@mail.gmail.com> <CAJ=LqmasSo9WRmPAO6-RBE5N=zxg9vitWhdqcekbUO89oxKevA@mail.gmail.com> <50EDAF0A.7030903@turmel.org> <CAJ=LqmbKR1BczeFyGeQooDsPMf8PqriiD3z7i1_LjupGij5ewQ@mail.gmail.com>
 <50EDF030.2060502@smartguide.com.au> <CAJ=LqmZKXqn+nGt8=Rt8QS9S7pVS7qyEaN8Cbb91D7XETEvFug@mail.gmail.com> <CAJ=LqmaouLfjy6O=wSEaC600dsApWrGGPrc0Yqs25Mvbm+0Hdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ=LqmaouLfjy6O=wSEaC600dsApWrGGPrc0Yqs25Mvbm+0Hdw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicholas Ipsen <NCLI@NCLI-design.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 11 Jan 2013, Nicholas Ipsen wrote:

> Hello again. I manage to recover most of the data using ddrescue and
> various option, but I'm still left with 24576B missing. Of course,
> it's probably nothing major in terms of lost files, but I can't help
> but worry that it will cause issues when I add the replacement disk to
> the array. Do you have any advice regarding this problem?

Force an filesystem check. I don't see any problem with md-raid because of 
these zero:ed 24576 bytes, the only thing that will care is the 
filesystem.

If you want to be 100% sure, run a "check" action on the md raid and make 
sure you have no mismatches on the md layer.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
