From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Rotating RAID 1
Date: Mon, 15 Aug 2011 16:23:33 -0400
Message-ID: <CALJXSJq=NZaSEOnf+QPYYmMwfxom8EUPA4Wxbc+ebakHwN5CTA@mail.gmail.com>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
 <4E497F5D.7000306@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E497F5D.7000306@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 15, 2011 at 4:19 PM, Phil Turmel <philip@turmel.org> wrote:
> It would also work if you didn't use a bitmap, as a re-inserted drive=
 would simply be overwritten completely.

After reading this, I'll prefer wiping the bitmap rather than having
an horror story trying to restore that backup, I'll give it a try.

>
> How do you stay compatible with Windows? =C2=A0If you let Windows wri=
te to any of these disks, you've corrupted that disk with respect to it=
s peers. =C2=A0Danger, Will Robinson!

I am using ext4 driver in read only mode.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
