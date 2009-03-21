From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF
	multiplication
Date: Sat, 21 Mar 2009 15:14:24 -0700
Message-ID: <e9c3a7c20903211514p60fda2fbhc5039c16f708e81d@mail.gmail.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <49C26D91.10804@intel.com>
	 <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com>
	 <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com>
	 <49C425F5.8060309@intel.com> <49C42F99.5010700@emcraft.com>
	 <49C45159.8020503@zytor.com>
	 <e9c3a7c20903210819r222cd4acwb466d2a11d3388f6@mail.gmail.com>
	 <49C53CC0.5060303@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49C53CC0.5060303@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ilya Yanok <yanok@emcraft.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "Sosnowski, Maciej" <maciej.sosnowski@intel.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

On Sat, Mar 21, 2009 at 12:15 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Why does it? =A0I don't see why you'd need to cover the vector-vector=
 case
> at all, since it doesn't appear anywhere in the algorithms. =A0Certai=
nly
> going backwards from a vector-vector set to derive if you can do a
> scalar-vector multiply when you should have known that in the first
> place is not really useful.
>
>>
>> Looking closer, the only other caller, async_pq_zero_sum, can be
>> deleted because it has no users. =A0So async_pq can become a static
>> routine in async_r6recov.
>>
>
> That's another issue entirely, of course :)
>

=2E..ah, but now I see your point and the root cause of the problem.
The caller needs to be modified to only require scalar multiplication
even in this corner case.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
