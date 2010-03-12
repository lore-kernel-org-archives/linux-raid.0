From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Reshaping the length of devices
Date: Fri, 12 Mar 2010 16:54:41 +0000
Message-ID: <4B9A71D1.108@anonymous.org.uk>
References: <678411.30301.qm@web51307.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <678411.30301.qm@web51307.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/03/2010 15:18, Jon Hardcastle wrote:
> 
> 
> --- On Fri, 12/3/10, Asdo <asdo@shiftmail.org> wrote:
> 
>> From: Asdo <asdo@shiftmail.org>
>> Subject: Reshaping the length of devices
>> To: "linux-raid" <linux-raid@vger.kernel.org>
>> Date: Friday, 12 March, 2010, 15:15
>> I am wondering... is it possible to
>> reshape the length of the underlying devices with MD raid?
>>
>> I mean like in the case one buys larger disks: after moving
>> the raid partitions to the new disks half of them is still
>> free. So one might want to extend the raid partitions to the
>> end of the disks instead of creating another array in the
>> free space.
>>
>> I have searched the linux-raid mailing list history but I
>> couldn't find this topic.
>>
>> Thanks in advance
> 
> As long as the size of ALL underlying devices have increased you can --grow=MAX to the a multiple of the now smallest drive.

Hmm, that reminds me I was meaning to ask - before I have to go to a 
customer's premises and try it - if I have a CentOS 5 system with 0.90 
metadata and type fd partitions with RAID-5 over 3 discs, and I want to 
grow it by replacing the drives, if I dd small partitions onto larger 
ones and reboot, will the system recognise the RAID-5 - which now has 
its metadata somewhere in the middle of the paritions not at the end - 
so that I can then --grow?

Cheers,

John.
