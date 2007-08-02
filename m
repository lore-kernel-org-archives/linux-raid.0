From: Colin Snover <linux-raid@zetafleet.com>
Subject: Re: RAID6 --grow won't restart after disk failure [solved]
Date: Wed, 01 Aug 2007 23:37:08 -0500
Message-ID: <46B15F74.7060407@zetafleet.com>
References: <46B112C0.8040509@zetafleet.com> <18097.19201.261521.678783@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18097.19201.261521.678783@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> Reshape won't restart while the array is auto-read-only.
> You can start it simply by mounting the filesystem, or with
>   mdadm /dev/md0 --readwrite
>   
Neil,

Thank you very much for your prompt response. I would have never figured
it out myself, with my incorrect assumption about what read-only meant.
Once I set it to read-write, it started reshaping again. I'd guess you
probably don't run into this issue very often, but it might be useful to
others to have this information in the man-page somewhere. Just a line
almost exactly like what you've written above could be useful -- "Arrays
will not reshape or rebuild if they are in read-only mode. Use the
--readwrite switch to set the array to read-write mode to continue a
reshape or rebuild."

Thanks again,

-- 
Colin Snover
http://www.zetafleet.com

