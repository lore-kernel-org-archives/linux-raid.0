From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: mdadm message (auto-read-only) on "/dev/md1" = swap file system
Date: Wed, 10 Jun 2009 19:59:57 +0100
Message-ID: <4A3002AD.60103@anonymous.org.uk>
References: <2b91784d0906101010l409c38d2m8d0e7401c454307f@mail.gmail.com> <D081A9AE-6E07-4568-880A-2CC8A47947C1@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D081A9AE-6E07-4568-880A-2CC8A47947C1@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/06/2009 18:30, Steven Haigh wrote:
> On 11/06/2009, at 3:10 AM, Ing. Jair wrote:
[...]
>> md1 : active (auto-read-only) raid1 hde2[0] hdg2[1]
>>      2634560 blocks [2/2] [UU]
[...]
>> My question for this is:
>>
>> 1. Is this the way suppose to work on the device md1 = swap filesystem 
>> raid?
> 
> I believe the array will stay read-only until the first write is 
> performed - at which time the array will automatically switch to 
> read/write.

I think so too; the boss said something similar about a month ago: 
http://marc.info/?l=linux-raid&m=124178553609572&w=2

To the OP: what problem are you experiencing?

Cheers,

John.

