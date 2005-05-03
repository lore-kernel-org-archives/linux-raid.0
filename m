From: Tyler <pml@dtbb.net>
Subject: Re: Any way to Increase MD_SB_DISKS=27 ? I need 31 devices
Date: Tue, 03 May 2005 04:44:29 -0700
Message-ID: <4277641D.6060303@dtbb.net>
References: <427583FA.7030704@dtbb.net> <4b0hk2-1gn.ln1@news.it.uc3m.es> <4275E782.6090509@dtbb.net> <mj6hk2-4lb.ln1@news.it.uc3m.es> <kt8hk2-lhp.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <kt8hk2-lhp.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Peter,

Thanks for all the great info, I had about half of it figured out :)  
I'm starting to wonder though, isn't the version 1 superblock supposed 
to be able to use many more drives than 27? .. If so, should this not 
already be patched in the kernel source, and in the mdadm source?  What 
am I missing? .. it seems like I am trying to do something that's 
already supposedly done.. am I not?

Thanks,
Tyler.

Peter T. Breuer wrote:

>Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
>  
>
>>Tyler <pml@dtbb.net> wrote:
>>    
>>
>>>figured out what you put below, i'm wondering though, will changing the 
>>>structures here affect anything else? other than the mdadm tool.. what 
>>>      
>>>
>
>  
>
>>I can't think of anything, offhand.  I would first check through the
>>kernel cde looking for associated gotchas before worrying about trivia
>>like applications, however!
>>    
>>
>
>mdp_super_t (the size of which you modified) is used throughout md.c
>only.  You want to check if it is mapped to disk or not. I think it is
>(offhand) ...
>
>  mdp_super_t *sb;
>
>  ...
>
>  bdevname(rdev->bdev, b);
>  sb = (mdp_super_t*)page_address(rdev->sb_page);
>
>
>So it seems to me to be intended to be 1KB of (sb) info on disk. If the
>blocksize is 1K, then reading/writing from disk may only deliver 1K.
>...
>
>     if (!sync_page_io(rdev->bdev, rdev->sb_offset<<1, MD_SB_BYTES, rdev->sb_page, READ))
>              goto fail;
>
>Hmm ... MD_SB_BYTES. But ....
>
>
>  #define MD_SB_BYTES                     4096
>
>So we read 4K off disk at a time! Phew! 
>
>Arrgh, but the undimensioned counts in md_p.h are in units of 4B, so
>when it says "1024 - ...", it really means "4KB - ...", and hence if
>you are going to icrease the size of the superblock, what you should do
>is
>
>1) increase MD_SB_BYTES to 8KB.
>2) change "1024 - ..." to "2048 - ..." in md_p.h.
>3) keep looking. Can one get 2 pages at once off disk with sync_page_io?
>
>Where is that rdev->sb_offset set? Great, in calc_dev_sboffset:
>
>        /*
>         * Calculate the position of the superblock,
>         * it's at the end of the disk.
>         *
>         * It also happens to be a multiple of 4Kb.
>         */
>        sb_offset = calc_dev_sboffset(rdev->bdev);
>        rdev->sb_offset = sb_offset;
>
>Yes, but if we are going to increase the size to 8KB, we'd better check
>that calc ...
>
>inline static sector_t calc_dev_sboffset(struct block_device *bdev)
>{
>        sector_t size = bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
>        return MD_NEW_SIZE_BLOCKS(size);
> }
>
>Uh huhh... it counts the blocks in the device (I think those are 1KB
>units, not device-dependent, but I may be wrong). Then it chooses the
>index of a smaller number to return - 1 past the available array size:
>
>  #define MD_NEW_SIZE_BLOCKS(x)           ((x & ~(MD_RESERVED_BLOCKS - 1)) - MD_RESERVED_BLOCKS)
>
>Ummmm ... that appears to be an attempt to calculate (x / y) * y - y, where 
>y is a power of two ...
>
>   #define MD_RESERVED_BLOCKS      (MD_RESERVED_BYTES / BLOCK_SIZE)
>
>and the clunker ...
>
>   #define MD_RESERVED_BYTES       (64 * 1024)
>
>OK. So AT LEAST 64KB are reserved at the end of the disk. We can only
>count on 64KB, however. The good news is that it looks like the first
>4KB of that is the superblock, and that we might be able to use the rest
>for a bigger superblock (I suspect bitmap info will be kept there
>eventually). Provided you can arrange to read 8KB of sb, you might be
>OK.
>
>
>Peter
>
>
>
>
>
>Peter
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>

