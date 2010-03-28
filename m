From: Stefan *St0fF* Huebner <st0ff@gmx.net>
Subject: Re: Use of WD20EARS with MDADM
Date: Sun, 28 Mar 2010 18:19:17 +0200
Message-ID: <4BAF8185.9040307@gmx.net>
References: <4BAB8D41.4010801@gmail.com> <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com> <4BABA12D.6040605@shiftmail.org>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BABA12D.6040605@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 25.03.2010 18:45, schrieb Asdo:
> David Lethe wrote:
>> On Mar 25, 2010, at 11:20 AM, Andrew Dunn wrote:
>>  
>>> Recently Dell is selling their WD20EARS (2TB) for 90$
>>>
>>> This being one of the best PPG (Price Per Gigabyte) snatches I have
>>> seen, I was considering buying 8 of them for an mdadm array.
>>>
>>> Has anyone had experience with these drives?
>>>
>>> Note, they have 4K sectors.
>>>
>>> Thank you for your kind responses.
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>     
>>
>> This is a low-cost consumer disk that is rated for a whole 2400 hours
>> use in a year.  You get what you pay for. 
>
> I think the "I" in RAID stands for inexpensive :-P
> Jokes apart, don't you think frequent scrubbing (e.g. weekly for a
> raid-6 or 2/week for raid-1/10) is enough to compensate for this?
> I would be way more concerned with ERC / TLER if it proves to be
> nonsettable, but I might be wrong

Just for those who like to read: ERC is a feature stated in the
ATA-specifications, that's why the "quick hack" for smartctl was so
easy.  But in the specs it is also noted, that the change a
SCT-ERC-Command does will not survive a power cycle.

So y'all will probably need some udev-triggered daemon, which runs upon
connecting a disk, checking if this disk is conforming to the ata-spec,
then finding out if it's part of a raid array.  If all answers yield
"yes", it should call SCT-ERC with a configurable value, and probably
some other "configure the drive"-commands (for tuning the idle timeout
of wdXXears).

I'll have to think about that as a project again ...

All the best,
Stefan

> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

