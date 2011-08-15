From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Rotating RAID 1
Date: Mon, 15 Aug 2011 19:32:04 -0400
Message-ID: <CALJXSJqVD9ibB9LAM7jU5aJFbyEssCuf2QMai+K=8xk6=pfRew@mail.gmail.com>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
 <4E497FB5.3030109@ivitera.com> <CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com>
 <4E49849E.4030604@ivitera.com> <20110816084251.2d8e7831@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110816084251.2d8e7831@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Pavel Hofman <pavel.hofman@ivitera.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 15, 2011 at 6:42 PM, NeilBrown <neilb@suse.de> wrote:
> So if there are 3 drives A, X, Y where A is permanent and X and Y are rotated
> off-site, then I create two RAID1s like this:
>
>
> mdadm -C /dev/md0 -l1 -n2 --bitmap=internal /dev/A /dev/X
> mdadm -C /dev/md1 -l1 -n2 --bitmap=internal /dev/md0 /dev/Y

That seems nice for 2 disks, but adding another one later would be a
mess. Is there any way to play with slots number manually to make it
appear as an always degraded RAID ? I can't plug all the disks at once
because of the maximum of 2 ports.
