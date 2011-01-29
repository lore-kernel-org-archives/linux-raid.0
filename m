From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid over ethernet
Date: Sat, 29 Jan 2011 07:42:38 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 28 Jan 2011, Roberto Spadim wrote:

> hi guys, i was thinking about raid over ethernet... there's a solution
> to make a syncronous replica of my filesystem? no problem if my
> primary server get down, i can mout my replica fsck it and continue
> with available data
> i was reading about nbd, anyone have more ideas?

Look into AoE (ATA over Ethernet).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
