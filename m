From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: superfluous md_wakeup_thread()
Date: Thu, 29 Jan 2015 10:07:27 -0500
Message-ID: <wrfj7fw54ocw.fsf@ultrasam.lan.trained-monkey.org>
References: <wrfjmw5s51gk.fsf@redhat.com>
	<20150129142816.32b1f7dc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150129142816.32b1f7dc@notabene.brown> (NeilBrown's message of
	"Thu, 29 Jan 2015 14:28:16 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
>> Is there a reason to wake the thread twice?
>
> Nope.  No reason at all.  Clearly I need to find a way to get people to
> review my patches *before* I commit them....
> Maybe I should try posting them to the list more :-)
>
> Would you like to send a patch to revert that pointless change?
>
> Thanks,
> NeilBrown

Ah phew, so I didn't lose my last marbles ... I read over it a couple of
times and I was sure you had a reason, but I just couldn't figure out
why :)

I'll send you a patch!

Cheers,
Jes
