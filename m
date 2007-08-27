From: David Greaves <david@dgreaves.com>
Subject: Re: Patch for boot-time assembly of v1.x-metadata-based soft (MD)
 arrays: reasoning and future plans
Date: Mon, 27 Aug 2007 09:48:27 +0100
Message-ID: <46D28FDB.3060308@dgreaves.com>
References: <778663.11466.qm@web33606.mail.mud.yahoo.com> <e9c3a7c20708261732o2b962531obbf9ab370f195be8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20708261732o2b962531obbf9ab370f195be8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Abe Skolnik <abe_skolnik@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Williams wrote:
> On 8/26/07, Abe Skolnik <abe_skolnik@yahoo.com> wrote:
>>> Because you can rely on the configuration file to be certain about
>>> which disks to pull in and which to ignore.  Without the config file
>>> the auto-detect routine may not always do the right thing because it
>>> will need to make assumptions.
>> But kernel parameters can provide the same data, no?  After all, it is

> Yes, you can get a similar effect of the config file by adding
> parameters to the kernel command line.  My only point is that if the
> initramfs update tools were as simple as:
> mkinitrd "root=/dev/md0 md=0,v1,/dev/sda1,/dev/sdb1,/dev/sdc1"
> ...then using an initramfs becomes the same amount of work as editing
> /etc/grub.conf.
> 


I'm not sure if you're aware of this so in the spirit of being helpful I thought 
I'd point out that this has been discussed quite extensively in the past. You 
may want to take a look at the list archives.

It's quite complex and whilst I too would like autodetect to continue to work 
(I've been 'bitten' by the new superblocks not autodetecting) I accept the 
arguments of those wiser than me.

I agree that the problem is one of old dogs and the new (!) initram trick.
Look at it as an opportunity to learn more about a cool capability.

David
