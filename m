From: Kerin Millar <kerframil@gmail.com>
Subject: Re: raid10 make_request failure during iozone benchmark upon btrfs
Date: Mon, 02 Jul 2012 03:58:57 +0100
Message-ID: <4FF10E71.2090501@gmail.com>
References: <4FF108A8.6090606@gmail.com> <20120702125227.179c4343@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120702125227.179c4343@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On 02/07/2012 03:52, NeilBrown wrote:
> On Mon, 02 Jul 2012 03:34:16 +0100 Kerin Millar<kerframil@gmail.com>  wrote:
>
>> >  Hello,
>> >
>> >  I'm running a 4-way RAID-10 array with the f2 layout scheme on a 3.5-rc5
> I thought I fixed this in 3.5-rc2.
> Maybe there is another bug....
>
> Could you please double check that you are running a kernel with
>
> commit aba336bd1d46d6b0404b06f6915ed76150739057
> Author: NeilBrown<neilb@suse.de>
> Date:   Thu May 31 15:39:11 2012 +1000
>
>      md: raid1/raid10: fix problem with merge_bvec_fn
>
> in it?

I am indeed. I searched the list beforehand and noticed the patch in
question. Not sure which -rc it landed in but I checked my source tree
and it's definitely in there.

Cheers,

--Kerin
