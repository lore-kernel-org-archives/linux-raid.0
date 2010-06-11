From: John Hendrikx <hjohn@xs4all.nl>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 13:10:23 +0200
Message-ID: <4C12199F.60108@xs4all.nl>
References: <4C1128C2.4020105@meetinghouse.net> <20100611005743.43664e5b@natsu> <4C11578B.8010202@meetinghouse.net> <20100611034108.6a2cdbc4@natsu> <4C1169CB.1030903@meetinghouse.net> <20100611085112.5f33b06f@natsu> <4C11BFB7.7050907@meetinghouse.net> <20100611150811.3c3f03bb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100611150811.3c3f03bb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Miles Fidelman <mfidelman@meetinghouse.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Fri, 11 Jun 2010 00:46:47 -0400
> Miles Fidelman <mfidelman@meetinghouse.net> wrote:
>
>   
>> Roman Mamedov wrote:
>>     
>>> On Thu, 10 Jun 2010 18:40:11 -0400
>>> Miles Fidelman<mfidelman@meetinghouse.net>  wrote:
>>>
>>>    
>>>       
>>>> Yes... went with internal.
>>>>
>>>> I'll keep an eye on write performance.  Do you happen to know, off hand,
>>>> a magic incantation to change the bitmap-chunk size? (Do I need to
>>>> remove the bitmap I just set up and reinstall one with the larger chunk
>>>> size?)
>>>>      
>>>>         
>>> Remove (--bitmap=none) then add again with new --bitmap-chunk.
>>>
>>>    
>>>       
>> Looks like my original --bitmap internal creation set a very large chunk 
>> size initially
>>
>> md3 : active raid6 sda4[0] sdd4[3] sdc4[2] sdb4[1]
>>        947417088 blocks level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
>>        bitmap: 6/226 pages [24KB], 1024KB chunk
>>
>> unless that --bitmap-chunk=131072 recommendation is translates to 
>> 131072KB (if so, are you really running 131MB chunks?)
>>     
>
> Yes, and 131MB (128MiB) is probably a little on the large side, but not
> excessively so and may well be a very good number.
>   
I'm using --bitmap-chunk=131072 as well, with the same reasoning as you 
outlined in your post.  The bitmap will be small and require few updates 
while still providing a huge reduction in resync times.

> On a 1TB drive there are 7500 131MB chunks.  So assuming a relatively small
> number of bits set at a time, this will reduce resync time by a factor of
> somewhere between 200 and 1000.  Hours become fewer minutes.  This is
> probably enough for most situations.
>
> I would be really interested to find out if my assumption of small numbers of
> bits set is valid.   You can find out the number of bits set at any instant
> with  "mdadm -X" run on some component of the array.
>   
I was interested as well, so I ran this command:

 > mdadm -X /dev/md2

and this is the result(??):

        Filename : /dev/md2
           Magic : d747992c
mdadm: invalid bitmap magic 0xd747992c, the bitmap file appears to be 
corrupted
         Version : 1132474982
mdadm: unknown bitmap version 1132474982, either the bitmap file is 
corrupted or you need to upgrade your tools

 > cat /proc/mdstat

Personalities : [raid1] [raid6] [raid5] [raid4] [raid0]
md3 : active raid6 sdd1[7] sda1[0] sdj1[6] sdc1[3] sdg1[2] sdb1[1]
      3867871232 blocks super 1.2 level 6, 512k chunk, algorithm 2 [6/6] 
[UUUUUU]
      bitmap: 0/4 pages [0KB], 131072KB chunk

md2 : active raid6 sde1[7] sdi1[6] sdh1[3] sdg3[2] sdb2[1] sda2[0]
      3867871232 blocks super 1.2 level 6, 512k chunk, algorithm 2 [6/6] 
[UUUUUU]
      bitmap: 0/4 pages [0KB], 131072KB chunk

md0 : active raid1 sdg2[0] hda1[1]
      9767424 blocks [2/2] [UU]
     
unused devices: <none>

I upgraded to the latest available mdadm (in debian unstable) and it has 
the same results (for both arrays).

 > mdadm --version
mdadm - v3.1.2 - 10th March 2010

 > uname -a
Linux Ukyo 2.6.27.5 #1 SMP PREEMPT Sun Nov 9 08:32:40 CET 2008 i686 
GNU/Linux

Is this normal? :)  Both arrays were freshly created a few days ago, 
with mdadm v3.0.3...
> If anyone is able to report some samples of that number along with array
> size / level / layout / number of devices etc and some guide to the workload,
> it might be helpful in validating my rule-of-thumb.
>
> Thanks,
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

--John

