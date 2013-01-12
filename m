From: Phil Turmel <philip@turmel.org>
Subject: Re: Trouble adding disk to degraded array
Date: Fri, 11 Jan 2013 19:24:30 -0500
Message-ID: <50F0AD3E.2040109@turmel.org>
References: <CAJ=LqmbYG8H45M196ZuRcDMu9Ucz0t_pQenQbZtMKM9AhSqrpQ@mail.gmail.com> <CAJ=LqmasSo9WRmPAO6-RBE5N=zxg9vitWhdqcekbUO89oxKevA@mail.gmail.com> <50EDAF0A.7030903@turmel.org> <CAJ=LqmbKR1BczeFyGeQooDsPMf8PqriiD3z7i1_LjupGij5ewQ@mail.gmail.com> <50EDF030.2060502@smartguide.com.au> <CAJ=LqmZKXqn+nGt8=Rt8QS9S7pVS7qyEaN8Cbb91D7XETEvFug@mail.gmail.com> <CAJ=LqmaouLfjy6O=wSEaC600dsApWrGGPrc0Yqs25Mvbm+0Hdw@mail.gmail.com> <alpine.DEB.2.00.1301111505110.12098@uplift.swm.pp.se> <CAJ=Lqma76UUcg154ChSW1e48ZxPCf8dG7WMNH6PpvQGYF_v7vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ=Lqma76UUcg154ChSW1e48ZxPCf8dG7WMNH6PpvQGYF_v7vw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicholas Ipsen <NCLI@ncli-design.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/11/2013 07:01 PM, Nicholas Ipsen wrote:
> Yikes, I may really have stepped in it with that filesystem check...

[trim /]

> Note that this is not the device that was giving me trouble before,
> nor is it the on I replaced it with.
> 
> What have I done wrong here?

Are you also getting errors from the controller/drive?

If so, you might have a hardware problem, like a power supply going bad
(writing draws significantly more power than reading).

Please post your latest complete dmesg.

Phil

