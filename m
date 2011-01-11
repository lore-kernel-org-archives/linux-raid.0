From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: mdadm raid5 with lvm: advantages?
Date: Tue, 11 Jan 2011 20:11:45 +0100
Message-ID: <4D2CAB71.8080108@gmail.com>
References: <AANLkTineOZXNQaGoF_WDnzHbzvCq0=Fi+kw=TseV+agQ@mail.gmail.com>	<4D2CA32E.3030303@gmail.com> <20110111234945.7c601067@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111234945.7c601067@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Richard Grundy <richguk@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dne 11.1.2011 19:49, Roman Mamedov napsal(a):
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

Yes, some filesystems can solve fragmentation issue. But if there's no
good reason to have images directly on fs, then no need to waste
performance (even if it's just 5%).

I think you have options to move PE's, but it's tricky and it's better
to avoid such allocations in first place..

HTH, Z.
