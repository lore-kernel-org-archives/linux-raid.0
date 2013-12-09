From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Raid1 where Event Count off my 1 cannot assemble --force
Date: Mon, 09 Dec 2013 14:12:10 +1100
Message-ID: <52A5350A.2020504@websitemanagers.com.au>
References: <52A44778.8040502@suddenlinkmail.com> <alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se> <52A4B311.6040204@suddenlinkmail.com> <52A51122.3030604@suddenlinkmail.com> <52A51442.1000903@websitemanagers.com.au> <52A52D35.7060909@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A52D35.7060909@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/12/13 13:38, David C. Rankin wrote:
> On 12/08/2013 06:52 PM, Adam Goryachev wrote:
>> Have you tried this:
>>
>> mdadm --verbose --assemble /dev/md1 /dev/sdb5
>> mdadm --manage /dev/md1 --run
>>
>> Being raid1, you should be able to use only a single device....
>>
>>
>> BTW, chances to recover your data should be exceptional, as long as you don't do
>> anything too silly. You should even be able to mount the device directly
>> (read-only):
>> mount -o ro /dev/sdb5 /mnt
>>
>> (Depending on the content is a filesystem).
>> Then you can just backup the data, create a new array, and restore the data.
>> Depending on data and size this might even be a better option...
> nemtemp:/mnt # mount -o ro /dev/sdb5 /mnt/sdb/
> mount: unknown filesystem type 'linux_raid_member'
> nemtemp:/mnt # mount -t ext3 -o ro /dev/sdb5 /mnt/sdb/
>
>
>    Now since I can mount it, how in the heck do I get the raid put back together.
> Seems really simple, but I'm stuck... Try with a newer mdadm?
>
Probably the best option is to follow Neil's advise to use mdadm from 
git....

The alternative as I mentioned is to backup the data, re-create the raid 
+ filesystem, and then restore the data.
>> BTW, the bitmap location looks.... strange...
>    I thought so too, but checking the other arrays, /dev/md2 has a negative
> number as well:
>
> nemtemp:/mnt # mdadm -E /dev/sda7
> /dev/sda7:
> <snip>
> Internal Bitmap : -213 sectors from superblock
>      Update Time : Mon Dec  9 02:14:18 2013
It looks strange when I first saw it, but now that I think about it, it 
is probably right (correct) since 1.0 metadata is at the very end of the 
drive, so the bitmap is probably before the metadata, hence negative offset.


-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
