From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: arch/86: AVX RAID5 xor checksumming
Date: Tue, 10 Apr 2012 10:37:00 -0700
Message-ID: <4F846FBC.9060503@zytor.com>
References: <1334078551-6859-1-git-send-email-james.t.kukunas@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1334078551-6859-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: x86@kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/2012 10:22 AM, Jim Kukunas wrote:
> Hi Folks,
> 
> The following patch adds an AVX implementation of the RAID5 xor checksumming
> functions.
> 
> Based on xor_speed, the AVX implementation appears to be ~32% faster than the
> SSE implementation on my i7 2600:
> 
>         generic_sse: 15088.000 MB/sec
> 	avx: 19936.000 MB/sec
> 
> Thanks.
> 

I think this (and the SSSE3 patches for RAID-6) should go in via the
RAID tree.  Neil, do you agree?

However,

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
