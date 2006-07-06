From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Can't get md array to shut down cleanly
Date: Thu, 6 Jul 2006 19:18:06 +0200
Message-ID: <bb145bd20607061018u3bf275ads6b602657867cb07d@mail.gmail.com>
References: <bb145bd20607060648p3776d335g55e4bdee4ecaf3c4@mail.gmail.com>
	 <20060706154658.GC13285@rigacci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060706154658.GC13285@rigacci.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> May be your shutdown script is doing "halt -h"? Halting the disk
> immediately without letting the RAID to settle to a clean state
> can be the cause?

I'm using Debian as well and my halt script has the fragment you posted.
Besides, shouldn't the array be marked clean at this point:

> md: stopping all md devices.

Apparently it isn't ... :

> md: md0 still in use.

If someone thinks it might make a difference I could remove everything
evms and create a "pure" md array with mdadm. (Directly on the disks
or on partitions? Which partition type?)

How does a "normal" shutdown look?

Will try 2.6.16 and 2.6.15 now ... the boring part is that I have to
wait for the resync to complete before the next test ...

Thank you,

C.
