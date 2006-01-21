From: David Greaves <david@dgreaves.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Sat, 21 Jan 2006 00:42:03 +0000
Message-ID: <43D1835B.1040105@dgreaves.com>
References: <Pine.LNX.4.33.0601200326590.17229-100000@pegasus.teamwerk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33.0601200326590.17229-100000@pegasus.teamwerk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andre' Breiler <andre.breiler@null-mx.org>, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre' Breiler wrote:

>Hi,
>
>On Fri, 20 Jan 2006, Reuben Farrelly wrote:
>  
>
>>On 20/01/2006 11:32 a.m., Neil Brown wrote:
>>    
>>
>>>The in-kernel autodetection in md is purely legacy support as far as I
>>>am concerned.  md does volume detection in user space via 'mdadm'.
>>>      
>>>
>>Hrm.  <puzzled look>   How would I then start my md0 raid-1 array that is
>>mounted as the root partition / if I'm not doing this when the kernel is
>>starting up?  Because without it I've got no userspace to actually execute.
>>    
>>
>
>Indeed you won't be able to use a 'plain kernel' anymore but switch to
>kernel + initrd.
>  
>
I understand the anti-autodetect arguments and was easily persuaded by
them...

Can I however suggest  we have autodetect only actually triggers if the
kernel is supplied with the UUID of an md0 as a boot option.
ie: root=/dev/md0 md0=b87a211e:8a9bef34:ccc334d8:f84216d6

I'm not sure I ever saw this proposed during the debate.

It's just *so* nice not to have to bother with initrd (having just moved
to a mirrored root and finding it wonderfully easy to specify
root=/dev/md0 and have it 'just work')

It looks easy enough to add into autorun_devices() in md.c

Maybe then deprecate autodetect more quickly by having it optional in
2.6.17(?) - but if even one UUID *is* specified then no other devices
are autodetected. Eventually having no devices autodetected *unless* a
UUID is specified (for convenience printk the UUIDs of devices that
*are* found just in case you mistype it...)

Please forgive me if I've missed the reason that this is a bad idea.

David

-- 

