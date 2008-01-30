From: David Greaves <david@dgreaves.com>
Subject: Re: [PATCH] Use new sb type
Date: Wed, 30 Jan 2008 12:53:18 +0000
Message-ID: <47A0733E.60008@dgreaves.com>
References: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr> <479E1C95.1040008@dgreaves.com> <479FB1FB.6040500@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479FB1FB.6040500@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> David Greaves wrote:
>> Jan Engelhardt wrote:
>>  
>>> This makes 1.0 the default sb type for new arrays.
>>>
>>>     
>>
>> IIRC there was a discussion a while back on renaming mdadm options
>> (google "Time
>> to  deprecate old RAID formats?") and the superblocks to emphasise the
>> location
>> and data structure. Would it be good to introduce the new names at the
>> same time
>> as changing the default format/on-disk-location?
>>   
> 
> Yes, I suggested some layout names, as did a few other people, and a few
> changes to separate metadata type and position were discussed. BUT,
> changing the default layout, no matter how "better" it seems, is trumped
> by "breaks existing setups and user practice." For all of the reasons
> something else is preferable, 1.0 *works*.

It wasn't my intention to change anything other than the naming.

If the default layout was being updated to 1.0 then I thought it would be a good
time to introduce 1-start, 1-4k and 1-end names and actually announce a default
of "1-end" and not "1.0".

Although I still prefer a full separation:
  mdadm --create /dev/md0 --metadata 1 --meta-location start

David

