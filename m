From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC 1/2] MD: raid5 trim support
Date: Tue, 17 Apr 2012 23:07:10 +0800
Message-ID: <4F8D871E.2050403@kernel.org>
References: <20120417083552.483324288@kernel.org> <20120417084632.306032602@kernel.org> <CABE8wwswKWQ=LDbx0ysTaZf2Hz0jD_q45FNF0jw96ZwZdJiHPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwswKWQ=LDbx0ysTaZf2Hz0jD_q45FNF0jw96ZwZdJiHPw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

Hi Dan,
On 4/17/12 10:46 PM, Dan Williams wrote:
> On Tue, Apr 17, 2012 at 1:35 AM, Shaohua Li<shli@kernel.org>  wrote:
>> Discard for raid4/5/6 has limitation. If discard request size is small, we do
>> discard for one disk, but we need calculate parity and write parity disk.  To
>> correctly calculate parity, zero_after_discard must be guaranteed.
>
> I'm wondering if we could use the new bad blocks facility to mark
> discarded ranges so we don't necessarily need determinate data after
> discard.

It would be great the limitation can be avoided and the code can be
simplified. I didn't follow linux-raid maillist, can you point me the url
of the new bad blocks facility please?

Thanks,
Shaohua
