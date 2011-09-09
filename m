From: hansbkk@gmail.com
Subject: Re: Bootable Raid-1
Date: Fri, 9 Sep 2011 12:17:40 +0700
Message-ID: <CAAEZYjyzYOCAMm1Tzs4gi6N=utdwKCUrPSr202-9MwOybu8LLA@mail.gmail.com>
References: <AANLkTikBM=BQ7Q3W7zX5o59i9DzDgqHMQvnxQoeXip6M@mail.gmail.com>
	<60.01.07087.808994D4@cdptpa-omtalb.mail.rr.com>
	<CAGqmV7qRQ-6-dpTt5pywugtchFF4NtA5sNvVhBCOirpGhdgWiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7qRQ-6-dpTt5pywugtchFF4NtA5sNvVhBCOirpGhdgWiQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 9, 2011 at 3:28 AM, CoolCold <coolthecold@gmail.com> wrote:
> how does Grub2 react on degraded raid? Does it respect md's point of view which disk is bad and which is not? Does it cooperate well with mdadm in general?

Without being able to answer that specific question (my guesses: "very
well", "most likely" and "it better" 8-)

What I do is use a relatively small (and possibly slower) physical
hard drive for boot purposes, which doesn't contain any important
data. Easy enough to keep a RAID1 member on a shelf or offsite for
disaster recovery, image it or whatever.

The arrays that keep important userland data are on completely
separate (in my case RAID6) arrays, and wouldn't have anything to do
with the boot process. In fact they are easily moved from one host to
another as needed - many hosts run in VMs anyway.

Such a principle can be implemented even in simpler/smaller
environments with very little added cost.

I'd advise playing/learning with a couple scratch drives, perhaps
using a recent debian or ubuntu LiveCD. Don't use any GUI tools, just
follow the local man and online resources.

The new tool strives to be user-friendly and idiot-proof, and
therefore inevitably is more complex if you actually want to
understand the internal details of what its doing. But it's not rocket
science, maybe a half-day's worth of research and testing and you'll
be a GRUB2 guru. . .
