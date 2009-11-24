From: Igor Podlesny <for.poige+linux@gmail.com>
Subject: Re: Now [...] it is possible for raid5d to distribute stripe handling
	over multiple cores.
Date: Wed, 25 Nov 2009 03:56:10 +0700
Message-ID: <43d009740911241256w36e7908cxc9a5211253ee73ba@mail.gmail.com>
References: <43d009740911240952m5aa9aa5bp229705b5fda4f399@mail.gmail.com>
	<20091125074700.7b0f0989@notabene.brown>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091125074700.7b0f0989@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/11/25 Neil Brown <neilb@suse.de>:
> On Wed, 25 Nov 2009 00:52:06 +0700
[...]
> Worst case is that performance falls through the floor, or becomes
> very unpredictable, or possibly even hangs your machine (though that is
> unlikely).
> There is no reason to expect that enabling this config option will have
> any effect on data integrity.

    Ok, so, it's a pity, but for the current state of things one can't
expect any goodness from RAID being "more SMP".

> If you do experiment, please post your results.

    Sure (if).

-- 
End of message. Next message?
