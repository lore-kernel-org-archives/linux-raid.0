From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Is this likely to cause me problems?
Date: Tue, 21 Sep 2010 22:15:17 +0100
Message-ID: <4C992065.9000107@anonymous.org.uk>
References: <965992.31969.qm@web51304.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <965992.31969.qm@web51304.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/09/2010 21:33, Jon Hardcastle wrote:
> I am finally replacing an old and now failed drive with a new one.
>
> I normally create a partition the size of the entire disk and add that but whilst checking the sizes marry up i noticed that is an odity...
>
> Below is an fdisk dump of all the drives in my RAID6 array
>
> sdc---
> /dev/sdc1            2048  1953525167   976761560   fd  Linux raid autodetect
> ---
> Seems to be different to sda say which is also '1TB'
>
> sda---
> /dev/sda1              63  1953520064   976760001   fd  Linux raid autodetect
> ---
>
> Now i read somewhere that the sizes flucuate but as some core value remains the same can anyone confirm if this is the case?
>
> I am reluctant to add to my array until i know for sure...

Looks like you've used a different partition tool on the new disc than 
you used on the old ones - old ones started the first partition at the 
beginning of cylinder 1, new ones like to start partitions at 1MB so 
they're aligned on 4K sector boundaries and SSDs' erase group boundaries 
etc. You could duplicate the original partition table like this:

sfdisk -d /dev/older-disc | sfdisk /dev/new-disc

But it wouldn't cause you any problems, because the new partition is 
bigger than the old one, despite starting a couple of thousand sectors 
later. This in itself is odd - how did you come to not use the last 
chunk of your original discs?

Cheers,

John.

