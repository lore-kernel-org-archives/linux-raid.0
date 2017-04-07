From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: Can we deprecate ioctl(RAID_VERSION)?
Date: Fri, 7 Apr 2017 10:54:42 -0400
Message-ID: <3446a571-12e6-8d7a-2d91-3c0e35b235e1@gmail.com>
References: <wrfjvaqid9ih.fsf@gmail.com> <wrfjr316d6f5.fsf@gmail.com>
 <87h922trit.fsf@notabene.neil.brown.name>
 <070d7f50-c8f0-d5df-89ed-adb8b7582d8a@gmail.com>
 <7f1cdca1-2781-d6da-265c-6a51061b3da0@suse.de>
 <0cdb9fe9-0eea-3c4f-af93-5894d04d680f@gmail.com>
 <ff4b41cf-1ece-bac0-f39a-4361cad0354e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ff4b41cf-1ece-bac0-f39a-4361cad0354e@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, kernel-team@fb.com
List-Id: linux-raid.ids

On 04/06/2017 11:54 PM, Coly Li wrote:
> On 2017/4/7 上午2:14, Jes Sorensen wrote:
>> A volunteer! A volunteer!
>>
>> I don't think we need to set a firm timeline for removing code from the
>> kernel at this point. What we can do is implement the new interfaces via
>> sysfs/configfs, and then make ioctl support a config option. Down the
>> line it will be evident if/when we can rip out the old code, but I see
>> that being years away.
>
> Not removing code, just after a timeline, new patch which adding new
> interface should go into configfs.
> I start to look into this now, hope to compose a first version patch set
> for comments in not too long time.
>
> Coly

Sounds good - make sure to also consult with Shaohua how it likes to see 
it implemented on the kernel side.

Cheers,
Jes

