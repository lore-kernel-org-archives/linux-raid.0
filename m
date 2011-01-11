From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: mdadm raid5 with lvm: advantages?
Date: Tue, 11 Jan 2011 19:36:30 +0100
Message-ID: <4D2CA32E.3030303@gmail.com>
References: <AANLkTineOZXNQaGoF_WDnzHbzvCq0=Fi+kw=TseV+agQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTineOZXNQaGoF_WDnzHbzvCq0=Fi+kw=TseV+agQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Grundy <richguk@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dne 11.1.2011 15:06, Richard Grundy napsal(a):
> Hi,
> 
> I'm building a new RAID5 array (of 5 1.5 TB drives) with mdadm and
> would like to know the benefits of creating an LVM on top of this are
> instead of just creating the filesystem on the md directly. I've never
> had a problem growing the array and then resizing the filesystem
> before and wondered if in this situation the only gain would be lvm
> snapshot stuff? I'm planning to use ext4 for this array, if that makes
> any difference.
> 
> Thanks in advanced,
> 
> Rich
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Really depends on your needs..

It makes sense to use LVM for virtualization and iSCSI to get rid of big
file images (unwanted fs overhead/fragmentation). But yes, in some use
cases this is OK.

If you don't need snapshots or whatever LVM feature, then go the
simplest way - no LVM.

HTH, Z.
