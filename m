From: Joe Pruett <joey@clean.q7.com>
Subject: Re: Root Drive Mirroring and LVM.
Date: Thu, 5 Feb 2004 10:04:26 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0402051003300.14792-100000@q7.q7.com>
References: <16417.31540.78193.699721@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16417.31540.78193.699721@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 5 Feb 2004, Neil Brown wrote:

>  We don't expect the kernel, or anyone else, to scan all devices
>  looking for something that looks like a root filesystem, and loading
>  that.  Rather we tell the kernel or boot loader exactly where to find
>  the root filesystem.  And if the root filesystem moves, we get to
>  explicitly tell the boot loader where it is (root=/dev/hdc1 or
>  whatever).

what about:
root=LABEL=/


