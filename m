From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Kernel oops adding bitmap
Date: Mon, 19 Mar 2012 16:40:23 -0500
Message-ID: <4F67A7C7.1050803@nuclearwinter.com>
References: <4F67627D.8050205@nuclearwinter.com> <20120320083210.4a272426@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120320083210.4a272426@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/19/2012 4:32 PM, NeilBrown wrote:
> On Mon, 19 Mar 2012 11:44:45 -0500 Larkin Lowrey
<llowrey@nuclearwinter.com>
> wrote:
>
>> The following command oopsed.
>>
>> mdadm -G --bitmap=internal /dev/md0
>>
>> The array is a two disk raid1 and hosts the root filesystem.
>>
>> Is it not possible/allowed to add a bitmap to an active/mounted array?
>
> It is. But it is busted.
>
> Either use an older mdadm (3.2.2 or earlier), or apply this patch
>
> http://neil.brown.name/git?p=md;a=commitdiff;h=4474ca42e2577563a919fd3ed782e2ec55bf11a2
>
> which has been sent to Linus already and should appear in -stable
kernels in
> a couple of weeks.
>
> NeilBrown

Thank you for the explanation.

--Larkin

