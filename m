From: David Greaves <david@dgreaves.com>
Subject: Re: RAID 5 re-add of removed drive? (failed drive replacement)
Date: Mon, 08 Jun 2009 10:19:39 +0100
Message-ID: <4A2CD7AB.1000504@dgreaves.com>
References: <20090602111729.GA15172@cthulhu.home.robinhill.me.uk> <C840D176-51A0-4AFD-8AD0-1F1D2CAA830D@hispeed.ch> <20090602131037.GB15172@cthulhu.home.robinhill.me.uk> <49F571CD-BD24-4F22-B13B-CF6B0E24FFD5@hispeed.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F571CD-BD24-4F22-B13B-CF6B0E24FFD5@hispeed.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Rietsch <Alexander.Rietsch@hispeed.ch>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org, Sujit Karataparambil <sjt.kar@gmail.com>
List-Id: linux-raid.ids

Alexander Rietsch wrote:
> On 02.06.2009, at 15:10, Robin Hill wrote:
> 
>> Almost - you'll also need to specify "missing" for disc 6 (and the
>> --assume-clean isn't actually needed in this case, as the array can't do
>> any reconstruction with a missing drive), so:
>>
>>    mdadm --create /dev/md0 --level=5 --chunk=64 --raid-devices=7
>>    /dev/sdi1 /dev/sdl1 /dev/sdh1 /dev/sdj1 /dev/sdk1 /dev/sdg1 missing
> 
> Yes, that's it! The RAID is alive! Mr. Robin Hill, you're a HERO!
> 
> With this trick, it's possible to recover a RAID which was confused by a
> data error during disk-replacement. I'll note this somewhere.

Maybe:
  http://linux-raid.osdl.org/

:)

I've not had time to update it recently.

Sujit Karataparambil wrote:
> http://www.tldp.org/HOWTO/Software-RAID-HOWTO-3.html
>
> This is the RAID Documentation which I found very less suffiecient.

I spent some considerable time trying to get that resolved but sadly they were
of the opinion that it is better for tldp to provide misleading docs rather than
no docs or a link to better docs. I updated it and moved it to the link above.

Sujit Karataparambil wrote:
> Kindly Read the document correctly and throughly.
>
> raidhotadd /dev/mdX /dev/sdb
nb this is very very old unsupported software and it may not be wise to suggest it.

David

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
