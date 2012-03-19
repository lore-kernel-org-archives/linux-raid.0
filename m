From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: lib/raid6: SSSE3 optimized recovery functions v1
Date: Mon, 19 Mar 2012 15:44:12 -0700
Message-ID: <4F67B6BC.4070006@zytor.com>
References: <1332180649-9709-1-git-send-email-james.t.kukunas@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332180649-9709-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/19/2012 11:10 AM, Jim Kukunas wrote:
> Hi Folks,
> 
> The following patchset adds SSSE3 optimized recovery
> functions to RAID6.
> 
> This version differs from version 0, in that the build fix for the
> test program was split into a separate patch.
> 
> A technical description of the algorithm can be found
> at http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
> 

Reviewed-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
