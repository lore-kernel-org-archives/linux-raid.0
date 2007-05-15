From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: how to synchronize two devices (RAID-1, but not really?)
Date: Tue, 15 May 2007 13:21:27 +0200
Message-ID: <464997B7.4040600@wpkg.org>
References: <4649760A.1060805@wpkg.org>	<17993.34959.150157.200536@notabene.brown>	<46498E60.9060407@wpkg.org> <17993.38016.174124.287952@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17993.38016.174124.287952@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown schrieb:
> On Tuesday May 15, mangoo@wpkg.org wrote:
>> Neil Brown schrieb:
>>
>> (...)
>>
>>> An external bitmap means that if the link goes down, it keeps track of
>>> which blocks are in sync and which aren't, and when the link comes
>>> back up you re-add the missing device and the rebuild continues where
>>> it left off.
>>>   mdadm --build /dev/md22 --level=1 --bitmap=/root/mybitmap \
>>>      --write-behind --raid-disks=2 /dev/localdevice --write-mostly /dev/remotedevice
>> One more question - is there a way to estimate the size of the bitmap 
>> file? Does it depend on the size of the array?
>>
>> What bitmap file size can I expect for a 600 GB array?
> 
> Due to internal implementation details, mdadm limits the size of the
> bitmap to 2^20 bits.  So the file will be 100K +/- 50%.
> That will lead to about 1Meg per bit.  If you have a failure, this
> might mean you end up re-copying several megabytes more than you
> really need to, but that should add up to less than one second.

Good, I was wondering if ~200 MB left I have on a filesystem would be 
enough :)


-- 
Tomasz Chmielewski
http://wpkg.org
