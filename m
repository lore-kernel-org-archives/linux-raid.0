From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID Recovery
Date: Wed, 8 Mar 2017 20:08:10 +1100
Message-ID: <c9a70435-56a5-9295-2582-7b71a71619eb@websitemanagers.com.au>
References: <936e84af-f190-3541-bdf8-eaa0c42d2ddc@websitemanagers.com.au>
 <e4d9724d-ab52-aa79-c600-7b287c16a182@turmel.org>
 <7cefe670-dcea-6e04-b090-b215a6a218c9@websitemanagers.com.au>
 <94b4591a-bda1-529b-3af1-c451b657082f@websitemanagers.com.au>
 <1066d485-ebea-d0d2-a198-33b560de99fc@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1066d485-ebea-d0d2-a198-33b560de99fc@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 8/3/17 02:00, Phil Turmel wrote:
> Hi Adam,
>
> {Please remember to trim repetitive stuff, and interleave.}
>
> On 03/07/2017 09:06 AM, Adam Goryachev wrote:
>> BTW, just some more info I've found... either almost the entire
>> drives are RAID1 mirrors, or all 4 are RAID1 mirrors:

OK, so I now have the following:
root@ubuntu:~# cmp /dev/sda /dev/sdb
/dev/sda /dev/sdb differ: byte 1000162959365, line 243319233
root@ubuntu:~# cmp /dev/sdc /dev/sdd
/dev/sdc /dev/sdd differ: byte 1000162971653, line 243236929
root@ubuntu:~# cmp /dev/sdb /dev/sdc
/dev/sdb /dev/sdc differ: byte 499637813249, line 54927275

So drives sda/sdb are almost complete mirror, and drives sdc/sdd are 
almost complete mirror.
On top of that, the first half of all four drives are a complete mirror 
(which seems oversized considering a "small" root RAID1 drive....)
Why there is a difference half way, and whether they are more difference 
after that point I haven't yet checked, but that looks like something to 
come back to...
>> Other option, they have been re-initialised/zero'd or similar, and
>> thats why all the data is identical (useless). I was hoping to get a
>> starting point for where the partition boundaries might have been
>> ....
> Search the devices for ext2/3/4 superblocks, like so:
>
> dd if=/dev/sdX bs=1M 2>/dev/null |hexdump -C |grep '30  .\+  53 ef 0'
What is the chance it is a ext2/3/4 based FS? I suppose most NAS would 
use these filesystems... I guess I'll find out soon enough.

> This will take a very long time, and will generate false positives.
Can you advise what to do to "verify" these and work out which ones are 
false positives?
> You probably would want to use screen or tmux to run these in
> parallel in separate processes.
I'm not sure there is much of a point, since they are mostly duplicates 
of each other. I'm running it on sdd now, and copying sda and sdc to a 
spare drive. I may re-run the command on sdc (and skip the first 
490GB...) if nothing useful is found on sdd.
> But superblock locations will give you hints as to the rest of data,
> and make it possible to create partitions that will let you copy
> stuff off into a new array.
>
Sounds good, will see how it goes. Thanks for the advice!

Regards,
Adam
