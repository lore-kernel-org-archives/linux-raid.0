From: "NeilBrown" <neilb@suse.de>
Subject: Re: Rebuild after a drive replacement
Date: Mon, 9 Jun 2008 19:04:38 +1000 (EST)
Message-ID: <32774.192.168.1.70.1213002278.squirrel@neil.brown.name>
References: <1212958349.7596.14.camel@gdh-home>
    <38060.192.168.1.70.1212963930.squirrel@neil.brown.name>
    <1212999164.15461.2.camel@gdh-work>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1212999164.15461.2.camel@gdh-work>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Hamill <gdh@acentral.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, June 9, 2008 6:12 pm, Gavin Hamill wrote:
> On Mon, 2008-06-09 at 08:25 +1000, NeilBrown wrote:
>
>> > eddie:~# mdadm --add /dev/md3 /dev/hde5
>> > mdadm: add new device failed for /dev/hde5 as 3: Invalid argument
>>
>> Do you get any kernel messages when this fails?
>>    dmesg | tail
>
> Yes indeed...
>
> md: hde5 has invalid sb, not importing!
> md: md_import_device returned -22

Thanks.

I suspect the partition is slightly too small.
Check the sizes in /proc/partitions.

hde5 needs to be at least 174851136K.

Newer version of mdadm notice this and report a better
error message (I think 2.6.3 contains the fix).

So: you might need to repartition the drive and make hde5 a
little bigger.

NeilBrown

