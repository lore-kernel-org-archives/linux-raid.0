From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 20:09:06 -0400
Message-ID: <508DC922.7040400@meetinghouse.net>
References: <11510711257.20121028131527@oudeis.org> <508D61A1.7020106@wildgooses.com> <508D65CF.1080904@gmail.com> <508DADC3.4080104@shiftmail.org> <508DB08D.20002@meetinghouse.net> <508DC6E9.8070001@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508DC6E9.8070001@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

joystick wrote:
> On 10/28/12 23:24, Miles Fidelman wrote:
>> joystick wrote:
>>>
>>> This thing of "drives falling out of RAID" I have heard many times, 
>>> but really don't know what people are talking about.
>>> How could a drive fall out of a RAID? A RAID is nothing special, 
>>> it's just read/write commands given to a drive by a process called MD.
>>> If the drive drops out of RAID it means it would have dropped out of 
>>> a normal computer doing normal I/O
>>> Please explain
>>
>> The RAID erroneously thinks that a drive has failed, and drops it 
>> from the array.
>
> Due to missing ERC/TLER and a bad sector, or another reason I am not 
> aware of?
>
> And if it is "another reason", would you please explain how is that 
> different from what happens in a desktop? How come they are acceptable 
> for use in a desktop but they drop out of RAID? Why is RAID so special?

Two separate issues.

The comments about "dropping out of raid" had to do with drives that are 
slow to come out of sleep mode - causing hiccups when the RAID 
hardware/software simply doesn't see the drive, and drops it.

The more problematic issue, as far as RAID is concerned is that:

- "desktop" drives are designed to to make every attempt to recover data 
- hence the reported examples of multiple minutes to complete a read 
cycle -- if you only have one copy of your data, that may be an 
acceptable tradeoff, but...

- "enterprise" drives are designed with the assumption that they're part 
of a RAID array - if they can't read the data, they simply give up and 
leave it to the RAID software/hardware to read the data off another drive

If you use the wrong kind of drive in a RAID array, you can find 
yourself waiting minutes, while a failing drive tries to read data, when 
what you want is to drop that drive and read the data off a good drive.




-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra

