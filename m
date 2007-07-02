From: David Greaves <david@dgreaves.com>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
Date: Mon, 02 Jul 2007 15:32:26 +0100
Message-ID: <46890C7A.5040008@dgreaves.com>
References: <46744065.6060605@dgreaves.com> <4684C0DD.4080702@dgreaves.com> <4688D9F2.6020000@gmail.com> <200707021608.56616.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200707021608.56616.rjw@sisk.pl>
Sender: linux-raid-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <htejun@gmail.com>, David Chinner <dgc@sgi.com>, David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Rafael J. Wysocki wrote:
> On Monday, 2 July 2007 12:56, Tejun Heo wrote:
>> David Greaves wrote:
>>>> Tejun Heo wrote:
>>>>> It's really weird tho.  The PHY RDY status changed events are coming
>>>>> from the device which is NOT used while resuming
>>> There is an obvious problem there though Tejun (the errors even when sda
>>> isn't involved in the OS boot) - can I start another thread about that
>>> issue/bug later? I need to reshuffle partitions so I'd rather get the
>>> hibernate working first and then go back to it if that's OK?
>> Yeah, sure.  The problem is that we don't know whether or how those two
>> are related.  It would be great if there's a way to verify memory image
>> read from hibernation is intact.  Rafael, any ideas?
> 
> Well, s2disk has an option to compute an MD5 checksum of the image during
> the hibernation and verify it while reading the image.
(Assuming you mean the mainline version)

Sounds like a good think to try next...
Couldn't see anything on this in ../Documentation/power/*
How do I enable it?


>  Still, s2disk/resume
> aren't very easy to install  and configure ...

I have it working fine on 2 other machines now so that doesn't appear to be a 
problem.

David
