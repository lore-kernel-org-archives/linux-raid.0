From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Replacing a RAID1 drive that has not failed.
Date: Tue, 27 Oct 2015 21:31:01 +0000
Message-ID: <562FED15.5040804@youngman.org.uk>
References: <n0mbam$gmk$1@ger.gmane.org> <n0o9n3$gmk$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <n0o9n3$gmk$2@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Herr <gmane@wombatz.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/10/15 16:45, Doug Herr wrote:
>  1. Partition new drive (plugged in via external SATA dock)
> #fdisk /dev/sdc
> (make it an exact match of sda/sdb unless it turns out to be smaller,
>  in which case I can shrink /boot to make room.)

man gdisk.

Look at the "u" option in the "expert" menu - it'll probably save you
some work :-)

Cheers,
Wol
