From: Joe Landman <joe.landman@gmail.com>
Subject: Re: high throughput storage server?
Date: Tue, 01 Mar 2011 23:20:21 -0500
Message-ID: <4D6DC585.90304@gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>	<20110215044434.GA9186@septictank.raw-sewage.fake>	<4D6AC288.20101@wildgooses.com> <AANLkTinjPJJrUYrA=fxcau02Q+4Z67YVsJhcGxeTpAAW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinjPJJrUYrA=fxcau02Q+4Z67YVsJhcGxeTpAAW@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Ed W <lists@wildgooses.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/01/2011 10:44 PM, Matt Garman wrote:

[...]


> That might be workable, but it would require me (or someone) to
> develop and deploy the job dispatching system.  Which is certainly

Happily, the "develop" part of this is already done.  Have a look at 
GridEngine, Torque, slurm, and a number of others (commercial versions 
include the excellent LSF from Platform, PBSpro by Altair, and others).

> doable, but it might meet some "political" resistance.  My boss
> basically said, "find a system to buy or spec out a system to build
> that meets [the requirements I've mentioned in this and other
> emails]."

This is wandering outside of the MD list focus.  You might want to speak 
with other folks on the Beowulf list, among others.

I should note that nothing you've brought up isn't a solvable problem. 
You simply have some additional data to gather on the apps, some costs 
to compare against the benefits they bring, and make decisions from 
there.  Build vs buy is one of the critical ones, but as Ed, myself and 
others have noted, you do need more detail to make sure you don't 
under(over) spec the design for the near/mid/far term.

Regards,

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
