From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Disk Monitoring
Date: Thu, 29 Jun 2017 15:33:47 +0100
Message-ID: <59550FCB.4090508@youngman.org.uk>
References: <20170628131917.BF1911235B6@gemini.denx.de>
 <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
 <2113365.0QvyMCaQ9I@matkor-lenovo>
 <CAJH6TXiONYigcX1CtQw86ZXUgeOLvzD_+2couNfxSwL9hHj1gA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXiONYigcX1CtQw86ZXUgeOLvzD_+2couNfxSwL9hHj1gA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/06/17 11:16, Gandalf Corvotempesta wrote:
> 2017-06-29 12:14 GMT+02:00 Mateusz Korniak <mateusz-lists@ant.gliwice.pl>:
>> One can read of all disks/partitions used by RAIDs by script
>> /usr/share/mdadm/checkarray
>>
>> In many distros it is set to be performed monthly out-of-box.
> 
> I know this and I'm running weekly. (just to be sure)
> What Is unclear to me is why an hardware raid controller like LSI, has
> two different kind of checks: patrol read and consistency check.

Because they're two completely different things.

A patrol check reads the entire disk. It doesn't give two hoots what the
data is, it just cares that the data can actually be retrieved from the
disk.

A consistency check, on the other hand, wants to make sure that the data
is correct. It will read both copies of a mirror and compare them. Or it
will read the data from 4/5/6, calculate the parities, then read them
from disk and compare them.

In other words, a patrol check looks for a failing disk. A consistency
check looks for corrupt data. (A consistency check does a patrol check
as a side effect, but you might not want to do just that, as it is
computationally much more expensive. You might want to do a patrol check
every day, and a consistency check of a weekend.)

Cheers,
Wol

