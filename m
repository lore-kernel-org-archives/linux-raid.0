From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 06/10] monitor: read_and_act: log status when called
Date: Wed, 31 Jul 2013 07:28:23 +0200
Message-ID: <51F8A077.8050104@arcor.de>
References: <51F82D3B.6060104@arcor.de>	<1375219114-5626-7-git-send-email-mwilck@arcor.de> <20130731125933.0d6f0c6c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130731125933.0d6f0c6c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/31/2013 04:59 AM, NeilBrown wrote:
>  	}
>> +	
>> +	gettimeofday(&tv, NULL);
>> +	fprintf(stderr, "%s(%d): %ld.%06ld state:%s prev:%s action:%s prev: %s start:%llu\n",
>> +		__func__, a->info.container_member,
>> +		tv.tv_sec, tv.tv_usec,
>> +		array_states[a->curr_state],
>> +		array_states[a->prev_state],
>> +		sync_actions[a->curr_action],
>> +		sync_actions[a->prev_action],
>> +		a->info.resync_start
>> +		);
> 
> I hope this was meant to be "dprintf" ???
> 
> I've made that change.

OOps sorry. That was part of a (failed) attempt of mine to print ONLY
this message. I forgot to undo it later.

Thanks a lot for spotting it.

Martin


