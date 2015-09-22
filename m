From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Guidance on reshape stuck at 0% after --grow
Date: Tue, 22 Sep 2015 12:29:42 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1509221224470.8750@uplift.swm.pp.se>
References: <CAKWBTuFk4Tz20B4aZHgPF3FoEYXDqwQeKeAwN3Nt-cSAopUQ0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKWBTuFk4Tz20B4aZHgPF3FoEYXDqwQeKeAwN3Nt-cSAopUQ0Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Paumier <guillaume.paumier@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 21 Sep 2015, Guillaume Paumier wrote:

> I'm looking for guidance regarding what to do next. I'm not sure
> whether I should wait longer (how long?), or try to re-assemble the
> seemingly-intact original array (how do I stop/restart the reshape
> cleanly?), or something else. Any advice would be greatly appreciated.

You're not the first one here with this problem.

I can't find it right now, but I believe someone issued --grow --continue 
on the array to get it out of the state that you have right now.

I don't know if it's this:

http://www.spinics.net/lists/raid/msg49077.html

I do not recommend a reboot or anything else, others have had problems 
with this. Also make sure you collect as much information as possible, 
mdadm --examine, copy the superblocks in binary form using dd to somewhere 
etc, so you can get back to the state where you are now.

Look through the mailing list archives from the past 6 months, you're not 
alone in having this problem.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
