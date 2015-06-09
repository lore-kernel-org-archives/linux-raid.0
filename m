From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Tue, 09 Jun 2015 19:46:43 +0100
Message-ID: <55773493.3050605@youngman.org.uk>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr> <55767860.5000803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55767860.5000803@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>, Pierre Wieser <pwieser@trychlos.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/06/15 06:23, Can Jeuleers wrote:
> On 08/06/15 21:28, Pierre Wieser wrote:
>> Hi all,
>>
>> I currently have an almost full RAID 5 built with 4 x 2 TB disks.
>> I wonder if it would be possible to migrate it to a bigger RAID 5
>> with 3 x 6TB new disks.
> 
> I'd recommend against it:
> 
> https://en.wikipedia.org/wiki/RAID#Unrecoverable_read_errors_during_rebuild
> 
> Jan
> 
Please expand! Having read the article, it doesn't seem to say anything
more than what is repeated time and time on this list - MAKE SURE YOUR
DRIVES ARE DECENT RAID DRIVES.

If you have ERC, then the odd "soft" read error doesn't matter. If you
don't have ERC, then your data is at risk when you replace a drive, and
it doesn't matter how big your drives are, it's the array size that matters.

Cheers,
Wol
