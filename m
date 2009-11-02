From: Christian Pernegger <pernegger@gmail.com>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Mon, 2 Nov 2009 21:01:17 +0100
Message-ID: <bb145bd20911021201k3338621ax1d7eb123614685c7@mail.gmail.com>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
	 <bb145bd20910311259j7b2506c8v4e8907eb73598275@mail.gmail.com>
	 <cccedfc60911021139o7cac1ad2rb70333d5fc8026e6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60911021139o7cac1ad2rb70333d5fc8026e6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> With 4 disks, the ability to sustain *any two* devices going bad is a big bonus.
> Using raid10 with two copies (1 original, 1 duplicate) on 4 disks
> gives me 50% space but I can only sustain *1* failed device. I'm
> guessing I'd have to go with raid10 with three copies (1 original, 2
> duplicate) which is even worse (2/3 space lost). Did I just calculate
> that all wrong?

No. No, that's fine, I hadn't thought of the fact that raid6 survives
all 6 possible two disk failures while raid10 only survives 4.
Still, raid6 with 4 disks seems a bit pathological / corner-casey to
me and aside from that the md raid6 implementation is quite new. And
you'll need backups either way. Personally, I'd feel safer with
raid10. It's certainly faster.

Cheers,

C.

P.S.: About the only reason I can see to go with 4 disk raid6 is a
planned capacity expansion in the near future.
