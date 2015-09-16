From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: Recommendations for RAID setup needed
Date: Wed, 16 Sep 2015 12:03:19 +0200
Message-ID: <20150916120319.Horde.F5MTwIZPHsvhor9LcFyYcAO@www3.nde.ag>
References: <CAB1R3sjKb-aXJV+4E5t6OsWid4QB+r6aCteZt+F+57=cWLhHWw@mail.gmail.com>
 <55F85E9F.1070100@youngman.org.uk>
 <CAB1R3sj3fA3rJA+hQRJcTvL6HmNium+T2RRfdvF9YhpLA=q2Vg@mail.gmail.com>
 <55F8D01C.5040106@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55F8D01C.5040106@websitemanagers.com.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Alex & *,

Zitat von Adam Goryachev <mailinglists@websitemanagers.com.au>:
> On 16/09/15 04:44, Alex wrote:
>> Hi,
>>
>>>> [...] but I'm
>>>> not sure I want to lose the extra space with creating a RAID6 array. I
>>>> believe RAID5 also has faster write speeds?
>>> What disks are you using? Are they proper raid disks? A 12TB array can
>>> have a soft read error every complete pass, and still be within the
>>> disk-manufacturer's specs. If your disks are not raid-compliant, this
>>> will stop your array from rebuilding, ever!
>> All four are WD30EFRX-68EUZN0. They're not the cheapest WD disks, but
>> they're also not the ones with the 5yr warranty. The last array I
>> built using disks with 5yr warranty exceeded their capacity before the
>> warranty expired.
> [...]
>>> (Chances are, your disks are above spec and won't give a problem. Do you
>>> want to take the risk?)
>> There's always going to be some kind of risk, but I'm hoping someone
>> with the technical understanding about disk failure rates can tell me
>> if it's a prudent decision or not.
> That depends on your requirements. What are the implications (for  
> you) if all the data is lost because two drives failed close to the  
> same time? Is that resulting cost more or less than getting a fourth  
> drive and using RAID6?

I just want to point out that double and triple disk faults are far  
beyond theory - we've had a RAID6 crash last year, where three of 11  
disks failed within 24h. Two were from one batch, the third from a  
different batch.

Alex, you initially said this is to be a backup server - so if that  
means the data is already redundant, then you may stick with RAID5.  
But if this is your main data storage and you rely on that data being  
available (i.e. quicker than restoring from backup will take), go for  
RAID6 and keep in mind that even that won't prevent you from total  
RAID loss.

Regards,
Jens

