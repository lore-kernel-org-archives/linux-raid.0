From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] klibc update
Date: Tue, 16 Mar 2004 11:34:10 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40572C82.6020505@pobox.com>
References: <4056B0DB.9020008@pobox.com> <20040316005229.53e08c0c.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040316005229.53e08c0c.akpm@osdl.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, viro@parcelfarce.linux.theplanet.co.uk, greg@kroah.com, bos@serpentine.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Morton wrote:
> Jeff Garzik <jgarzik@pobox.com> wrote:
> 
>>Too big to post,
>>
>> http://www.kernel.org/pub/linux/kernel/people/jgarzik/patchkits/2.6/2.6.5-rc1-klibc1.patch.bz2
>> 	or
>> bk://kernel.bkbits.net/jgarzik/klibc-2.5
>>
>> IIRC, this is:  my update of Bryan O'Sullivan's update of Greg KH's 
>> update of my merge of hpa's and viro's hacking :)
>>
>> WRT overall klibc merge:  when it can do md RAID autorun, it's 
>> mergeable.  And didn't somebody write a tiny mdctl program...
> 
> 
> It's so long since klibc was discussed (ie: more than five minutes ago)
> that I forget the reasons why it should be delivered via the kernel tree.
> 
> Remind me please?

Several reasons.  The big one in my mind is, it will be delivering 
pieces without which the kernel will not boot, so you really really want 
to keep that software in sync with the latest kernel...  at least until 
all the details are worked out.  Otherwise version skew will as we 
remove code from the kernel and move it to userspace will be painful -- 
users would be rebuilding their external klibc trees just about every 
day, as code was moved from kernel to early-userspace.

	Jeff




