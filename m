From: Eli Morris <ermorris@ucsc.edu>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Thu, 8 Dec 2011 22:58:37 -0800
Message-ID: <109C0559-A65A-41D3-B132-4467B39A6207@ucsc.edu>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu> <20111208075709.587ac227@notabene.brown> <654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu> <20111208091651.2a56dd5b@notabene.brown> <2866C99D-B573-4EF3-8FD0-0A40B0C20118@ucsc.edu> <20111209065140.107aa286@notabene.brown> <46200D05-2D7F-44F8-9323-DCFF720776D2@ucsc.edu> <20111209075931.29b26b5e@notabene.brown> <D1EB6C45-E127-4EC6-BFDD-BDFCC4607981@ucsc.edu> <20111209095033.06136f92@notabene.brown> <E88BF285-4224-45F8-952A-0248E7025BDD@ucsc.edu> <20111209142006.7ad399f9@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111209142006.7ad399f9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Dec 8, 2011, at 7:20 PM, NeilBrown wrote:

> On Thu, 8 Dec 2011 15:03:54 -0800 Eli Morris <ermorris@ucsc.edu> wrote:
> 
>> 
>> Hi Neil,
>> 
>> Thanks. I have:
>> 
>> mdadm - v3.1.3 - 6th August 2010, which is the default up to date version on Centos 6.0
>> 
>> One question: is the command:
>> 
>>> mdadm --create /dev/md5 -l5 --layout=left-symmetric --chunk=512 \
>>> --raid-disks=16  --assume-clean /dev/sd[a-p]
>> 
>> Or 
>> 
>> mdadm --create /dev/md5 -l5 --layout=left-symmetric --chunk=512 \
>> --raid-disks=16  --assume-clean /dev/sd[a-p]1
>> 
>> 
>> 
>> Note that partition number on the drives: /dev/sd[1-p]1 instead of /dev/sd[a-p]
> 
> Yes, you are correct, you need the '1' at the end.
> Sorry, and thanks for being careful.
> 
> NeilBrown
> 

Wow. Thanks so much. I haven't verified the entire array, but it looks fine. I'm still really wondering what you think might have happened. As I mentioned, everything was OK and then the four drives just showed up as "removed" when I went to write to the filesystem on the array. Do you think it has to do with the hardware or is there something I can correct in software so that this won't happen again? I suspect hardware, since after it happened, I ran lsscsi and the four drives failed to show up on the list. These are the Caviar Green drives that people seem to have problems with in RAID arrays. I was thinking about changing the timeout tolerance in the OS to something several minutes long. Maybe you've seen something like this before? I'm just not sure what happened, but, as you might ima
 gine, I'm keen for it to not happen every few months.

Again, thank you. I'm grateful to have it working again.

Eli

