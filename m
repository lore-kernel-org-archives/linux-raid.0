From: Shaohua Li <shli@kernel.org>
Subject: Re: remove mdadm stripe limitation, pls
Date: Mon, 31 Jul 2017 10:00:24 -0700
Message-ID: <20170731170024.zxvcrlvycbiejfvz@kernel.org>
References: <S1752524AbdGaPpr/20170731154547Z+299@vger.kernel.org>
 <1501516344.23767.4.camel@bsu.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501516344.23767.4.camel@bsu.by>
Sender: linux-raid-owner@vger.kernel.org
To: Dima Dvorcovoy <dvorc@bsu.by>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Mon, Jul 31, 2017 at 06:52:24PM +0300, Dima Dvorcovoy wrote:
> I got in trouble trying to mount RAID0 drives from brocen HW
> controller. The mdadm utility is locked to 4k stripe minimum, but these
> drives have 1s (512bytes) stripes. 
> 
> Then, I dig into kernel and found there are no actual stripe limitation
> seems. So, all the limits are in mdadm code. I patched soure and all
> works ok. 
> mdadm --build /dev/md0 --level=0 --chunk=1s --raid-devices=2 /dev/sdd
> /dev/sdc 
> 
> First: there are UNDOCUCMENTED option in --chunk, size could be given
> in sectors (s). 
> 
> Second: 1s used as INVALID_SECTORS constant. I changed it to 0xffff 
> 
> Third: The sector number is stored in K. I removes this division, maybe
> it is only for output. 
> 
> Where to connect with mdadm team to ask for changes? What I skipped to
> patch? 

Cc: Jes

If we really want to do this, please limit it to raid0 now. I think there is
problem with 512B chunksize for raid5, raid10 probably is ok.

Thanks,
Shaohua
> [mdadm.h] 
> 1737c1737 
> < * a value for 'invalid'. Use '1'. 
> --- 
> > * a value for 'invalid'. Use '-1'. 
> 1739c1739 
> < #define INVALID_SECTORS 1 
> --- 
> > #define INVALID_SECTORS 0xffff 
> [mdadm.c] 
> 381,384c381,382 
> < if (s.chunk == INVALID_SECTORS || 
> < s.chunk < 8 || (s.chunk&1)) { 
> < pr_err("invalid chunk/rounding value: %s\n", 
> < optarg); 
> --- 
> > if (s.chunk == INVALID_SECTORS) { 
> > pr_err("invalid chunk/rounding value: %s\n",optarg); 
> [Build.c] 
> 387,388d384 
> < /* Convert sectors to K */ 
> < s.chunk /= 2; 
> 145c145 
> < array.chunk_size = s->chunk*1024; 
> --- 
> > array.chunk_size = s->chunk*512; 
> [Create.c] 
> 696c696 
> < info.array.chunk_size = s->chunk*1024; 
> --- 
> > info.array.chunk_size = s->chunk*512;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
