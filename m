From: Roy Keene <linux-raid@rkeene.org>
Subject: Re: mdadm raid5 with lvm: advantages?
Date: Tue, 11 Jan 2011 12:58:02 -0600 (CST)
Message-ID: <Pine.LNX.4.64.1101111254530.1805@claw.oc9.org>
References: <AANLkTineOZXNQaGoF_WDnzHbzvCq0=Fi+kw=TseV+agQ@mail.gmail.com>
 <4D2CA32E.3030303@gmail.com> <20110111234945.7c601067@natsu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111234945.7c601067@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Zdenek Kaspar <zkaspar82@gmail.com>, Richard Grundy <richguk@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman,

 	LVM supports both sparse LVs (--virtualsize) and defragmentation 
(though as you say it's not currently easy -- I started writing a script 
to handle it but it's not a big enough problem that I've ever actually 
wanted to use the script, still a general purpose "lvdefrag" could be 
written).

Thanks,
 	Roy Keene

On Tue, 11 Jan 2011, Roman Mamedov wrote:

> On Tue, 11 Jan 2011 19:36:30 +0100
> Zdenek Kaspar <zkaspar82@gmail.com> wrote:
>
>> It makes sense to use LVM for virtualization and iSCSI to get rid of big
>> file images (unwanted fs overhead/fragmentation). But yes, in some use
>> cases this is OK.
>
> Since you mentioned fragmentation - there are ways to both make sparse file
> images, and to defragment them when needed (on some filesystems like XFS and
> btrfs). But when using LVM instead of file images, the user has neither: LVM
> can't have sparse LVs, and it can't (easily) defragment an LV that is
> fragmented over one or several PVs. Or am I missing something here?
>
> -- 
> With respect,
> Roman
>
