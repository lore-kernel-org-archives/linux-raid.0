From: linbloke <linbloke@fastmail.fm>
Subject: Re: IMSM Raid 5 always read only and gone after reboot
Date: Fri, 26 Aug 2011 20:54:46 +1000
Message-ID: <4E577B76.2000803@fastmail.fm>
References: <CAOTVL7JLxjHgyaz0s3Ua9gsgUYHP_2b1DONzk3YNaCLfgxMBpA@mail.gmail.com>	<4E4B4075.2060400@gmail.com>	<4E553039.8010003@zarembo.de> <20110825095430.3b88d71d@notabene.brown> <4E569F75.2020306@zarembo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E569F75.2020306@zarembo.de>
Sender: linux-raid-owner@vger.kernel.org
To: Iwan Zarembo <iwan@zarembo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/08/11 5:16 AM, Iwan Zarembo wrote:
>
>> It sounds like mdmon is not being started.
>> mdmon monitors the array and performs any metadata updates required.
>>
>> The reason mktable is taking more than a second is that it tries to 
>> write to
>> the array, the kernel marks the array as 'write-pending' and waits 
>> for mdmon
>> to notice, update the metadata, and switch the array to 'active'.  
>> But mdmon
>> never does that.
>>
>> mdmon should be started by mdadm but just to check you can start it 
>> by hand:
>>
>>   /sbin/mdmon md126
>> or
>>   /sbin/mdmon --all
>>
>> If this makes it work, you need to work out why mdmon isn't being 
>> started.
>>
>> NeilBrown
>>
> Hello NeilBrown,
> I finally found it. I was using mdadm 3.1.4, it is in the repository 
> of ubuntu. This version does not really support IMSM that this is the 
> real problem. I found it because I did not have mdmon. It does not 
> exists in this old version. So I downloaded the latest official 
> relesae 3.2.1 and installed it via make && sudo make install. Now 
> everything works perfectly. The array is available after reboot and 
> the synchronization process works over BIOS and not over mdadm itself.
> I would never found out that the version is making the trouble without 
> your comment about mdmon. Thank you.
>
> @Daniel,linbloke: Also a big thank you to you both. I learned a lot 
> about raid with this problem.
>

my advice didn't make it to the list (reply-all duh), but it was short 
and for the record:

On debian-based systems to specify which arrays are required at boot time:

try:
dpkg-reconfigure mdadm

it should ask which arrays (if any) to start on boot

HTH

> Cheers,
>
> Iwan
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
