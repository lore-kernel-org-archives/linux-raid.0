From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 2 drives failed, one "active", one with wrong event count
Date: Fri, 29 Jan 2010 13:09:02 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1001291306170.15329@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1001280952060.15329@uplift.swm.pp.se> <alpine.DEB.1.10.1001290502140.15329@uplift.swm.pp.se> <20100129211719.04595761@notabene>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100129211719.04595761@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 29 Jan 2010, Neil Brown wrote:

> 1/ I think you are hitting and mdadm bug in "--assemble --force" that was
>   fixed in 2.6.8. (git commit 4e9a6ff778cdc58dc).

Thanks, I'll try to upgrade mdadm.

> 3/ You really need to fix your problem with SATA timeouts or the array is
>   never going to work.

Yeah, I swapped the PSU yesterday (to an Corsair single rail one) after 
this happened the first time, I thought that might be related. Obviously 
it wasn't, so I'm going to swap cables as next step.

> 4/ please (please please) don't use pastebin.  Just include the output inline
>   in the mail message.  It is much easer to get at then.

Check, most of the important information was already in the email, I just 
added it as an extra... Will include it in the email next time.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
