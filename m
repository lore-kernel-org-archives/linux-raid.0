From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Accidental grow before add
Date: Sun, 26 Sep 2010 11:59:57 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1009261159120.28005@uplift.swm.pp.se>
References: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com> <AANLkTi=3MEirXZs_Qv7nO7fvAKxvErnkvAiEe8fdxQA=@mail.gmail.com> <AANLkTimPPD6TfoX7GVbaNgQo1CPpjc7LLG-nWDz7=En=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimPPD6TfoX7GVbaNgQo1CPpjc7LLG-nWDz7=En=@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 26 Sep 2010, Mike Hartman wrote:

> I've stopped /dev/md0 with "mdadm --stop /dev/md0" because I'm just
> too worried about what might happen to the array if another component
> mysteriously fails.

You need to start looking in dmesg / other logs to see what has happened 
and why things have failed. Without that information it's impossible to 
tell what's going on.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
