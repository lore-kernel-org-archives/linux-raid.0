From: David Brown <david.brown@hesbynett.no>
Subject: Re: Optimizing small IO with md RAID
Date: Mon, 30 May 2011 18:56:23 +0200
Message-ID: <is0i7n$mcs$1@dough.gmane.org>
References: <BANLkTi=236kncpunzodSci-1K33u_FBkPA@mail.gmail.com>	<irvuj1$rc3$1@dough.gmane.org>	<4DE38628.1050201@anonymous.org.uk>	<is04s2$2rn$1@dough.gmane.org> <BANLkTikw9cqfhHAVaxZ2T2EErroCMT5Zow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikw9cqfhHAVaxZ2T2EErroCMT5Zow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/05/11 17:24, fibreraid@gmail.com wrote:
> Hi All,
>
> I appreciate the feedback but most of it seems around File System
> recommendations or to change to parity-less RAID, like RAID 10. In my
> tests, there is no file system; I am testing the raw block device as I
> want to establish best-numbers there before layering on the file
> system.
>

I understand about testing the low-level speed before adding filesystem 
(and possibly lvm) layers, but what's wrong with parity-less RAID? 
RAID10,far has lower space efficiency than RAID5 or RAID6, but typically 
has performance close to RAID0, and it sounded like you were judging 
performance to be the most important factor.

mvh.,

David


> -Tommy
>
>
> On Mon, May 30, 2011 at 6:08 AM, David Brown<david@westcontrol.com>  wrote:
>> On 30/05/2011 13:57, John Robinson wrote:
>>>
>>> On 30/05/2011 12:20, David Brown wrote:
>>>>
>>>> (This is in addition to what Stan said about filesystems, etc.)
>>>
>>> [...]
>>>>
>>>> Try your measurements with a raid10,far setup. It costs more on data
>>>> space, but should, I think, be quite a bit faster.
>>>
>>> I'd also be interested in what performance is like with RAID60, e.g. 4
>>> 6-drive RAID6 sets, combined into one RAID0. I suggest this arrangement
>>> because it gives slightly better data space (33% better than the RAID10
>>> arrangement), better redundancy (if that's a consideration[1]), and
>>> would keep all your stripe widths in powers of two, e.g. 64K chunk on
>>> the RAID6s would give a 256K stripe width and end up with an overall
>>> stripe width of 1M at the RAID0.
>>>
>>
>> Power-of-two stripe widths may be better for xfs than non-power-of-two
>> widths - perhaps Stan can answer that (he seems to know lots about xfs on
>> raid).  But you have to be careful when testing and benchmarking - with
>> power-of-two stripe widths, it's easy to get great 4 MB performance but
>> terrible 5 MB performance.
>>
>>
>> As for the redundancy of raid6 (or 60) vs. raid10, the redundancy is
>> different but not necessarily better, depending on your failure types and
>> requirements.  raid6 will tolerate any two drives failing, while raid10 will
>> tolerate up to half the drives failing as long as you don't lose both halves
>> of a pair.  Depending on the chances of a random disk failing, if you have
>> enough disks then the chances of two disks in a pair failing are less than
>> the chances of three disks in a raid6 setup failing.  And raid10 suffers
>> much less from running in degraded mode than raid6, and recovery is faster
>> and less stressful.  So which is "better" depends on the user.
>>
>> Of course, there is no question about the differences in space efficiency -
>> that's easy to calculate.
>>
>> For greater paranoia, you can always go for raid15 or even raid16...
>>
>>> You will probably always have relatively poor small write performance
>>> with any parity RAID for reasons both David and Stan already pointed
>>> out, though the above might be the least worst, if you see what I mean.
>>>
>>> You could also try 3 8-drive RAID6s or 2 12-drive RAID6s but you'd
>>> definitely have to be careful - as Stan says - with your filesystem
>>> configuration because of the stripe widths, and the bigger your parity
>>> RAIDs the worse your small write and degraded performance becomes.
>>>
>>> Cheers,
>>>
>>> John.
>>>
>>> [1] RAID6 lets you get away with sector errors while rebuilding after a
>>> disc failure. In addition, as it happens, setting up this arrangement
>>> with two drives on each controller for each of the RAID6s would mean you
>>> could tolerate a controller failure, albeit with horrible performance
>>> and you would have no redundancy left. You could configure smaller
>>> RAID6s or RAID10 to tolerate a controller failure too.
>>>
>>

