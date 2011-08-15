From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Rotating RAID 1
Date: Mon, 15 Aug 2011 16:25:56 -0400
Message-ID: <CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
 <4E497FB5.3030109@ivitera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E497FB5.3030109@ivitera.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Hofman <pavel.hofman@ivitera.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 15, 2011 at 4:21 PM, Pavel Hofman <pavel.hofman@ivitera.com> wrote:
> Does your scenario involve using two "external" drives, being swapped
> each time?

Yes, exactly, 3 or more drive, one stays in place, and the others get
rotated off-site.

> I am using such setup, but in order to gain the bitmap
> performance effects, I have to run two mirrored RAID1s, i.e. two
> bitmaps, each for its corresponding external disk. This setup has been
> working OK for a few years now.

Did you script something that stops the RAID and re-assemble it? The
RAID must stay mounted in my case as there is live data (incremential
backups, so even if the last file is incomplete it is not a problem.)
