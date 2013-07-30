From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Suspicious test failure - mdmon misses recovery events on loop
 devices
Date: Tue, 30 Jul 2013 23:16:43 +0200
Message-ID: <51F82D3B.6060104@arcor.de>
References: <51F2E2DD.8090204@arcor.de>	<20130729165550.53c33bf3@notabene.brown>	<51F6D30F.7060007@arcor.de>	<51F6D3B1.1030800@arcor.de> <20130730104206.3ffc9f00@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130730104206.3ffc9f00@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/30/2013 02:42 AM, NeilBrown wrote:
> On Mon, 29 Jul 2013 22:42:25 +0200 Martin Wilck <mwilck@arcor.de> wrote:
> 
>>
>>> My current idea to solve this is yet another separate thread just for
>>> monitoring kernel state changes. Don't have it ready yet, though.
>>
>> Another idea would be in manage_member, after queueing the metadata
>> update and waking up the monitor, to wait for the metadata to finish
>> processing before actually starting the recovery (writing "recover" to
>> sync_action).
>>
>> Martin
> 
> I hope an extra thread won't be necessary :-)

I think the general problem that mdmon may be busy writing to disk while
something changes in the kernel is real. But introducing an extra thread
would make things even more complex as they are now, so it might be
something to avoid.

> I think that manage_member is the place to fix this.  However it might be
> even simpler than you suggest.
> 
> We currently have
> 
> 		replace_array(container, a, newa);
> 		sysfs_set_str(&a->info, NULL, "sync_action", "recover");
> 
> monitor subsequently takes that 'newa', looks at 'sync_action', see that it
> is 'idle' and assume that the recover never happened.
> Suppose we change it to:
> 
> 		if (sysfs_set_str(&a->info, NULL, "sync_action", "recover") == 0)
> 		        newa->prev_action = newa->curr_action = recovery;
> 		replace_array(container, a, newa);
> 
> Then it wouldn't matter if monitor never saw the 'recovery' state as manager
> explicitly told it that recovery had started.
> 
> Could you try that?

Ingenious idea :-) Unfortunately it isn't sufficient. However this PLUS
waiting for the metadata upate to finish makes my test succeed reliably
(10/10, in the previous failure scenario). I'll send in the current
status of patches in a minute.

Martin
> 
> Thanks,
> NeilBrown

