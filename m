From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] Fix race between --create and --incremental
Date: Wed, 30 Apr 2014 13:50:02 +0200
Message-ID: <5360E36A.2030402@intel.com>
References: <1397056499-6743-1-git-send-email-artur.paszkiewicz@intel.com> <20140410103337.30c9dc7c@notabene.brown> <5347BF2D.1030609@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5347BF2D.1030609@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/11/2014 12:08 PM, Artur Paszkiewicz wrote:
> On 04/10/2014 02:33 AM, NeilBrown wrote:
>> On Wed,  9 Apr 2014 17:14:59 +0200 Artur Paszkiewicz
>> <artur.paszkiewicz@intel.com> wrote:
>>
>>> This modifies locking in Create to eliminate a situation where
>>> --incremental can assemble a device between write_init_super() and
>>> add_disk(), which causes Create to fail.
>>>
>>> It sporadically occurs e.g. when metadata is written on a device,
>>> causing an udev change event which triggers mdadm --incremental.
>>>
>>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>>
>> Thanks for the patch.
>> I've taken the liberty of changing it a little.  I didn't like the
>> fact that
>> we dropped the lock and then took it again.  It probably doesn't
>> matter, but
>> it feels cleaner to hold it the whole time.
>>
>> So this is the result.  Let me know if you disagree at all.
> 
> Hello Neil,
> 
> Your changes are OK, thanks.

Hello Neil,

Are you going to apply this patch?

Thanks,
Artur

