From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Superblock V 1.2
Date: Sun, 07 Nov 2010 21:39:03 +0000
Message-ID: <4CD71C77.4030400@anonymous.org.uk>
References: <20101107191507.GA31052@cons.org> <E9.7C.19545.72417DC4@cdptpa-omtalb.mail.rr.com> <20101107210852.GA77472@cons.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101107210852.GA77472@cons.org>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Cracauer <cracauer@cons.org>
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/11/2010 21:08, Martin Cracauer wrote:
> Thanks, Leslie,
>
> Leslie Rhorer wrote on Sun, Nov 07, 2010 at 03:03:39PM -0600:
>>
>>> Can I read that array if I ever connect the machine to an older
>>> kernel/mdadm?
>>
>> 	That depends on just how old.  The new superblocks have been
>> supported for quite some time.  Worst case you will need to upgrade the old
>> kernel to a newer one.
>
> Is mdadm actually involved? If I have a new enough kernel but an old
> mdadm, will the kernel code alone be enough to start the array?
>
> I guess it should since it can start the arrays at boot time with no
> mdadm involved.

That's the other difference between 0.90 and 1.x metadata. In-kernel 
auto-assembly is only available for 0.90, and Neil Brown has made it 
clear that there will never be in-kernel auto-assembly for 1.x, and 
explained at length why. You need mdadm to start 1.x arrays, in your 
initrd if your root filesystem is on such an array. All modern distros 
create suitable initrds automatically. We are moving towards having 
array assembly handled by udev invoking mdadm as devices are discovered.

Cheers,

John.

