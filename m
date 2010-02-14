From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 13:18:16 -0800
Message-ID: <4B786898.8030309@zytor.com>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan> <4B7719C1.1060400@zytor.com> <4B785C49.7010105@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B785C49.7010105@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 02/14/2010 12:25 PM, Asdo wrote:
> I don't understand...
> In a system we have, the root filesystem on a raid-6 which is on second
> (and last) partitions of many disks.
> It always assembled correctly, it never tried to assemble the whole device.
> (on the first partition there is a raid1 with boot)
> So what's the problem exactly with not marking the beginning?

In Fedora 12, for example, Dracut tries to make the distinction between
whole RAID device and a partition device, and utterly fails -- often
resulting in data loss.

With a pointer to the beginning this would have been a trivial thing to
detect.

IMO it would make sense to support autoassemble for 1.0 superblocks, and
making them the default.  The purpose would be to get everyone off 0.9.
 However, *any* default is better than 1.1.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

