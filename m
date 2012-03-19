From: qing gu <qing.gu@oracle.com>
Subject: Re: [PATCH]: md: Initialize ctl_name field of table raid_root_table/raid_dir_table
 to avoid dump_trace info in debug kernel
Date: Mon, 19 Mar 2012 11:26:11 +0800
Message-ID: <4F66A753.4000004@oracle.com>
References: <4F5D747D.9060508@oracle.com> <20120314125720.1bb87546@notabene.brown> <m14ntsc4k2.fsf@fess.ebiederm.org> <20120314133501.14c6f7e9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120314133501.14c6f7e9@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
List-Id: linux-raid.ids

Very thanks for the reply.

Neil

On 2012/3/14 10:35, NeilBrown wrote:
> On Tue, 13 Mar 2012 19:14:05 -0700 ebiederm@xmission.com (Eric W. Biederman)
> wrote:
>
>> NeilBrown<neilb@suse.de>  writes:
>>
>>> On Mon, 12 Mar 2012 11:58:53 +0800 qing gu<qing.gu@oracle.com>  wrote:
>>>
>>>> This patch is used to dispense trace info when system boots with debug
>>>> kernel. I have verified it on RHEL6.2&  SLES11.2. Both work fine.
>>>> In the failure case, system logs that:
>>>>
>>>>      /Feb 21 19:33:55 nsgbj-216-137 kernel: sysctl_check_dir: failed: /dev  ref: /dev .7
> .....
>
>>> These lines were removed in November 2009 by Eric Biederman in
>>> commit 894d2491153a9f8270dbed21175d06fde4eba6c7
>>>
>>> So I'm not keen on adding them back without understanding the history.
>>>
>>> Eric:  Do we need these after all?
>> For the main trunk no.  The .ctl_name field no longer exists.
>>
>> kernel/binary_sysctl.c is used to provide backwards compatibility with
>> the old binary names.
>>
>> There might be a point for doing something in -stable or someone's
>> enterprise kernel if some messed up set of backports were merged.
>>
>> Eric
> Thanks for the quick response Eric!!
>
> Qing: It looks like this is not an issue in mainline.
>    If you want to get something fixed in SLES or RHEL, I suggest you log an
>    issue in the relevant bugzillas (though I just checked SLES11-SP2, and
>    it doesn't mention sysctl_check_dir at all).
>
> NeilBrown
