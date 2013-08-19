From: taejin1999@davinci.snu.ac.kr
Subject: Does the chunk size of RAID5 really mean the "smallest atomic"
 mass of data?
Date: Mon, 19 Aug 2013 10:10:18 +0900
Message-ID: <0d357591ae9c24e2e07dadd5ce7ee873.squirrel@davinci.snu.ac.kr>
Mime-Version: 1.0
Content-Type: text/plain;charset=euc-KR
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have counted the number of write requests from the raid disks which are
implemented as virtual block devices.
The result is
  ** the larger chunk size is, the more write requests are received per
device.

I was wondering what the "chunk size" means on RAID5 of mdadm.
According to below site, chunk is the smallest atomic mass of data that
can be written to the device.
(https://raid.wiki.kernel.org/index.php/RAID_setup)

The source code, however, seems to work differently.
As I know, mdadm issues bio to each device in ops_run_io function.
In the code, the size of bio is set to be only STRIPE_SIZE.
I think the device would get STRIPE_SIZE-sized data which is smaller than
the chunk size.

Is the chunk size not smallest data that can be written to the device?
Or is there any procedure that merge the STRIPE_SIZE-sized data into
chunk-sized data?

I am looking forward to your reply.
Thank you.

PS) Could you guess why more writes are issued for larger chunk size?

