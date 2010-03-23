From: Peter Kieser <peter@kieser.ca>
Subject: Re: Mixing 512-byte sector, and 4096-byte sector drives
Date: Tue, 23 Mar 2010 11:53:50 -0700
Message-ID: <4BA90E3E.7050602@kieser.ca>
References: <4BA7FFA9.7040303@kieser.ca> <7a329d911003221711r153693f6jdaec0b4f4b3d634@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7a329d911003221711r153693f6jdaec0b4f4b3d634@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wil Reichert <wil.reichert@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/22/2010 5:11 PM, Wil Reichert wrote:
> On Mon, Mar 22, 2010 at 4:39 PM, Peter Kieser<peter@kieser.ca>  wrote:
>> Do I need to set the "XP" jumper on pins 7-8 to play nicely with the other
>> 512-byte sector drives in my array, or will mdraid be okay with the
>> 4096-byte sector drive? Will there be a performance penalty adding the drive
>> to my array?
>>      
> Did you create your RAID on the device or on a partition?  If its on
> the entire device then you should be fine, tho this might depend on
> which metadata format you are using&  where its located on the disc
> (not sure how the metadata effects data alignment).
>    

I created the RAID directly on the device, I have replaced the drive and 
the new 4096-byte drive seems to be playing nicely with the other drives 
in the array after the resync completed.

-Peter
