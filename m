From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: 3TB drives failure rate (summary)
Date: Thu, 01 Nov 2012 15:24:32 +0000
Message-ID: <50929430.50201@anonymous.org.uk>
References: <11510711257.20121028131527@oudeis.org> <508D61A1.7020106@wildgooses.com> <508D65CF.1080904@gmail.com> <508DADC3.4080104@shiftmail.org> <508DB08D.20002@meetinghouse.net> <508DC6E9.8070001@shiftmail.org> <508DC922.7040400@meetinghouse.net> <20121029102919.1134a797@natsu> <508E3626.8080404@hesbynett.no> <508E7E68.1030202@turmel.org> <1494377384.20121031005457@oudeis.org> <50911AFF.9020707@turmel.org> <509291B2.5000907@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <509291B2.5000907@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/11/2012 15:13, Miles Fidelman wrote:
> Phil Turmel wrote:
>> I strongly encourage you to run "smartctl -l scterc /dev/sdX" for each
>> of your drives.  For any drive that warns that it doesn't support SCT
>> ERC, set the controller device timeout to 180 like so:
>>
>> echo 180 >/sys/block/sdX/device/timeout
>>
>> If the report says read or write ERC is disabled, run "smartctl -l
>> scterc,70,70 /dev/sdX" to set it to 7.0 seconds.
>>
>> You then set up a boot-time script to do these adjustments at every
>> restart.
>
> Sounds like a very bad idea if your drive is part of a RAID array.

Either of these - the scterc if you can, the device timeout if you can't 
- are an excellent idea if you are using a desktop drive as part of a md 
RAID array. Why do you think otherwise?

Cheers,

John.

