From: Tony Mantler <nicoya@ubb.ca>
Subject: Re: RAID1 Corruption
Date: Mon, 17 Jan 2005 13:35:00 -0600
Message-ID: <E0D27788-68BE-11D9-87D6-0005023722B8@ubb.ca>
References: <41EBD827.80701@pipi.ma.cx> <200501171624.47645.andrew@walrond.org> <20050117165133.GC99565@caffreys.strugglers.net> <200501171704.10374.andrew@walrond.org> <41EC0371.9060106@infinia.de> <41EC0E7F.5090303@steeleye.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41EC0E7F.5090303@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org, anders@anduras.de, Markus Gehring <markus.gehring@infinia.de>
List-Id: linux-raid.ids


On 17-Jan-05, at 1:14 PM, Paul Clements wrote:

> Hi,
>
> Markus Gehring wrote:
>
>> I have a reproducable problem with corrupted data read from a 
>> RAID1-array.
>> Setup:
>>  HW:
>>   2 S-ATA-Disks (160GB each) -> /dev/md4 RAID1
>>   Promise S150 TX4 - Controller
>>   AMD Sempron 2200+
>>  SW:
>>   Fedora Core 3
>>   Kernel 2.6.10 unpatched
>>   Samba (for read/write-accesses)
>>   SW-Raid
>> Everything works fine with only one drive in the array. If the second 
>> is
>> synced up read accesses return corrupted data.
>> Interesting: If you remove again the second disk. The same files will 
>> be
>>  read correctly again (no matter if written while only one disk is in
>> the array or two are synced!)!
>
> This makes it sound like bad data is getting written to the second 
> disk during resync. Could you give more details about your test 
> procedure (a script or list of steps that reproduces the problem would 
> be great)?
>
> I don't think samba is the culprit, but just to be sure, is there any 
> chance you could reproduce the problem without samba in the equation? 
> (From what you say above, I assume all reads and writes are coming 
> from a samba client of some sort?)

I've run into this before. I don't think Samba was the issue, as it was 
puking on unrelated files, usually showing up as exec format errors 
when trying to run various commands.

The controller in question was a Promise Ultra66 or Ultra100 (I can't 
remember which), plugged into a Powermac 9600. I wonder if the Promise 
driver is interacting poorly with MD?


Cheers - Tony 'Nicoya' Mantler :)

--
Tony 'Nicoya' Mantler -- Master of Code-fu -- nicoya@ubb.ca
--  http://nicoya.feline.pp.se/  --  http://www.ubb.ca/  --

