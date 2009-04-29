From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 12:32:37 +0100
Message-ID: <49F83AD5.3010505@anonymous.org.uk>
References: <1240574900.4507.2076.camel@ezra>	 <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>	 <87ljplnmrw.fsf@frosties.localdomain>  <49F73EA2.3020803@zytor.com>	 <1240957422.18303.697.camel@ezra>  <49F791B2.3010009@zytor.com> <1240963353.18303.862.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1240963353.18303.862.camel@ezra>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29/04/2009 01:02, Daniel Reurich wrote:
>>> No What I'm asking for is a superblock layout that allows the boot
>>> loader to be installed in each member disk, so that the booting from a
>>> software raid array becomes not only possible, but reliable and easy to
>>> set up.
>>>
>> What you're asking for is a partitioning scheme hidden away in md.
>>
> Nope, just the first 64K of each member disk to be reserved for a raid
> aware bootloader.

Which is a 64K RAID-1 partition at the beginning of each disc, and the 
remaining partition of the disc the main RAID member, which you can 
already do with visible partitions, so what you're asking for sounds to 
me very much like a paritioning scheme hidden away in md.

Cheers,

John.

