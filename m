From: David Brown <david.brown@hesbynett.no>
Subject: Re: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 16:04:38 +0200
Message-ID: <52580576.40703@hesbynett.no>
References: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com> <alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se> <CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com> <5257A333.2010809@websitemanagers.com.au> <5257C566.6040208@hesbynett.no> <CAPbD+RfCuYPYy3sx+USxTcN3iApfO9ibu+0aq=9B3gU_H3sZyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPbD+RfCuYPYy3sx+USxTcN3iApfO9ibu+0aq=9B3gU_H3sZyw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/10/13 11:53, Guillaume Betous wrote:
> For a personnal use, the issue is often in the number of drive you can
> have with your tower/motherboard, more than really the price of hard
> drives themselves.

That's absolutely true.  And for personal use, RAID6 + hot spare is
normally overkill - RAID6 is fine by itself.  You can always add a cold
spare if you need it, such as when you need to replace a drive.
Realistically, the chances of losing data due to disk failure from three
disks are vastly lower than other causes of data loss - user error,
power problems, theft, tripping over the server, cat peeing on the
server, etc.

It is better to use RAID6 than RAID5 + hot spare (this is true in almost
all circumstances, except perhaps when you want to maximise RMW partial
write speeds or to share the hot spare amongst several arrays).  But for
a home NAS with 5 drives, a 3 + 2 raid6 is ideal.

mvh.,

David


> 
> gUI
> 
> 2013/10/11 David Brown <david.brown@hesbynett.no>:
>> On 11/10/13 09:05, Adam Goryachev wrote:
>>> On 11/10/13 17:52, Guillaume Betous wrote:
>>>>> RAID6, preferrably with a spare.
>>>> I'm not comfortable with RAID 6 setup. What is the minimal number of
>>>> hard drives for having a RAID 6 + spare ?
>>>>
>>>
>>> Check wikipedia, but minimum of 4 drives for RAID6, consider 2 data
>>> drives plus two redundant drives, allowing you to lose any two drives
>>> (slightly better than RAID10 on 4 drives).
>>>
>>> In direct answer, RAID6 + hot spare is a minimum of 5 drives.
>>>
>>
>> That's just the /sensible/ answer.  The minimum is actually 4 drives -
>> one data, two redundant, and one spare (though obviously there are
>> better ways to use your drives).  And with mdadm, you can tell it that
>> three of these drives are missing.  While such things might seem a bit
>> silly, it is sometimes convenient to get your raid up and running with
>> the setup you want even if you haven't physically got the drives in
>> place yet - you can add them in later.
>>
> 

