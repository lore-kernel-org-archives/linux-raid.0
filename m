From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: [md PATCH 08/23] md: don't set md arrays to readonly on shutdown.
Date: Thu, 19 Apr 2012 12:11:43 +0300
Message-ID: <CAGRgLy6LXB34JtmfZYQEdAK4GLCV-hn-V8cT1zCwo_=ERyK90A@mail.gmail.com>
References: <20120314043555.7978.75486.stgit@notabene.brown>
	<20120314044040.7978.64156.stgit@notabene.brown>
	<CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com>
	<20120419084833.39379a6f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120419084833.39379a6f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
Thanks for the clarification.
However, from your commit message, it stems that during a normal
reboot (without -f -n), writes can still arrive after your reboot
notifier has cleaned the array. In such case, array might be dirty
after reboot. Is that so? If yes, then that's kind of regression.

Thanks,
Alex.

On Thu, Apr 19, 2012 at 1:48 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 18 Apr 2012 18:37:56 +0300 Alexander Lyakas <alex.bolshoy@gma=
il.com>
> wrote:
>
>> Hi Neil,
>>
>> > This could result in the shutdown happening when array is marked
>> > dirty, thus forcing a resync on reboot. =A0However if you reboot
>> > without performing a "sync" first, you get to keep both halves.
>> Can you pls clarify the last statement?
>
> "If you break it, you get to keep both halves" is a colloquial phrase=
 meaning
> that that the person saying it takes no responsibility for any damage=
 that
> the person being spoken to causes.
> When applied to software issues it is ironic (because when a thing 'b=
reaks' it
> doesn't result in two pieces like, for example, when a plate breaks) =
and so
> funny (I hope).
> (when applied to a RAID mirror, it is doubly ironic :-)
>
> If you force a fast shutdown without allowing a sync to happen
> (e.g. reboot -f -n) there could be data on the way out to the array w=
hen the
> system actually reboots, so the array will be dirty, so a resync will=
 be
> required when the system restarts.
> This might be undesirable, but that isn't my problem and is not the p=
roblem
> of md/raid. =A0Rather the cause of the problem is the "reboot -f -n".=
 =A0i.e.
> "your" problem. =A0 "You" broke it, you get to keep both halves.
>
> Does that help?
>
> NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
