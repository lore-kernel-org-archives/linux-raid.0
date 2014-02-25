From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: feature re-quest for "re-write"
Date: Tue, 25 Feb 2014 10:26:05 +0800
Message-ID: <530BFF3D.8000400@fnarfbargle.com>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>	<530AAD64.4030701@fnarfbargle.com> <20140225131017.6e71fa5a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140225131017.6e71fa5a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/02/14 10:10, NeilBrown wrote:

> This code is obviously too subtle.

Not at all, it's my understanding that is under-developed. I was just 
looking for something obvious to explain the behaviour others have been 
reporting where a check won't trigger a re-write of a pending sector if 
the sector is a p or q rather than data.

> If 0 drives have failed, then 's->failed' is 0 (it is the count of failed
> drives), and  's->q_failed' is also 0 (it is a boolean flag, and q clearly
> hasn't failed as nothing has).
> So the first 'if' branch will be followed (as "0 == 0") and check_state set to
> check_state_run.
> Then as q_failed is still 0 and failed < 2, check_state gets set to
> check_state_run_pq.
>

Got it, thanks for taking the time to set me straight.

Regards,
Brad
