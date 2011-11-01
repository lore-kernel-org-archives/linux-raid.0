From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 01 Nov 2011 18:35:03 -0400
Message-ID: <4EB07417.3090002@meetinghouse.net>
References: <4EAF3F78.5060900@meetinghouse.net> <j8odkj$46h$1@dough.gmane.org> <4EAFEE95.6070608@meetinghouse.net> <4EAFF636.6060904@anonymous.org.uk> <j8p0g3$9r4$1@dough.gmane.org> <4EB052E6.4050400@meetinghouse.net> <20111101212023.GA20565@cthulhu.home.robinhill.me.uk> <4EB06561.8090706@meetinghouse.net> <20111101215058.GB20565@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111101215058.GB20565@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:
> Sorry, my mistake - it should be -p n3, or -p n4. You'll want -p f6/-p
> f8 to get a far configuration though, but yes, that should give good
> redundancy against a single node failure.
>
>> which then leaves the question of whether the md driver, itself, can be
>> failed over from one node to another
>>
> I don't see why not. You'll probably need to force assembly though, as
> it's likely the devices will be slightly out-of-synch after the node
> failure.
>
>
sort of would expect to have to resynch

has anybody out there actually tried this at some point?

I've been trying to find OCF resource agents for handling a RAID 
failover, and only coming up with deprecated functions with little 
documentation - the only thing that even sounds remotely close is a 
heartbeat2 "md group take over" resource agent, but all I can find are 
references to it, no actual documentation

Miles


-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


