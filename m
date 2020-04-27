From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v2] md/raid0: add config parameters to specify zone layout
Date: Mon, 27 Apr 2020 16:59:54 -0400
Message-ID: <694314ee-bd47-94a4-4c39-038a792a56fe@akamai.com>
References: <1585584045-11263-1-git-send-email-jbaron@akamai.com>
 <81A991E8-B87E-4518-9643-45037A104981@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <81A991E8-B87E-4518-9643-45037A104981@fb.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: "rdunlap@infradead.org" <rdunlap@infradead.org>, "neilb@suse.de" <neilb@suse.de>, "guoqing.jiang@cloud.ionos.com" <guoqing.jiang@cloud.ionos.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids



On 4/24/20 7:22 PM, Song Liu wrote:
> 
> 
>> On Mar 30, 2020, at 9:00 AM, Jason Baron <jbaron@akamai.com> wrote:
>>
>> Let's add some CONFIG_* options to directly configure the raid0 layout
>> if you know in advance how your raid0 array was created. This can be
>> simpler than having to manage module or kernel command-line parameters.
>>
>> If the raid0 array was created by a pre-3.14 kernel, use
>> RAID0_ORIG_LAYOUT. If the raid0 array was created by a 3.14 or newer
>> kernel then select RAID0_ALT_MULTIZONE_LAYOUT. Otherwise, the default
>> setting is RAID0_LAYOUT_NONE, in which case the current behavior of
>> needing to specify a module parameter raid0.default_layout=1|2 is
>> preserved.
>>
>> Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>> Cc: NeilBrown <neilb@suse.de>
>> Cc: Song Liu <songliubraving@fb.com>
>> Signed-off-by: Jason Baron <jbaron@akamai.com>
> 
> This patch looks good. However, I am not sure whether the user will 
> recompile the kernel for a different default value. Do you have real
> world use case for this?
> 
> Thanks,
> Song
> 

Hi Song,

Yes, we knew that all our raid0 arrays were created with >=3.14
kernels, and thus we wanted a way to specify the new layout without
needing to add to the command line or a module parameter. For us,
maintaining a CONFIG_* option is just simpler.

Thanks,

-Jason
