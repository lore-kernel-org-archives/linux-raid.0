From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: How is an IO size are determnied ?
Date: Mon, 3 Apr 2006 10:31:40 +0300
Message-ID: <5d96567b0604030031q768933a1p49f94e53313a42b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>, Jens Axboe <axboe@suse.de>
List-Id: linux-raid.ids

Neil/Jens  Hello.
Hope is this not too much bother for you.

Question: how does the psuedo device ( /dev/md )  change the
IOs sizes going down into the disks ?

Explanation:
I am using software raid5 , chunk size is 1024K, 4 disks.
I have made a hook in make_request inorder to bypass
the raid5 IO methodology .I need to control the amount of IOs
going down into the disk and their sizes.
the hook looks like this.


static int make_request (request_queue_t *q, struct bio * bi){
...
if ( bypass_raid5 &&  bio_data_dir(bi) == READ )
        {
                new_sector = raid5_compute_sector(bi->bi_sector,
                                                                      
           raid_disks,
                                                                      
           data_disks,
                                                                      
           &dd_idx,
                                                                      
           &pd_idx,
                                                                      
           conf);

                bi->bi_sector = new_sector;
                bi->bi_bdev =  conf->disks[dd_idx].rdev->bdev;
                 return 1;
}
...
}

I have compared the IOs sizes and numbers in the deadline elevator.
it seems that an a single direct IO read of 1MB to a disk
is divided into two 1/2 MB request_t ( though max_hw_sectors=2048)
and when I go through the raid i am getting three request_t's
992 sectors followed by 64 sectors followed by 992 sectors.
I have also recorded the IOs going in make_request in this
scenario, it is composed of 8 124K and an additional 32K
request.

the test:
My test is simple . I am reading the device in direct io mode
and no file system in involved.
could you explain this ? why I am not getting two 1/2 MB ?
Could it be the slab cache ? ( biovec256)

Thank you
--
Raz
