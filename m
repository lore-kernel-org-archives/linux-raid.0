From: Luca Berra <bluca@comedia.it>
Subject: Re: Problems with SCSI devices renaming...
Date: Tue, 19 Oct 2004 17:02:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041019150222.GD30951@percy.comedia.it>
References: <001201c4b5ea$958f0790$30493c86@clever>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001201c4b5ea$958f0790$30493c86@clever>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 19, 2004 at 04:47:40PM +0200, Martin Clauss wrote:
>Hi all,
>
>i got a problem with my raid. Current setup:
>
>This works very fine so far. But when I attach an additional device to this
>DEC Storage Device, I get an additional target on this SCSI bus. Now this
>doesn't matter for the devfs names, but the superblock of the RAID saves
>major/minor numbers that are wrong now. So the raid won't start anymore....
>Shouldn't autodetect handle exactly this problem? (Yes, partition type is
>linux raid autodetect for all raid disks...)
>
>I guess, this should be a quite common problem, so I hope to find some
>answers here.
>
forget autodetect,
forget raidtools,
switch to mdadm.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
