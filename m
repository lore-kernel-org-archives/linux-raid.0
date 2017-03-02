From: Shaohua Li <shli@kernel.org>
Subject: Re: raid5 - adding journal to an existing device?
Date: Thu, 2 Mar 2017 10:39:25 -0800
Message-ID: <20170302183925.xnvvybpui6ldssv6@kernel.org>
References: <9447cf1f98aaade8ab5cd3f0ef724f79@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9447cf1f98aaade8ab5cd3f0ef724f79@admin.virtall.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Sat, Feb 25, 2017 at 11:12:21PM +0900, Tomasz Chmielewski wrote:
> mdadm manual specifies the following for create, build and grow modes:
> 
>        --write-journal
>               Specify journal device for the RAID-4/5/6 array.
> 
> However:
> 
> # mdadm --grow /dev/md2 --write-journal /dev/sdc1
> mdadm: :option --write-journal not valid in grow mode
> 
> 
> Is it not yet supported, will never be supported, or am I simply trying to
> use it in a  wrong way?
> 
> 
> 
> Tried the following versions:
> 
> # ./mdadm -V
> mdadm - v3.4-115-ge22fe3a - 29th November 2016
> 
> # mdadm -V
> mdadm - v3.4 - 28th January 2016

Cc: Song and Jes.

I think we support hotadd journal. Will let Song clarify.

Thanks,
Shaohua
