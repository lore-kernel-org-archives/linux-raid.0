From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS on x86_64 Linux Question
Date: Sat, 28 Apr 2007 12:41:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0704281241100.11586@p34.internal.lan>
References: <Pine.LNX.4.64.0704280633510.7998@p34.internal.lan>
 <p73lkgc1k2s.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <xfs-bounce@oss.sgi.com>
In-Reply-To: <p73lkgc1k2s.fsf@bingen.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>, linux-raid@linux-kernel.vger.kernel.org
List-Id: linux-raid.ids



On Sat, 28 Apr 2007, Andi Kleen wrote:

> Justin Piszcz <jpiszcz@lucidpixels.com> writes:
>
>> Had a quick question, if I re-provision a host with an Intel Core Duo
>> CPU with x86_64 Linux; I create a software raid array and use the XFS
>> filesystem-- all in 64bit space...
>>
>> If I boot a recovery image such as Knoppix, it will not be able to
>> work on the filesystem correct?  I would need a 64bit live CD?
>
> There used to be a XFS bug that 32bit journals couldn't
> be replayed on 64bit and vice versa. This means you couldn't mount
> a dirty file system on the other architecture. But this bug has been
> long fixed and mounting clean file systems always worked.
>
> -Andi
>

Thanks for the prompt reply!  I have more confidence in trying x86_64 now 
:)

Justin.
