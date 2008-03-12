From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Online resize
Date: Wed, 12 Mar 2008 11:04:56 +0300
Message-ID: <47D78EA8.7050604@msgid.tls.msk.ru>
References: <200803111119.56015.wayne@flashmedia.co.za> <20080311111219.GA2086@cthulhu.home.robinhill.me.uk> <200803111444.17502.wayne@flashmedia.co.za> <20080311145832.GC2086@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080311145832.GC2086@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:
> On Tue Mar 11, 2008 at 02:44:17PM +0200, Wayne Gemmell wrote:
> 
>> Well that didn't go so well
>>
>> On Tuesday 11 March 2008 13:12:19 Robin Hill wrote:
>>>  2) Force the OS to be aware of the new partition sizes - either a
>>>     reboot or using partprobe.
>>>  3) Grow the array (mdadm --grow) - check the manual page for details.
>> I ran partprobe and then mdadm --grow --size=max /dev/md4 and nothing 
>> happened. Then I decided to reboot thinking that partprobe hadn't picked up 
>> that change and now it says that sda6 doesn't have a superblock. Any ideas 
>> what went wrong?
>>
> What version metadata are you using?  I'm not sure how 1.0 will handle
> partition resizes but any other should certainly be okay.  Have you
> tried running mdadm -E on each of the component partitions?  I assume
> the new partitions are starting from the same position as the old ones?

Robin, you're completely wrong here.

Only metadata at the START of the partition will work here.  Which is
either 1.1 or 1.2, but NOT 1.0 or 0.90, - which is at the END of the
partition.  When the end of the partition goes away, the superblock
becomes "orphan" somewhere inside the partition, and can't be found
anymore.

What should be done currently is:

a) re-create the array with new partitions, with THE SAME DISK ORDER,
   METADATA VERSION AND CHUNK SIZE as it was before.

b) restore partitions to the EXACT size as they were before, and
   start from scratch

/mjt
