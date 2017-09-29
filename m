From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Accidentally resized array to 9
Date: Fri, 29 Sep 2017 17:55:24 +0500
Message-ID: <20170929175524.57fea3b5@natsu>
References: <0e59cefd-662f-bf77-0c32-49424d504c77@benshoshan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0e59cefd-662f-bf77-0c32-49424d504c77@benshoshan.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Ben-Shoshan <eli@benshoshan.com>
Cc: linux-raid@vger.kernel.org, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

On Fri, 29 Sep 2017 00:23:28 -0400
Eli Ben-Shoshan <eli@benshoshan.com> wrote:

> This was a RAID6 with 8 devices. Instead of using --grow with 
> --raid-devices set to 9, I did the following:
> 
> mdadm --grow /dev/md128 --size 9
> 
> This happily returned without any errors so I went to go look at 
> /proc/mdstat and did not see a resize operation going. So I shook my 
> head and read the output of --grow --help and did the right thing which is:
> 
> mdadm --grow /dev/md128 --raid-devices=9

The output of the first command is:

  # mdadm --grow /dev/md0 --size 9
  mdadm: component size of /dev/md0 has been set to 9K
  unfreeze

It didn't occur to you that you FIRST need to restore the "component size" back
to what it was previously?...

And yes as John says there should be a confirmation request on reducing the
array size. In fact I couldn't believe there isn't one already, that's why I
went checking. But nope, there are no warnings or confirmation requests
neither for reducing --size, nor --array-size. I might be remembering that
there were some, from LVM, not MD.

-- 
With respect,
Roman
