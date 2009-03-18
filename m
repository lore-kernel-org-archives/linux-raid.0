From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 00/13] Asynchronous raid6 acceleration (part 1 of 2)
Date: Thu, 19 Mar 2009 00:43:39 +0100
Message-ID: <87ljr21jo4.fsf@basil.nowhere.org>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com> (Dan Williams's message of "Wed, 18 Mar 2009 12:20:16 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Dan Williams <dan.j.williams@intel.com> writes:

> This series constitutes the pieces of the raid6 acceleration work that are
> aimed at the next merge window.  It implements:
> 1/ An api for asynchronous raid6 parity generation and recovery routines

Could you please comment a bit how well the default load balancing works. If
I write a single stream from a single CPU will it use multiple CPU
cores in the system to do the RAID6 work?

Thanks,

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
