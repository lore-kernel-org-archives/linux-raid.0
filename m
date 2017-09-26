From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be
 needed.
Date: Tue, 26 Sep 2017 11:11:36 -0400
Message-ID: <250d2eff-ce7e-df72-1e6c-b4a8a2c43537@gmail.com>
References: <87y3p372b0.fsf@notabene.neil.brown.name>
 <22985.8214.251962.72926@quad.stoffel.home>
 <87poae72z5.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87poae72z5.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, John Stoffel <john@stoffel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/25/2017 07:50 PM, NeilBrown wrote:
> On Mon, Sep 25 2017, John Stoffel wrote:
> 
>> I haven't looked, but shouldn't the path for modprobe be hardcoded
>> here to /sbin/modprobe?  Or the PATH sanitized so that random people
>> can't put something into the system PATH and cause problems?
> 
> That issue briefly crossed my mind as I wrote the code (is it OK to use
> system()? should I use /sbin/modprobe or just modprobe?) but as mdadm is
> not set-uid and cannot be run in an environment created by a
> non-privileged user, there is no security risk.
> Certainly a careless sysadmin might set path wrongs, but the most likely
> wrong outcome is that modprobe won't be found, and there is very little
> cost to that.
> 
> So thanks for asking, but I don't think there is any need for any extra
> care, in which case "simplest is best".

I completely agree, I also think we shouldn't hardcode imposed layouts 
unless there are very strong reasons for it. Someone may want to put 
this into an initramfs or somewhere else and want to put it in a 
different location.

Cheers,
Jes


