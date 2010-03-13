From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Growing after replacing with larger discs
Date: Sat, 13 Mar 2010 18:13:20 +0000
Message-ID: <4B9BD5C0.2050902@anonymous.org.uk>
References: <4B9A7C63.6090202@anonymous.org.uk> <20100312180910.GA12002@maude.comedia.it> 	<4B9BACC4.8030608@anonymous.org.uk> <70ed7c3e1003130721u29cf938ep9313a10078ee5e52@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e1003130721u29cf938ep9313a10078ee5e52@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/03/2010 15:21, Majed B. wrote:
> You should never degrade the array to copy its contents. Its very
> risky. There might be bad sectors on one or more disks and if you
> don't have all disks at hand, you may not be able to rebuild the array
> on the new disk.

OK that's fair, you're right I don't want to risk losing data because I 
was using a degraded array.

> As for using dd, as others have pointed, the metadata won't be in
> place and if you create a new array after using dd, it'll still
> require a resync and the data will be destroyed.

I don't see whay either it'd require a resync - although I didn't say 
it, I was planning to zero the rest of the larger drives and recreate 
with --assume-clean - nor why data would be destroyed if I didn't create 
with --assume-clean, after all the data will all be in the right place.

But I think on balance I'm going to save the contents of the original 
array to an extra drive, create a new array on the big discs, and copy 
the data back. It shouldn't take too much more time than copying the 
discs individually with dd, even though I'm copying the data twice 
rather than once, and it's both safer and gives me a free defrag.

Cheers,

John.
