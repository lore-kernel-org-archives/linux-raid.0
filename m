From: Michal Soltys <soltys@ziu.info>
Subject: Re: Data loss on MD RAID5 reshape?
Date: Sat, 13 Dec 2008 21:03:15 +0100
Message-ID: <49441503.5080208@ziu.info>
References: <20081205222131.GD8219@newbie.thebellsplace.net> <20081210192613.GC8354@newbie.thebellsplace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081210192613.GC8354@newbie.thebellsplace.net>
Sender: linux-raid-owner@vger.kernel.org
To: Bob Bell <b_linuxraid@thebellsplace.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bob Bell wrote:
> Anyone have anything to add regarding the email below, before I tear the 
> drives apart and start over?
> 
> On Fri, Dec 05, 2008 at 05:21:32PM -0500, Bob Bell wrote:
>> I've experienced apparent data loss, and hoping someone out there can 
>> help rescue my data, or at least tell me what went wrong so that I 
>> don't have a repeat event.  I first asked this question on linux-lvm, 
>> but the folks there seemed to think it pertained more to RAID than to 
>> LVM.
>>
>> I was setting up a new server running Ubuntu's Hardy Heron release.  
>> `uname -a` reports:
>>  Linux sherwood 2.6.24-16-server #1 SMP Thu Apr 10 13:58:00 UTC 2008 
>> i686  GNU/Linux
>>
>> I initially created an md RAID5 device with only two components 
>> (matching 320 GB SATA HDDs).  I created a single LVM Physical Volume 
>> using the entirety of that md device (320 GB), and then created 
>> several LVM Logical Volumes for different filesystems (all ext3).  
>> This was done using the Ubuntu installer.

[...]

>>
>> Did I do something wrong?  Is there anyway to rescue my data?  If 
>> there's no way of saving the data, I'd at least like to figure out 
>> what happened in the first place.
>>

The procedure you did seems allright. I just repeated it with few
GB volumes - and everything worked fine here.

Can you provide any more detailed info ? Such as how command lines
looked like, maybe there was something alarming in the logs, etc.

As for recovering the data - you might try dmsetup directly and create 
linear mapped volume, precisely 192KiB from the beginning, and with size 
of remaining raid volume, then check the size of the filesystem 
(assuming it exists at all ..). Unfortunately that assumes, that the LVs 
were not fragmented themselves, and that's quite optimistic assumption 
considering your whole procedure (lvresize, and I assume - resize2fs or 
equivalent for other filesystems).

Do you have any remaining data from the faulty lvm, in /etc/lvm/backup ? 
They could be quite helpful, regarding the positions/segments of all 
your old LVs.

Also check vgcfgbackup(8) and vgcfgrestore(8)
