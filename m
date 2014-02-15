From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID6 dead on the water after Controller failure
Date: Sun, 16 Feb 2014 00:04:13 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1402160001340.14422@uplift.swm.pp.se>
References: <7A417EAE-106E-4541-941F-1002696F8735@gmail.com> <52FE7E2D.8020308@turmel.org> <5269CCC7-A0A7-479E-9738-88C74CB19435@gmail.com> <52FF83F1.3030904@turmel.org> <CAKuK5J0jxUUvkAY-U2Q6v5j9hf_nasOQOjvFGe+ThYaDFRt7yA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKuK5J0jxUUvkAY-U2Q6v5j9hf_nasOQOjvFGe+ThYaDFRt7yA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Phil Turmel <philip@turmel.org>, Florian Lampel <florian.lampel@gmail.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 15 Feb 2014, Jon Nelson wrote:

> Out of 12 drives, I thought RAID6 only offered a total of *2* failed 
> devices. It seems to me that you have 7 devices in sync and 4 *almost* 
> in sync. It's this "almost" part that has me confused. How can the raid 
> run if the event count doesn't match? Wouldn't at least 10 out of 12 
> drives have to have the same event count to avoid data loss?

Correct. When you use --assemble --force you're basically telling mdadm "I 
know what I'm doing and I'll take the risk of data loss or corruption". If 
you assemble in with a kicked drive that was kicked long ago that has a 
really far off event count, you can really really screw things up.

Unless you use --force, mdadm won't assemble an array where the event 
count doesn't match up.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
