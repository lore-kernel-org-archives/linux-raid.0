From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: arch/86: AVX RAID5 xor checksumming
Date: Tue, 10 Apr 2012 14:20:14 -0700
Message-ID: <4F84A40E.8040907@zytor.com>
References: <1334078551-6859-1-git-send-email-james.t.kukunas@linux.intel.com> <4F846FBC.9060503@zytor.com> <20120411061442.2f839c77@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120411061442.2f839c77@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/2012 01:14 PM, NeilBrown wrote:
>>
>> I think this (and the SSSE3 patches for RAID-6) should go in via the
>> RAID tree.  Neil, do you agree?
> 
> I'm happy to take the SSSE3 RAID-6 patches as they only affect lib/raid6, but
> I felt that this one - being purely in arch/x86 - should probably go via the
> x86 tree.
> However I'm flexible and if you (collectively) are happy with these patches
> going in through my tree, I'll do that.
> 

Go ahead and take them with my Acked-by: -- I think that's easier.

	-hpa
