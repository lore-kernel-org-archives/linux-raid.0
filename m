From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Growing after replacing with larger discs
Date: Sat, 13 Mar 2010 15:18:28 +0000
Message-ID: <4B9BACC4.8030608@anonymous.org.uk>
References: <4B9A7C63.6090202@anonymous.org.uk> <20100312180910.GA12002@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100312180910.GA12002@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/03/2010 18:09, Luca Berra wrote:
> On Fri, Mar 12, 2010 at 05:39:47PM +0000, John Robinson wrote:
>> Before I have to go to a customer's premises and try it, I wanted to 
>> ask if anyone had already done anything like this: I have a CentOS 5 
>> system with 0.90 metadata and type fd partitions with RAID-5 over 3 
>> discs. I want to grow it by replacing the drives. If I dd the small 
>> partitions onto larger ones on the new discs, then reboot, will the 
>> system recognise the RAID-5 - which now has its metadata somewhere in 
>> the middle of the paritions not at the end - so that I can then --grow?
> I believe it won't work
> mdadm has no way to know where the metadata is in the above case.
> 
> you have to follow the painful procedure
> fail one drive (mdadm /dev/mdX --fail /dev/sdY)
> remove it (mdadm /dev/mdX --remove /dev/sdY)
> replace drive with larger one
> create larger partition
> add drive again (mdadm /dev/mdX --add /dev/sdY)
> wait for it to resync...
> ...and repeat until all drives have been replaced

Yeuch. That'll take forever, because I'd need to rebuild 3 times. I see 
two other options:
(1) dd the drives as I said originally, and when the system can't find 
the array on the bigger discs, recreate the array using the same options 
the original array had
(2) degrade the existing array to two discs, replace the soft-failed 
disc with one of the new discs, temporarily make a filesystem on it, 
copy the data; replace the other two discs, make a new array on them 
with a missing drive, copy the data back; scrub the temporarily-made 
filesystem and add the drive to the array.

Actually I think something along the lines of Majed B's suggestion - in 
this case hang a spare drive out the side of the chassis, and just copy 
twice - would be quicker than (2). But (1) should work, shouldn't it?

Cheers,

John.
