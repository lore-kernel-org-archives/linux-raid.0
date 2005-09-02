From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: MD or MDADM bug?
Date: Fri, 2 Sep 2005 05:41:50 -0400
Message-ID: <01a101c5afa2$8b3f2060$c100a8c0@NCNF5131FTH>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH><17176.2600.694418.472339@cse.unsw.edu.au><018f01c5af99$0343f6d0$c100a8c0@NCNF5131FTH><17176.4401.418417.56385@cse.unsw.edu.au><019601c5af9b$23d8ce50$c100a8c0@NCNF5131FTH> <17176.7326.892297.381537@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday September 2, dstrang@shellpower.net wrote:
> > >
> > > Can you run that with '-v' for me?
> > 
> > mdadm: looking for devices for /dev/md0
> > mdadm: /dev/sda is identified as a member of /dev/md0, slot 0.
> > mdadm: /dev/sdb is identified as a member of /dev/md0, slot 1.
> > mdadm: /dev/sdc is identified as a member of /dev/md0, slot 2.
> ...
> 
> and just for completeness:
> 
>  mdadm -E /dev/sdm /dev/sdaa 
> 

-(root@abyss)-(~)- # mdadm -E /dev/sdm /dev/sdaa
/dev/sdm:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : 4e2b6b0a:8e92e91c:0c018a4b:f09bb74d
           Name : md/md0
  Creation Time : Wed Dec 31 19:00:00 1969
     Raid Level : raid5
   Raid Devices : 28

    Device Size : 143374632 (68.37 GiB 73.41 GB)
   Super Offset : 143374632 sectors
          State : clean
    Device UUID : 145bcf19:e4b3134a:3f312e60:06e44931
    Update Time : Wed Aug 31 22:23:26 2005
       Checksum : 2920539f - correct
         Events : 2645518

         Layout : left-asymmetric
     Chunk Size : 128K

   Array State : ____________________________ 28 failed
/dev/sdaa:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : 4e2b6b0a:8e92e91c:0c018a4b:f09bb74d
           Name : md/md0
  Creation Time : Wed Dec 31 19:00:00 1969
     Raid Level : raid5
   Raid Devices : 28

    Device Size : 143374632 (68.37 GiB 73.41 GB)
   Super Offset : 143374632 sectors
          State : clean
    Device UUID : 1f4ab1e7:f8529f04:6c273e0a:510614ea
    Update Time : Wed Aug 31 18:57:23 2005
       Checksum : 15179289 - correct
         Events : 337384

         Layout : left-asymmetric
     Chunk Size : 128K

   Array State : uuuuuuuuuuuu_uuuuuuuuuuuuuuu 2 failed

