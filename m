From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC]md: using GFP_NOIO to allocate bio for flush request
Date: Tue, 8 May 2012 12:31:18 -0700
Message-ID: <CAA9_cmc4eT=uwXNdupkxK9_NWW4TLVab5-NBojL9PydHs73zfA@mail.gmail.com>
References: <4F8BAED6.9090105@kernel.org>
	<20120508101800.GB9757@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120508101800.GB9757@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids

On Tue, May 8, 2012 at 3:18 AM, Shaohua Li <shli@kernel.org> wrote:
> On Mon, Apr 16, 2012 at 01:32:06PM +0800, Shaohua Li wrote:
>>
>> flush request is issued in transaction commit code path usually, so
>> looks using
>> GFP_KERNEL to allocate memory for flush request bio falls into the classic
>> deadlock issue. dm already gets it right.
> ping!
>

This one should probably also be queued for -stable right?
