From: =?UTF-8?Q?Pawe=C5=82_Brodacki?= <pawel.brodacki@googlemail.com>
Subject: Re: [md PATCH 08/23] md: don't set md arrays to readonly on shutdown.
Date: Fri, 20 Apr 2012 13:30:39 +0200
Message-ID: <CACVpCE5mpJcY5u=8Kqp7TkCHN63aMfncDwbnP77NOFjubhqoPA@mail.gmail.com>
References: <20120314043555.7978.75486.stgit@notabene.brown>
	<20120314044040.7978.64156.stgit@notabene.brown>
	<CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com>
	<20120419084833.39379a6f@notabene.brown>
	<CAGRgLy6LXB34JtmfZYQEdAK4GLCV-hn-V8cT1zCwo_=ERyK90A@mail.gmail.com>
	<20120419195740.6e35ea02@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120419195740.6e35ea02@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Alexander Lyakas <alex.bolshoy@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2012/4/19 NeilBrown <neilb@suse.de>:
> On Thu, 19 Apr 2012 12:11:43 +0300 Alexander Lyakas <alex.bolshoy@gma=
il.com>
> wrote:
>
>> Hi Neil,
>> Thanks for the clarification.
>> However, from your commit message, it stems that during a normal
>> reboot (without -f -n), writes can still arrive after your reboot
>> notifier has cleaned the array. In such case, array might be dirty
>> after reboot. Is that so? If yes, then that's kind of regression.
>
> Why do you think that?
>
> I don't think that is the case.
>
> NeilBrown

Hello,

The way I read the message agrees with Alexander's perception. My
impression from reading the commit message is, that normal shutdown
may result in unclean array, which I would perceive as a regression.

I would really appreciate clear statement, whether this behaviour
(writeback during shutdown, with possibility of poweroff/reboot while
array is dirty) can or cannot occur during normal shutdown process.

I would bet, that only forced reboot/poweroff (reboot --force) may
result in dirty array on boot, but I'd rather not bet my data.

Best regards,
Pawe=C5=82 Brodacki
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
