From: Michael <michael@rw23.de>
Subject: Re: =?UTF-8?Q?Slow=28=3F=29=20raid=35=20to=20raid=36=20reshape=20speed?=
Date: Tue, 16 Feb 2010 14:31:23 +0100
Message-ID: <40406f373328e5e0bc56a2faab153086@rw23.de>
References: <ee1fb9c4204eafc9daffb4341d0de646@rw23.de> <alpine.DEB.1.10.1002161251570.4986@uplift.swm.pp.se> <afb99b76feb4fad30a4f43fb46ea3e4d@rw23.de> <alpine.DEB.1.10.1002161334170.4986@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1002161334170.4986@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

it already is and was all the time:

[root@raw ~]cat /sys/block/md2/md/sync_speed_*
200000 (system)
200000 (local)

so that's not the limit. any other ideas?

On Tue, 16 Feb 2010 13:34:36 +0100 (CET), Mikael Abrahamsson
<swmike@swm.pp.se> wrote:
> On Tue, 16 Feb 2010, Michael wrote:
> 
>> so this is not 100%, right?
> 
> I'd increase speed_min more.
