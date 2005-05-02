From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Any way to Increase MD_SB_DISKS=27 ? I need 31 devices
Date: Mon, 2 May 2005 09:09:56 +0200
Message-ID: <4b0hk2-1gn.ln1@news.it.uc3m.es>
References: <427583FA.7030704@dtbb.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tyler <pml@dtbb.net> wrote:
> I'd like to build a Raid-6 array using 31 drives, is there a patch 
> available or an easy way to safely increase the *MD_SB_DISKS*=27 to a 
> higher number?  My attempts at patching the source myself were 
> unsuccessful, more than likely because i don't know what/why the limit 
> is 27, and whether that effects other parts of the kernel.

It's 27 because that's how much space there is in some of the structs.

Look in include/linux/raid. md_p.h, for example.

   #define MD_SB_DISKS                     27

and it calculates how much space that needs:

   #define MD_SB_DISKS_WORDS (MD_SB_DISKS*MD_SB_DESCRIPTOR_WORDS)
   #define MD_SB_DESCRIPTOR_WORDS          32

and all that is part of what must fit in a "mdp_superblock_s" struct.

           /*
            * Disks information
            */
           mdp_disk_t disks[MD_SB_DISKS];

with the space at the tail of the struct calculated ...


        /*
         * Reserved
         */
        __u32 reserved[MD_SB_RESERVED_WORDS];

 ... by figuring how much space was used and subtracting from 1K:

       #define MD_SB_RESERVED_WORDS            (1024 - MD_SB_GENERIC_WORDS - MD_SB_PERSONALITY_WORDS - MD_SB_DISKS_WORDS - MD_SB_DESCRIPTOR_WORDS)

and the space used includes the MD_SB_DESCRIPTOR_WORDS conisting of
those 27 32-byte array elements.

To make this number bigger, you would first have to make more room in
the struct, by changing the 1K in the calculation to 4096 (thus
extending the struct by extending its reserved section), then you
could use more of that room by increasing the 27. I presume the max
would now be 3*32+27 = 123.


There might be another such struct in the includes. I haven't looked
 ...

Peter

