From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: lib/raid6: SSSE3 optimized recovery functions v2
Date: Thu, 12 Apr 2012 13:14:05 -0700
Message-ID: <4F87378D.7080505@zytor.com>
References: <20120412161805.133c4ad0@notabene.brown> <1334261073-14781-1-git-send-email-james.t.kukunas@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334261073-14781-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 04/12/2012 01:04 PM, Jim Kukunas wrote:
> 
> This keeps with the existing code conventions. The code block is:
> 
> extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
> extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
> extern const u8 raid6_gfexp[256]      __attribute__((aligned(256)));
> extern const u8 raid6_gfinv[256]      __attribute__((aligned(256)));
> extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));
> 
>> WARNING: printk() should include KERN_ facility level
>> #120: FILE: lib/raid6/algos.c:103:
>> +		printk("raid6: using %s recovery algorith\n", nest->name);
>>
>> WARNING: printk() should include KERN_ facility level
>> #122: FILE: lib/raid6/algos.c:105:
>> +		printk("raid6: Yikes! No recovery algorithm found!\n");
>>
>> WARNING: printk() should include KERN_ facility level
>> #159: FILE: lib/raid6/algos.c:176:
>> +		printk("raid6: Yikes!  No memory available.\n");
> 
> Again, these are following the conventions of the existing code such as:
> 
> printk("raid6: using algorithm %s (%ld MB/s)\n",
> 
> In fact, the last printk, about no memory available, was simply moved to a 
> different line in my patch.
> 

A lot of the RAID-6 code predates the modern kernel conventions.  It
would be good to clean that up, but that is largely orthogonal to this
patch.

	-hpa

