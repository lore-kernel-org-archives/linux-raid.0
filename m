From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Date: Thu, 29 Nov 2012 14:28:10 -0800
Message-ID: <50B7E17A.2020609@zytor.com>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com> <m2obigf9xa.fsf@firstfloor.org> <50B7CFF8.7010401@zytor.com> <20121129211828.GZ16230@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121129211828.GZ16230@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>, Linux Raid <linux-raid@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 11/29/2012 01:18 PM, Andi Kleen wrote:
> 
>> Either way, this implementatin technique was used for the MMX/SSE
>> implementations without any problems for 9 years now.
> 
> It's still wrong.
> 
> Lying to the compiler usually bites you at some point.
> 

It's not lying to the compiler.  It is telling the compiler "do
something that you have no way of knowing about".

It would be lying to the compiler if the compiler was allowed to touch
the FPU state, but it's not.

	-hpa
