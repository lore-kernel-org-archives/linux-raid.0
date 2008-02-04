From: aristizb@ualberta.ca
Subject: Re: Linux md and iscsi problems
Date: Mon, 04 Feb 2008 09:53:35 -0700
Message-ID: <20080204095335.n26tlbaav4s8sk08@webmail.ualberta.ca>
References: <20080201115919.5qx4ih3zeogswc4w@webmail.ualberta.ca>
	<18340.58431.163856.338970@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18340.58431.163856.338970@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning.


Quoting Neil Brown <neilb@suse.de>:

> On Friday February 1, aristizb@ualberta.ca wrote:
>>
>>
>> Summarizing, I have two questions about the behavior of Linux md with
>> slow devices:
>>
>> 1. Is it possible to modify some kind of time-out parameter on the
>> mdadm tool so the slow device wouldn't be marked as faulty because of
>> its slow performance.
>
> No.  md doesn't do timeouts at all.  The underlying device does.
> So if you are getting time out errors from the iscsi initiator, then
> you need to change the timeout value used by the iscsi initiator.  md
> has no part to play in this.  It just sends a request and eventually
> gets either 'success' or 'fail'.
>

1. What seems strange to me is that under the same conditions running  
the test only with iscsi, the initiator never fails. I had some  
problems with iscsi on the past and they  were solved changing the  
time-out parameters on  the initiator side, but now that I added the  
md layer I am getting errors with the slow device.



>>
>> 2. Is it possible to control the "buffer" size of the RAID?, in other
>> words, can I control the amount of data I can write to the local disc
>> before I receive an acknowledgment from the slow device when I am
>> using the write-behind option.
>
> No.  md/raid1 simply calls 'kmalloc' to get space to buffer each write
> as the write arrives.  If the allocation succeeds, it is used to
> perform the write lazily.  If the allocation fails, the write is
> performs synchronously.
>
> What did you hope to achieve by such tuning?  It can probably be
> added if it is generally useful.
>
> NeilBrown
>
>

2. The idea here is to implement remote replication, by having a  
RAID-1 I can create a mirror of my local disk and use it for backup or  
for any other purposes on a centralized location.

Changing the buffer will allow me to improve performance on the  
writing, so a user will always experience local writing speed, while I  
am still sending data across the network to the mirror device.


Thanks a lot for your time.


Juan Aristizabal.

