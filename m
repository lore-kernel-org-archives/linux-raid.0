From: jes.sorensen@gmail.com
Subject: Re: [PATCH 0/2] Bad block notification
Date: Sun, 29 Jan 2017 12:44:25 -0500
Message-ID: <wrfjd1f5kbgm.fsf@gmail.com>
References: <1485259419-2308-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485259419-2308-1-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Tue, 24 Jan 2017 13:03:37 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, shli@kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> At the moment there is no way to be notified that bad blocks have been found on
> a disk. It is only possible to check manually with 'mdadm --examine-badblocks'.
> User might not be aware there is a bad block for a long period. If another disk
> in the array fails, data is lost.
>
> These patches add a new event to the kernel and mdadm in order to send
> notification on the first bad block on a disk. I have chosen to do it only for
> first bad block as I think it's sufficient indication that the drive requires
> replacement.

Tomasz,

Looks reasonable to me - I'll wait for Shaohua to respond on the kernel
part before I apply the mdadm part.

Cheers,
Jes
