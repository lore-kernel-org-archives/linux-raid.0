From: Neil Brown <neilb@suse.de>
Subject: Re: Linux Software RAID /sysfs repair issue
Date: Thu, 15 May 2008 10:16:59 +1000
Message-ID: <18475.33019.601821.898292@notabene.brown>
References: <EEEB1FA7BB798343BD171137F3E7FA53069EF4@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Fairbanks, David on Tuesday May 13
Sender: linux-raid-owner@vger.kernel.org
To: "Fairbanks, David" <David.Fairbanks@stratus.com>
Cc: mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 13, David.Fairbanks@stratus.com wrote:
> Hello Linux SW RAID maintainers;
> 
> I am a software engineer at Stratus Technologies in Maynard, MA.
> I am running into an issue using the /sysfs "repair" functionality.
> kernel version: 2.6.18-87.el5 (RHEL5, update 2)

Hi David.  Thanks for reporting this problem.

Unfortunately I cannot reproduce it as my test machine has SATA drives
which don't seem to support WRITE_LONG.

What should be happening during the 'repair' is that we should be
doing 64K reads from all devices and comparing the data.
If we hit a read error in one of these reads, the data read from the
other device should be written over the area with the read error.

This suggests that 64K offsets might be significant, but other 4K
offsets shouldn't be... yet obviously they are (2000 isn't a multiple
of 128)......

4K is significant as that is the page size.  The 64K is 16 pages, and
there is a 'vector' of addresses that is passed down with the request.
If something is getting confused there, we could get a 4K artifact.

Yes, I think I see it.  Could you please try with this patch, against
a recent kernel?

If that is the correct fix, I'll need to check elsewhere in the code
to make sure I haven't made that mistake multiple times.

Thanks,
NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2008-04-29 12:27:58.000000000 +1000
+++ ./drivers/md/raid1.c	2008-05-15 10:15:54.000000000 +1000
@@ -1295,10 +1295,13 @@ static void sync_request_write(mddev_t *
 					sbio->bi_sector = r1_bio->sector +
 						conf->mirrors[i].rdev->data_offset;
 					sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-					for (j = 0; j < vcnt ; j++)
+					for (j = 0; j < vcnt ; j++) {
+						sbio->bi_io_vec[j].bv_len += sbio->bi_io_vec[j].bv_offset;
+						sbio->bi_io_vec[j].bv_offset = 0;						
 						memcpy(page_address(sbio->bi_io_vec[j].bv_page),
 						       page_address(pbio->bi_io_vec[j].bv_page),
 						       PAGE_SIZE);
+					}
 
 				}
 			}
