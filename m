From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: PULL REQUEST - serious md/RAID10 bug in 3.1 when activating a
 hot-spare.
Date: Mon, 31 Oct 2011 14:10:03 +0800
Message-ID: <4EAE3BBB.3040504@fnarfbargle.com>
References: <20111031130859.121d5620@notabene.brown>	<4EAE2C62.3030506@fnarfbargle.com>	<4EAE3352.8090409@fnarfbargle.com> <20111031164954.274dda14@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111031164954.274dda14@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/10/11 13:49, NeilBrown wrote:

>>> G'day Neil,
>>>
>>> Is that the issue I bumped up against here?
>>>
>>> http://permalink.gmane.org/gmane.linux.raid/35805
>>
>> After looking closer I can confirm that making the indicated change
>> resolves this problem.
>
> Yes, definitely the same problem.
> It's a shame I didn't pay proper attention to that report at the time - I
> think that was the day that the uSD in my phone died and I was somewhat
> distracted trying to figure out how to rebuild the install from scratch :-(

Well, like I said in the original mail, no harm done and no urgency.I 
simply applied the patch, rebooted and added the drive. Job done and no 
hangover.

Those little flash devices don't seem to be as robust as we'd expect 
them to be. I've had several failures recently that can't be explained 
by early life, nor excessive wear. I just don't trust them anymore.
