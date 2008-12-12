From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Intel X25-E running Linux using XFS
Date: Fri, 12 Dec 2008 15:23:19 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812121516190.17857@p34.internal.lan>
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan> <20081212185803.GE11974@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081212185803.GE11974@elf.ucw.cz>
Sender: linux-ide-owner@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Cc: smartmontools-support@lists.sourceforge.net, smartmontools-database-owner@lists.sourceforge.net, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Fri, 12 Dec 2008, Pavel Machek wrote:

>
> Hi!
>
>> Due to the 100k write cycle lifetime, I will not be performing any more
>> benchmarks on the SSD itself, such benchmarks are available on
>> techreport.com but just wanted to send out the smart data for the
>> smartmontools list and point out it is working with linux+ich7+xfs.
>>
>> Overall, whenever I do anything now its just like the entire machine is
>> sitting in a ramdisk (similar when you boot knoppix and load to ramdisk).
>>
>> The techreport benchmarks are here:
>> http://techreport.com/articles.x/15931
>
> Actually I'd like to know... how does it behave during powerfails
> while it is being written to?
>
> Flashes I seen (USB / SD) developed bad sectors in that case, and
> ext2/ext3 can't handle that. (And I don't think xfs can handle that
> either).

I have a UPS for all of my machines, so that will not be a problem in my 
case.  I do not wish to trash a $720 SSD or my current install, if someone 
else wants to try feel free though :)

With barriers, presumably it would be safe-- but as always, a UPS/and 
barriers and/or RAID, there is no excuse not to have regular backups 
incase of a failure at any time..

I do recall however one instance where there was an apt-get dist-upgrade 
going and the power was cut to a machine on purpose (before/not 
using barriers) and suffice to say-- it got mucked/suffered many corruptions
all over the place.

Justin.
