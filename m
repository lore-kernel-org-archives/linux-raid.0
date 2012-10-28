From: joystick <joystick@shiftmail.org>
Subject: Re: 3TB drives failure rate
Date: Mon, 29 Oct 2012 00:59:37 +0100
Message-ID: <508DC6E9.8070001@shiftmail.org>
References: <11510711257.20121028131527@oudeis.org> <508D61A1.7020106@wildgooses.com> <508D65CF.1080904@gmail.com> <508DADC3.4080104@shiftmail.org> <508DB08D.20002@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508DB08D.20002@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/28/12 23:24, Miles Fidelman wrote:
> joystick wrote:
>>
>> This thing of "drives falling out of RAID" I have heard many times, 
>> but really don't know what people are talking about.
>> How could a drive fall out of a RAID? A RAID is nothing special, it's 
>> just read/write commands given to a drive by a process called MD.
>> If the drive drops out of RAID it means it would have dropped out of 
>> a normal computer doing normal I/O
>> Please explain
>
> The RAID erroneously thinks that a drive has failed, and drops it from 
> the array.

Due to missing ERC/TLER and a bad sector, or another reason I am not 
aware of?

And if it is "another reason", would you please explain how is that 
different from what happens in a desktop? How come they are acceptable 
for use in a desktop but they drop out of RAID? Why is RAID so special?
