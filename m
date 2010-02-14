From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Linux mdadm superblock question.
Date: Mon, 15 Feb 2010 00:20:05 +0100
Message-ID: <4B788525.6000608@grumpydevil.homelinux.org>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan> <4B7719C1.1060400@zytor.com> <4B785C49.7010105@shiftmail.org> <4B786898.8030309@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B786898.8030309@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Asdo <asdo@shiftmail.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

H. Peter Anvin wrote:
> In Fedora 12, for example, Dracut tries to make the distinction between
> whole RAID device and a partition device, and utterly fails -- often
> resulting in data loss.
>
>   
i do not use Fedora/redhat and do not intent to ever try them again... 
still, the point is valid
> With a pointer to the beginning this would have been a trivial thing to
> detect.
>
> IMO it would make sense to support autoassemble for 1.0 superblocks, and
> making them the default.  The purpose would be to get everyone off 0.9.
>  However, *any* default is better than 1.1.
>
> 	-hpa
>
>   
As long is autodetect is supported in the kernel, i am willing to 
upgrade to 1.0 superblocks. BUT i need the autodetect in the kernel, as 
i refuse to use initrd for production servers.

Cheers,


Rudy

