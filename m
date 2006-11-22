From: Henrik Holst <henrik.holst@idgmail.se>
Subject: Re: Is shrinking raid5 possible?
Date: Wed, 22 Nov 2006 21:40:35 +0100
Message-ID: <4564B5C3.9050501@idgmail.se>
References: <44960C45.9050407@anu.edu.au>	 <17558.10906.59066.196870@cse.unsw.edu.au> <449B3A80.4070602@tmr.com>	 <17563.17224.85968.572754@cse.unsw.edu.au>	 <bb145bd20606231116g7808e467w29a9bf273ba0df52@mail.gmail.com>	 <17567.36792.303403.35943@cse.unsw.edu.au> <bb145bd20606260433w2bafccfdu3448732f5b5c1c5f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20606260433w2bafccfdu3448732f5b5c1c5f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christian Pernegger wrote:
>> This is shrinking an array by removing drives.  We were talking about
>> shrinking an array by reducing the size of drives - a very different
>> think.
> 
> Yes I know - I just wanted to get this in as an alternative shrinking
> semantic.
> 
> As for reducing the RAID (partition) size on the individual drives I
> can only see two reasons:
> 
> 1) One wants to replace / add a disk but the new disk is slightly
> smaller than the existing ones. Actual capacity varies a lot for the
> same nominal capacity, especially across brands.
> 
> 2) One wants to do something else with some of the space, although for
> a RAID5 I don't quite see the point - you'd end up with n small
> partitions. Shrinking a 2-way mirror or stripe this way sounds far
> more useful.
> 
> Having RAID tightly integrated with volume management and partitions
> would be nice, but that's a pipe dream. (EVMS just integrates the UI
> somewhat, you still have to mess about with layers.)
> 
>> I'm not sure it is really worth the effort I'm afraid.
> 
> Neither am I ... it just would have come in handy a few times, that's all.
> 
> Thanks,
> 
> C.

I have an 8x120 GB RAID-5 volume. Or rather. But since of yesterday I
only have 7 120 GB harddrives. Since 120 GB disks are out of the
"priceworthy segment" for storage I want to reduce this to a
non-degenerate 7x120 GB RAID and not buy a relative expensive 120 GB
disk. And recreating the RAID as a 7x120 volume is out of the question
since I don't have the extra storage to move ~700 GB of data.

I think there IS an application for shrinking RAID:s, as well as
growing- and that is not only one of "symmetric beauty".

Is such a feature within the scope of software raid development? (I
guess I'm asking Neil B. or Steinar H. G.)

/Henrik Holst

