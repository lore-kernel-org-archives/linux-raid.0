From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: occasional hard lockup on raid on nvme disks (fio processes hung)
Date: Fri, 29 Sep 2017 16:05:10 +0200
Message-ID: <1f1b255a-1ce5-d135-a962-2c16d4ac29a5@intel.com>
References: <CAMNNMLE-bx55Q_8eCjwm0aOD2J0wo9X1puTNWgeHKhOBP2WXmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMNNMLE-bx55Q_8eCjwm0aOD2J0wo9X1puTNWgeHKhOBP2WXmA@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Nikhil Kshirsagar <nkshirsa@redhat.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/28/2017 08:18 AM, Nikhil Kshirsagar wrote:
> Hello,
> 
> I'm referring to this old email I found in the linux-raid history. Can
> anyone comment on if this issue has had further discussion, or
> analysis ?
> 
> I see subsequent follow ups at spinics.net/lists/raid/msg52994.html and
> 
> spinics.net/lists/raid/msg52970.html
> 
> spinics.net/lists/raid/msg53461.html
> 
> but no further discussion.
> 
> I was wondering if this has been reported in RHEL or has any
> associated bz's or investigation.

It appears that this was recently fixed by:
184a09eb9a2f ("md/raid5: preserve STRIPE_ON_UNPLUG_LIST in break_stripe_batch_list")

I submitted a RHEL BZ for this:
https://bugzilla.redhat.com/show_bug.cgi?id=1497215

Regards,
Artur
