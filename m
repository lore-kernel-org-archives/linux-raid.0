From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Problem Syncing raid1
Date: Fri, 4 Apr 2014 16:17:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1404041613340.10236@uplift.swm.pp.se>
References: <BAY177-W404434C6EBAB450FA96A77C86D0@phx.gbl> <CADNH=7EwjLirv+zdUKu-Hsrw1djLNpPoz=WSg4pJwUc0giRzOw@mail.gmail.com> <BAY177-W961648C4893E888EECA18C86D0@phx.gbl> <CAK_KU4bh3S+rwMmJt4_8pyrOYbiLn83BHYabF79c4M59UoW1TA@mail.gmail.com>
 <BAY177-W35793297D3F640EF11F48C86D0@phx.gbl> <BAY177-W48FA7C4D5A92389BFC0667C86C0@phx.gbl> <CAK_KU4Z9ND2ivU-09qGSTsBAyVToNnUBAzwpGkQpY_M+khwcvg@mail.gmail.com> <alpine.DEB.2.02.1404041427350.10236@uplift.swm.pp.se>
 <CAK_KU4YnrP4O=JCPQsTxRrOT+nXMAraiMN+_T6W96ekHpPtsTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4YnrP4O=JCPQsTxRrOT+nXMAraiMN+_T6W96ekHpPtsTw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott D'Vileskis <sdvileskis@gmail.com>
Cc: Christian Schmitz <schnet@hotmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 4 Apr 2014, Scott D'Vileskis wrote:

> I apologize if my relatively simplistic summary of what may actually
> be happening left out the detail of pending sectors. In my
> understanding, during a SMART self test, if a problem is encountered
> and can be dealt with, it can probably handle the transition through
> pending sectors, without the user ever witnessing the pending sector
> count increase.
> How else does one explain increases in reallocated sector counts
> following a long self test?

I don't know, I have never seen this behavior. It might very well be that 
different vendors use different methods for the different scenarios. I 
would love to be able to talk to someone who actually works for a HDD 
manufacturer and has real first hand knowledge how things work, instead of 
what I usually see here (including myself) which is people trying to poke 
the black box and trying to figure out what might be going on inside from 
the scarce diagnostic tools available.

Personally I've never seen a pending sector go away without writing to it. 
Sometimes this write results in the reallocated count going up, sometimes 
it doesn't.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
