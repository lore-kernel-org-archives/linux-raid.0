From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Feature request, resumable raid check action
Date: Sun, 4 Dec 2016 15:26:02 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1612041523030.4374@uplift.swm.pp.se>
References: <CAEtPA0Aosn6q0pJxsh69EpHQehiSsyeyVfJf98cDhu6kORkE1g@mail.gmail.com> <8737i76idm.fsf@notabene.neil.brown.name> <CAEtPA0C=xH0gCaigs-THNZRspmwD6d4WCrecjL-30M3PP0vxHw@mail.gmail.com> <87y3zy6evp.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y3zy6evp.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Patrick Dung <mpatdung@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2 Dec 2016, NeilBrown wrote:

> Did you reboot while it was running, or after it had finished its
> aloted time?
> You need to let it finish and record where it got up to.

I think he wants this "record where it got up to" when md-volumes are 
stopped when machine is rebooted, and then resumed again when machine 
starts up again.

I guess next question is where a change like this should go, into 
start/stop scripts, mdadm or the kernel?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
