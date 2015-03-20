From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [Linux-nvdimm] [RFC PATCH 0/7] evacuate struct page from the
 block layer
Date: Fri, 20 Mar 2015 17:32:03 +0000
Message-ID: <550C5993.9030104@youngman.org.uk>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>	<20150318132650.3336261c58829f49a9af8675@linux-foundation.org>	<20150319134313.GF4003@linux.intel.com>	<550AF127.9010504@plexistor.com> <20150319125917.6cc2bf02687aab542027d8ac@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150319125917.6cc2bf02687aab542027d8ac@linux-foundation.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Boaz Harrosh <boaz@plexistor.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-arch@vger.kernel.org, axboe@kernel.dk, riel@redhat.com, hch@infradead.org, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On 19/03/15 19:59, Andrew Morton wrote:
> This is all contingent upon the prevalence of machines which have vast
> amounts of nv memory and relatively small amounts of regular memory. 
> How confident are we that this really is the future?

Somewhat off-topic, but it's also the past. I can't help thinking of the
early Pick machines, which treated backing store as one giant permanent
virtual memory. Back when 300Mb hard drives were HUGE.

Cheers,
Wol


