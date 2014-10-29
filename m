From: micah <micah@riseup.net>
Subject: Re: Raid1 element stuck in (S) state
Date: Wed, 29 Oct 2014 10:03:16 -0400
Message-ID: <8761f3q8gr.fsf@muck.riseup.net>
References: <87k33lwq7s.fsf@muck.riseup.net> <20141029084224.6d92d8be@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141029084224.6d92d8be@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, micah anderson <micah@debian.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> On Mon, 27 Oct 2014 10:18:47 -0400 micah anderson <micah@debian.org> wrote:
>
>> 
>> Hi,
>> 
>> i've got a raid1 setup, where one drive died, it was replaced with a new
>> one, but its stuck in a (S) state and I can't seem to get it added into
>> the array, /proc/mdstat looks like this:
>> 
>> md3 : active raid1 sdc1[2](S) sdd1[1]
>>       976759672 blocks super 1.2 [2/1] [_U]
>> 
>> where sdc1 is the replaced drive.
>> 
>> What is the right way to get this added back?
>>
>
> I've a feeling this bug might have been fixed.
> What versions of mdadm and Linux are you using?

I'm using squeeze here, and had 3.1.4-1+8efb9d1+squeeze1 installed, I
just installed the backport, which is 3.2.5-3~bpo60+1.

> Are there any errors in the kernel logs when you --add the device?

After installing the backported 3.2.5, I tried to add it, and it said:

# mdadm --add /dev/md3 /dev/sdc1
mdadm: Cannot open /dev/sdc1: Device or resource busy

so I did a --remove of the drive, and then added it, it then proceeded
to sync the array, and after that finished, it is now back in the (S)
state.

Can I just zero the superblock of that device and re-add it in order to
resolve this?

thanks!
micah
