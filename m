From: zhilong <zlliu@suse.com>
Subject: Re: [PATCH 0/4] mdadm:checking level once mode has been set
Date: Mon, 13 Mar 2017 13:16:14 +0800
Message-ID: <e7d99ad4-7935-f593-9ea5-112955225de1@suse.com>
References: <20170308074831.24683-1-zlliu@suse.com>
 <878toaf6me.fsf@notabene.neil.brown.name>
 <65454fe3-6165-5d02-eecd-02f8aac8f422@suse.com>
 <8737ehg7l8.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8737ehg7l8.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 03/13/2017 11:48 AM, NeilBrown wrote:
> On Mon, Mar 13 2017, zhilong wrote:
>
>> On 03/13/2017 06:54 AM, NeilBrown wrote:
>>> On Wed, Mar 08 2017, Zhilong Liu wrote:
>>>
>>>> mdadm: it would be better to check --level ealier,
>>>> because it would fall to different prompt if user
>>>> forgets to specify the --level. such as:
>>>> ./mdadm -CR /dev/md0 -b internal -n2 -x1 /dev/loop[0-2]
>>> When I run that command I get:
>>>
>>>     mdadm: a RAID level is needed to create an array.
>>>
>>>
>>> What do you get?
>> I'm sorry I have provided the wrong command, for this scenario,
>> issues "mdadm --build /dev/md0 -n2 /dev/loop[0-1]" should be
>> proper. it's the purpose to check --level earlier.
> OK, that makes sense.
>
>> If this patch is useful, I would send the v1 patch for it, correct the
>> comments.
> My preference would be to have the check in Build.c, but Jes might have
> different ideas.

copy that, thanks very much.

Best regards,
-Zhilong

> NeilBrown

