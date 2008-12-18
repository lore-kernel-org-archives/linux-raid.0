From: Leon Woestenberg <leonw@mailcan.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Thu, 18 Dec 2008 09:20:10 +0100
Message-ID: <494A07BA.1080008@mailcan.com>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>	<1229225480.16555.152.camel@localhost>	<18757.4606.966139.10342@tree.ty.sabi.co.uk>	<200812141912.59649.Martin@lichtvoll.de>	<18757.33373.744917.457587@tree.ty.sabi.co.uk>
	<494971B2.1000103@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <494971B2.1000103@tmr.com>
Content-Disposition: inline
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>, Linux XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

Hello all,

Bill Davidsen wrote:
> Peter Grandi wrote:
>   
>> Unfortunately that seems the case.
>>
>> The purpose of barriers is to guarantee that relevant data is
>> known to be on persistent storage (kind of hardware 'fsync').
>>
>> In effect write barrier means "tell me when relevant data is on
>> persistent storage", or less precisely "flush/sync writes now
>> and tell me when it is done". Properties as to ordering are just
>> a side effect.
>>   
>>     
>
> I don't get that sense from the barriers stuff in Documentation, in fact 
> I think it's essentially a pure ordering thing, I don't even see that it 
> has an effect of forcing the data to be written to the device, other 
> than by preventing other writes until the drive writes everything. So we 
> read the intended use differently.
>
> What really bothers me is that there's no obvious need for barriers at 
> the device level if the file system is just a bit smarter and does it's 
> own async io (like aio_*), because you can track writes outstanding on a 
> per-fd basis, so instead of stopping the flow of data to the drive, you 
> can just block a file descriptor and wait for the count of outstanding 
> i/o to drop to zero. That provides the order semantics of barriers as 
> far as I can see, having tirelessly thought about it for ten minutes or 
> so. Oh, and did something very similar decades ago in a long-gone 
> mainframe OS.
>   
Did that mainframe OS have re-ordering devices? If it did, you'ld still 
need barriers all the way down:

The drive itself may still re-order writes, thus can cause corruption if 
halfway the power goes down.
 From my understanding, disabling write-caches simply forces the drive 
to operate in-order.

Barriers need to travel all the way down to the point where-after 
everything remains in-order.
Devices with write-cache enabled will still re-order, but not across 
barriers (which are implemented as
either a single cache flush with forced unit access, or a double cache 
flush around the barrier write).

Whether the data has made it to the drive platters is not really 
important from a barrier point of view, however,
iff part of the data made it to the platters, then we want to be sure it 
was in-order.

Because only in this way can we ensure that the data that is on the 
platters is consistent.

Regards,

Leon.



[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
