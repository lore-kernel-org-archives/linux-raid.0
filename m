From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID 5 : recovery after failure
Date: Wed, 9 Oct 2013 08:54:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1310090853060.20065@uplift.swm.pp.se>
References: <CAPbD+Repm2SDpCGsR35QbW9Zq-MiCu1Fsdh4jjP_yESE3E3Exg@mail.gmail.com> <20131008210603.GA22876@cthulhu.home.robinhill.me.uk> <CAPbD+Re5TogdCTWabxoch77zzSRFfZhzuxAF=+UVn_ND2+R-3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPbD+Re5TogdCTWabxoch77zzSRFfZhzuxAF=+UVn_ND2+R-3w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 9 Oct 2013, Guillaume Betous wrote:

> I don't know where this "busy" message comes from : I have no mount nor 
> RAID service started.

"cat /proc/mdstat" says no md volume is in any state at all? This is 
usually the case when these busy messages are shown.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
