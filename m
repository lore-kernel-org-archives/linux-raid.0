From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Samsung F1 RAID Class SATA/300 1TB drives
Date: Wed, 03 Nov 2010 13:04:03 -0400
Message-ID: <4CD19603.4060308@tmr.com>
References: <61.E7.19545.3D73FCC4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <61.E7.19545.3D73FCC4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'John Robinson' <john.robinson@anonymous.org.uk>, 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Leslie Rhorer wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of David Rees
>> Sent: Monday, November 01, 2010 4:26 PM
>> To: John Robinson
>> Cc: Mark Knecht; Linux-RAID
>> Subject: Re: Samsung F1 RAID Class SATA/300 1TB drives
>>
>> On Thu, Oct 28, 2010 at 4:37 PM, John Robinson
>> <john.robinson@anonymous.org.uk>  wrote:
>>      
>>> On 29/10/2010 00:17, Mark Knecht wrote:
>>>        
>>>> I saw in Fry's San Jose ad today they were selling these
>>>> Serial-ATA/300 drives for $67. They didn't give a model number but
>>>> scouting around a bit on the web I'm guessing they are a discontinued
>>>> model.
>>>>
>>>> Any inputs on whether these are drives that work well with mdadm RAID?
>>>> Do they support TLER and otherwise work well?
>>>>
>>>> This would just be a home server of some type, nothing industrial.
>>>> Probably a 3 drive RAID-1 or something like that.
>>>>          
>>> Well, they're perhaps not great. I bought three and after only about a
>>> thousand hours one of them was giving SMART errors, then after about
>>>        
>> 7,500
>>      
>>> hours a second one started doing it too. At that point I replaced both
>>>        
>> with
>>      
>>> other makes, copying over with ddrescue (or maybe it was dd_rescue),
>>>        
>> which
>>      
>>> worked without any failed sectors, then ran badblocks -w on the Samsungs
>>>        
>> and
>>      
>>> the SMART errors went away. The third one of mine is still fine, and the
>>> other two are now in a ReadyNAS giving good service.
>>>        
>> I think that using two different brand drives in general is a good idea.
>>
>> We recently had 2 500 GB WD5000AAKS drives die at the same time over a
>> weekend.  Both of them suffered from the same death and would no
>> longer spin up - just making a clicking/whirring sound when you
>> powered it on.
>>
>> Luckily we had backups for most of the data on there, but some
>> non-critical (but time consuming to manually restore) data had to be
>> reconstructed.
>>
>> I understand that drives from the same batch will often die around the
>> same period of time - from now on we plan on trying to use dissimilar
>> drives when possible.
>>
>> First time we've seen 2 drives in one array die that close together
>> and that catastrophically, though.
>>      
> 	I had 4 Seagate drives go bad all at once on a 10 drive array.
> Fortunately, the drives did not die entirely.  Indeed, I'm still not sure
> what is wrong with them.  They seem to read and write just fine, but if they
> are added back to the array and the array is asked to access data with a
> high seek rate (read or write), the drives get kicked from the array.
> Relatively low seek rates allow the drives to continue to be array members,
> and when the drives get kicked, they can always be added back.  I was able
> to use ddrescue to read the data 100% without any failures.  Had the array
> been unrecoverable, I had backups, of course, but I did not have to resort
> to them.  I'm not entirely sure when the drives all went bad, but it was
> within a week or two of each other.
>    

One possible cause for this is a marginal power supply which "can't keep 
up" when supporting lots of seeks and transfers on multiple drives. In 
every group of drives there will be some variance for low voltage (or 
noise, more likely) and the drive(s) which are sensitive appear to fail. 
I say this from experience, it does happen, and going to a better power 
supply will cure it. This might not be the problem, of course, but it's 
worth investigating before blaming the drives.

The sad truth is that if you have this problem and replace the weakest 
drives, it's likely that some other drive will become the weak sister 
and fail, leading to people saying "oh, those {vendor} drives are crap, 
I had {number} fail on me, one after the other." Have you heard that? 
Me, too! Check before replacing or scrapping drives!

-- 
Bill Davidsen<davidsen@tmr.com>
   "We can't solve today's problems by using the same thinking we
    used in creating them." - Einstein

