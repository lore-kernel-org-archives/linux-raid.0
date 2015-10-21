From: andras@tantosonline.com
Subject: Re: How to recover after md crash during =?UTF-8?Q?reshape=3F?=
Date: Tue, 20 Oct 2015 23:03:24 -0500
Message-ID: <3705ab15424191392278ae1cf8e2d04a@tantosonline.com>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <874mhl2ed3.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <874mhl2ed3.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <nfbrown@novell.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

Thanks for helping me out!

>>      Oct 17 18:59:48 bazsalikom kernel: [7875182.667831] md: using 
>> 128k
>> window, over a total of 1465135936k.
>> --> Oct 17 18:59:50 bazsalikom kernel: [7875184.326245] md: 
>> md_do_sync()
>> got signal ... exiting
> 
> This is very strange ... maybe some messages missing?
> Probably an IO error while writing to a new device.

I'm not sure what have happened either. This is /var/log/messages. Maybe 
those things go into a different log?

>> mdadm: WARNING /dev/sda and /dev/sda1 appear to have very similar
>> superblocks.
>>        If they are really different, please --zero the superblock on 
>> one
>>        If they are the same or overlap, please remove one from the
>>        DEVICE list in mdadm.conf.
> 
> It's very hard to make messages like this clear without being 
> incredibly
> verbose...
> 
> In this case /dev/sda and /dev/sda1 obviously overlap (that is obvious,
> isn't it?).
> So in that case you need to remove one of them from the DEVICE list.
> You probably don't have a DEVICE list so it defaults to everything 
> listed in
> /proc/partitions.
> The "correct" thing to do at this point would have been to add a DEVICE
> list to mdadm.conf which only listed the devices that might be part of
> an array. e.g.
> 
>   DEVICE /dev/sd[a-z][1-9]

Understood. My problem was that when I googled for the problem, people 
agreed with the suggested solution of the zeroing the superblock. I 
guess it tells you how much you should trust 'common wisdom'.

> 
> Phil has given good advice on this point which is worth following.
> It is quite possible that there will still be corruption.
> 
> mdadm reads the first few stripes and stores them somewhere in each of
> the spares.  md (in the kernel) then reads those stripes again and
> writes them out in the new configuration.  It appears that one of the
> writes failed, others might have succeeded.  This may not have 
> corrupted
> anything (the first few blocks are in the same position for both the 
> old
> and new layout) but it might have done.
> 
> So if the filesystem seems corrupt after the array is re-created, that
> is likely the reason.
> The data still exists in the backup on those new devices (if you 
> haven't
> done anything to them) and could be restored.
> 
> If you do want to look for the backup, it is around about the middle of
> the device and has some metadata which contains the string
> "md_backup_data-1".  If you find that, you are close to getting the
> backup data back.
> 
> NeilBrown

Oh, gosh, I hope I don't have to do that deep of a surgery. No, I 
haven't touched the new HDDs other then zeroing the superblock. So 
whatever was on them, is still there. I'll see how much damage there is 
to the FS after I reconstruct the array.

Thanks for all the help!
Andras
