From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: partitioned mirror vs. mirrors of partitions?
Date: Fri, 09 May 2008 10:27:19 -0500
Message-ID: <48246D57.6080406@sandeen.net>
References: <4823A238.4080205@sandeen.net> <48246B73.3020207@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48246B73.3020207@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Eric Sandeen wrote:
>> Hi, I hope this isn't a FAQ, I did do a little searching first...
>>
>> I'm looking at using a couple of large disks to mirror a system which
>> currently has a few different filesystems; I'll use partitions on the
>> disks to contain the different fileystems.
>>
>> It looks like I could mirror sda and sdb, and partition the resulting
>> md_d0.  Or, I could partition sda and sdb, and create mirrors md0, md1,
>> etc from the partitions on the underlying disks.
>>
>> Is there any technical reason to choose one method vs the other?  It
>> seems to me that perhaps on a system with several active partitions from
>> the same disk, partitioning a single large raid device might allow
>> better read balancing?
>>   
> 
> The reason for going with a partitioned raid is that rebuild after a 
> failure is easier. The reason for NOT going there at the moment is 
> discussed in another thread here, in the current kernel the partitions 
> are not started unless you have an initrd file to make that happen. The 
> last is performance, if you are using the partitions in different ways, 
> and some would benefit from performance while others (/boot comes to 
> mind) need to be simple and reliable, and have minimal requirements for 
> speed. Having partitions on the drive allows you to use different raid 
> levels across partitions, to best fit what you do with that data.

Thanks.  In my case I'd just have raid-1 on everything, so don't need
that granulatiry...  Another drawback in my particular case is that the
Red Hat / Fedora tools don't seem to grok partitioned md, but I can fix
that ;)

Is there any merit to my notion about better read balancing across the
entire disk if it's all one md device?

Thanks,
-Eric

> I don't see any as compelling, there's no one best answer for everyone.
> 

