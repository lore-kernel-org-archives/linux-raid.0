From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v2 0/6] a caching layer for raid5/6
Date: Tue, 19 May 2015 11:22:51 +0200
Message-ID: <555B00EB.9040303@intel.com>
References: <cover.1432003804.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1432003804.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

On 05/19/2015 04:57 AM, Shaohua Li wrote:
> Hi,
> 
> This is the second version of the raid5/6 caching layer patches. The patches add a
> caching layer for raid5/6. The caching layer uses a SSD as a cache for a raid
> 5/6. It works like the similar way of a hardware raid controller. The purpose
> is to improve raid performance (reduce read-modify-write) and fix write hole
> issue. The main patch is patch 3 and the description has all details about the
> implementation.
> 
> Main changes of V2 are to improve performance. Meta data write doesn't use FUA
> any more. Discard request is only dispatched when discard range is big enough.
> Also have some bug fixing and code cleanup. Please review!

Hi,

It seems patch 3 is missing.

Artur


