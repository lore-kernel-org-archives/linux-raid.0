From: Luca Berra <bluca@comedia.it>
Subject: Re: trouble creating array
Date: Tue, 27 Feb 2007 23:23:46 +0100
Message-ID: <20070227222346.GB23712@percy.comedia.it>
References: <455743.17233.qm@web55801.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <455743.17233.qm@web55801.mail.re3.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 26, 2007 at 03:40:32AM -0800, jahammonds prost wrote:
>Ah ha....
>
># ls -l /sys/block/*/holders/*
>lrwxrwxrwx 1 root root 0 Feb 26 06:28 /sys/block/sdb/holders/dm-0 -> ../../../block/dm-0
>lrwxrwxrwx 1 root root 0 Feb 26 06:28 /sys/block/sdc/holders/dm-0 -> ../../../block/dm-0
>
>which I am assuming is dmraid? I did a quick check, and

no, it is device-mapper

># dmraid -r
>No RAID disks
>
use "dmsetup ls"

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
