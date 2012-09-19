From: joystick <joystick@shiftmail.org>
Subject: Re: Serious performance issues with mdadm RAID-5 partition exported
 through LIO (iSCSI)
Date: Wed, 19 Sep 2012 12:49:19 +0200
Message-ID: <5059A32F.8030606@shiftmail.org>
References: <50588731.5050502@bananateam.nl>  <1347997760.25356.16.camel@haakon2.linux-iscsi.org>  <20568.58664.669085.313654@tree.ty.sabi.co.UK> <1348006818.25356.62.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1348006818.25356.62.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@risingtidesystems.com
Cc: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>, target-devel@vger.kernel.org
List-Id: linux-raid.ids

On 09/19/12 00:20, Nicholas A. Bellinger wrote:
>
>>> Are you enabling emulate_write_cache=1 with your iblock
>>> backends..? This can have a gigantic effect on initiator
>>> performance for both MSFT + Linux SCSI clients.
>> That sounds interesting, but also potentially rather dangerous,
>> unless there is a very reliable implementation of IO barriers.
>> Just like with enabling write caches on real disks...
>>
> Not exactly.  The name of the 'emulate_write_cache' device attribute is
> a bit mis-leading here.  This bit simply reports (to the SCSI client)
> that the WCE=1 bit is set during SCSI mode sense (caching page) is read
> during the initial LUN scan.

Then can I say that the default is wrong?
You are declaring writethrough a device that is almost certainly a 
writeback (because at least HDDs will have caches).

If power is lost at the iscsi target, there WILL be data loss. People do 
not expect that. Change the default!


Besides this, I don't understand how declaring an iscsi target as 
writethrough could slow down operations volountarily by initiators. That 
would be a bug of the initiators because writethrough is "better" than 
writeback for all purposes: initiators should just skip the queue drain 
/ flush / FUA, and all the rest should be the same.


>>> [ ... ] check your [ ... ]/queue/max*sectors_kb for the MD
>>> RAID to make sure the WRITEs are striped aligned to get best
>>> performance with software MD raid.
>> That does not quite ensure that the writes are stripe aligned,
>> but perhaps a larger stripe cache would help.
>>
> I'm talking about what MD raid has chosen as it's underlying
> max_sectors_kb to issue I/O to the underlying raid member devices.  This
> depends on what backend storage hardware is in use, this may end up as
> '127', which will result in ugly mis-aligned writes that ends up killing
> performance.

Interesting observation.
For local processes writing, probably MD waits enough time for other 
requests to come and fill a stripe before initiating a rmw; but maybe 
iscsi is too slow for that and MD initiates an rmw for each request 
which would be a zillion of RMWs.
Can that be? Anyone knows MD enough to say if MD waits a little bit for 
more data in the attempt of filling an entire stripe before proceeding 
with rmw? If yes, can such timeout be set?

> We've (RTS) changed this with a one-liner patch to raid456.c code on .32
> basded distro kernels in the past to get proper stripe aligned writes,
> and it obviously makes a huge difference with fast storage hardware.

This value is writable via sysfs, why do you need a patch?

> That's exactly what I'm talking about.
>
> With buffered FILEIO enabled a incoming WRITE payload will have already
> been ACKs back to the SCSI fabric and up the storage -> filesystem
> stack, but if a power loss was to occur before that data has been
> written out (using a battery back-up unit for example), then the FS on
> the client will have (silently) lost data.
>
> This is why we removed the buffered FILEIO from mainline in the first
> place, but in retrospect if people understand the consequences and still
> want to use buffered FILEIO for performance reasons they should be able
> to do so.


If you declare the target as writeback and implement flush+FUA, no data 
loss should occur AFAIU, isn't that so?

AFAIR, hard disks do normally declare all operations to be complete 
immediately after you submit (while they are still in the cache in 
reality), but if you issue a flush+FUA they make an exception to this 
rule and make sure that this operation and all previously submitted 
operations are indeed on the platter before returning. Do I remember 
correctly?

Can you do the same for buffered FILEIO?
