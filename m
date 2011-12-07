From: "Richard B. Pyne" <rpyne@kinfolk.org>
Subject: Re: system startup hangs
Date: Wed, 07 Dec 2011 16:24:52 -0700
Message-ID: <4EDFF5C4.10602@kinfolk.org>
References: <4EDFEACD.3010806@kinfolk.org> <20111208100033.69c42b6c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111208100033.69c42b6c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 12/7/2011 4:00 PM, NeilBrown wrote:
> On Wed, 07 Dec 2011 15:38:05 -0700 "Richard B. Pyne"<rpyne@kinfolk.org>
> wrote:
>
>> Please forgive me if I ask stupid questions, I am fairly new to linux
>> raid and most of the documentation I can find is severely outdated
>> and/or written for someone who already understands linux raid.
>>
>> I have successfully built a set raid 6 array with 4 drives and have
>> copied my system partitions onto the raid drives. I then reboot with
>> root=/dev/md0.
>>
>> Everything looks like it is working right up through:
>>
>> md/raid:md0 raid level 6 active with 4 out of 4 devices, algorithm 2
>> md0: detected capacity change from 0 to 1000131788
>> md: autorun DONE.
>> md0: unknown partition table
>> EXT3-fs (md0): error: couldn't mount because of unsupported optional
>> features
>> EXT2-fs (md0): error: couldn't mount because of unsupported optional
>> features
>> EXT4-fs (md0): mounted filesystem with ordered data mode.  Opts: (null)
>> VFS: Mounted root (ext4 filesystem) readonly on device 9:0.
>> freeing unused kernel memory: 472k freed
> It looks like the array got setup fine, the filesystem on it was mounted, and
> then .... nothing.
>
> I think at this point it should be running /sbin/init.
>
> It doesn't seem like a RAID problem exactly.  Maybe something when wrong when
> you copying the system partition into the RAID, but that is just a guess.
>
> At this point we probably need to know at least what distro you are using.
> There is probably some way to turn on tracing in the initrd and the boot
> sequence, but it is different for different distros.
>
> NeilBrown
>
I am using lunar linux. ( http://lunar-linux.org ). The kernel is 3.1.4 
x86_64 confiugred with raid autodetect and the raid sets were built with 
-e 0.90.

--Richard
