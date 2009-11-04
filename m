From: Chris Worley <worleys@gmail.com>
Subject: Re: Unbelievably _good_ write performance: RHEL5.4 mirror
Date: Tue, 3 Nov 2009 17:37:56 -0700
Message-ID: <f3177b9e0911031637y6a025d2er5b23408cead22803@mail.gmail.com>
References: <f3177b9e0911021028t1fea4ad2lb4cf87059d300a0c@mail.gmail.com>
	 <921ca19c0911030437s4ba6b2d9l24fe4d2c83029e9b@mail.gmail.com>
	 <4877c76c0911030831q2ca99007lf3b9068de6be48b@mail.gmail.com>
	 <f3177b9e0911031129g2e0026f6s65275b8f684438f4@mail.gmail.com>
	 <4877c76c0911031611h3572851avaed9870795db3d92@mail.gmail.com>
	 <f3177b9e0911031621p29c390e4xc5017001a38046ff@mail.gmail.com>
	 <4877c76c0911031629n580dc25ay7e47990908b056e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911031629n580dc25ay7e47990908b056e7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Sujit K M <sjt.kar@gmail.com>, linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 3, 2009 at 5:29 PM, Michael Evans <mjevans1983@gmail.com> w=
rote:
>>
>> So, you're saying that the MD layer is doing it's own buffering? =A0=
Are
>> you sure? =A0With the system cache disabled and the drive (and block
>> device driver) cache disabled, there should be no reason to require
>> synchronous I/O, unless, as you suggest, the MD layer is broken.
>>
>> You're saying that both O_DIRECT and O_SYNC must be used to disable
>> cache effects. Why then are there two separate flags and not just on=
e?
>> =A0Synchronous is a very different behavior that is not necessary fo=
r
>> this test and put additional requirements that are not needed for th=
is
>> test.
>>
>> Chris
>>
>
> Reading the manual page it seems O_DIRECT explicitly minimizes any
> attempts at extra copying; not explicitly disabling buffers, merely
> not adding more. =A0In another mail thread this tweak-able was
> discussed:
>
> echo 0 > /sys/block/md*/md/stripe_cache_size
>
> Which would should (I think) disable any cache involved with the md l=
ayer.

Stripe_cache_size doesn't seem to exist in the /sys/block/md*/md/
directory on the RHEL5.3 2.6.18-92 kernel I'm using.

# ls /sys/block/md*/md/s*
/sys/block/md0/md/safe_mode_delay  /sys/block/md0/md/suspend_hi
/sys/block/md0/md/suspend_lo  /sys/block/md0/md/sync_action
/sys/block/md0/md/sync_completed  /sys/block/md0/md/sync_speed
/sys/block/md0/md/sync_speed_max  /sys/block/md0/md/sync_speed_min

Thanks,

Chris
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
