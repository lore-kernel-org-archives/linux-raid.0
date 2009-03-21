From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF
	multiplication
Date: Sat, 21 Mar 2009 15:46:12 -0700
Message-ID: <e9c3a7c20903211546k75b5ac48uab083303b6ec5746@mail.gmail.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com>
	 <49C425F5.8060309@intel.com> <49C42F99.5010700@emcraft.com>
	 <49C45159.8020503@zytor.com>
	 <e9c3a7c20903210819r222cd4acwb466d2a11d3388f6@mail.gmail.com>
	 <49C53CC0.5060303@zytor.com>
	 <e9c3a7c20903211514p60fda2fbhc5039c16f708e81d@mail.gmail.com>
	 <49C5699C.8050405@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49C5699C.8050405@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ilya Yanok <yanok@emcraft.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "Sosnowski, Maciej" <maciej.sosnowski@intel.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

On Sat, Mar 21, 2009 at 3:26 PM, Ilya Yanok <yanok@emcraft.com> wrote:
>> The caller needs to be modified to only require scalar multiplication
>> even in this corner case.
>>
>
> Argh... There is no vector-vector multiplication at all! You just need
> to swap the 'for' cycles back (as it was in the original patch by me and
> Yuri) to get rid of two-dimensional lookup at each step.

Yes, I swapped the loops as part of the removal of the
ASYNC_TX_ZERO_{P,Q} flags and wanted to avoid an explicit memset.
I'll rework this path...

Regards,
Dan
