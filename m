From: spam@streefland.xs4all.nl (Dick Streefland)
Subject: Re: RAID1 recovery fails with 2.6 kernel
Date: Wed, 22 Oct 2003 18:59:36 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5695.3f96d398.a61b9@altium.nl>
References: <297d.3f93a033.85d8f@altium.nl> <7da.3f929f6e.d36f3@altium.nl> <16275.32127.862408.701013@notabene.cse.unsw.edu.au> <297d.3f93a033.85d8f@altium.nl> <1066844591.1260.31.camel@star2>
Reply-To: dick.streefland@xs4all.nl (Dick Streefland)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Tran <mhtran@us.ibm.com> wrote:
| I have been experiencing the same problem on my test machine.  I found
| out that the resync terminated early because of MD_RECOVERY_ER R bit set
| by raid1's sync_write_request().  I don't understand why it fails the
| sync when all the writes already completed successfully and quickly.  If
| there is a need to check for "nowhere to write this to" as in 2.4.x
| kernel, I think we need a different check.
| 
| The following patch for 2.6.0-test8 kernel seems to fix it.
| 
| --- a/raid1.c   2003-10-17 16:43:14.000000000 -0500
| +++ b/raid1.c   2003-10-22 11:57:59.350900256 -0500
| @@ -841,7 +841,7 @@
|         }
|  
|         if (atomic_dec_and_test(&r1_bio->remaining)) {
| -               md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, 0);
| +               md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, 1);
|                 put_buf(r1_bio);
|         }
|  }

This is exactly the spot where I interrupted my investigations last
night to get some sleep. I can confirm that your patch fixes the
problem. Thanks!

-- 
Dick Streefland                    ////               De Bilt
dick.streefland@xs4all.nl         (@ @)       The Netherlands
------------------------------oOO--(_)--OOo------------------

