From: Steven Haigh <netwiz@crc.id.au>
Subject: Xen disk write slowness in kernel 3.8.x
Date: Wed, 03 Apr 2013 13:05:47 +1100
Message-ID: <515B8E7B.8070104@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm still trying to track down the cause of disk write slowness when 
passing through disks to a DomU.

I've restructured things a little and now pass the raid array (/dev/md3) 
directly to the DomU. When running a xfs_fsr on the filesystem from 
within the Dom0, I get the following:

# iostat -m 5
(....)
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.11    0.00    9.23   44.64    0.21   45.81

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdc             286.20        17.22        34.15         86        170
sdf             284.20        17.45        34.43         87        172
sdd             217.40        17.25        34.15         86        170
sde             211.00        17.25        34.38         86        171
md3            1095.40        69.20        67.18        346        335

This is with the RAID6 mounted on /mnt/fileshare from within the Dom0. 
Speeds are about what I would expect for the task that is going on.

With no changes at all to the setup or the RAID, I attach the same RAID6 
array to a DomU:

# xm block-attach zeus.vm phy:/dev/md3 xvdb w

Now run xfs_fsr from within the DomU, I look at the same output from 
iostat on Dom0:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.00    0.00    2.35    0.00    0.34   97.31

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdc             702.40        11.28        16.09         56         80
sdf             701.00        11.26        16.15         56         80
sdd             698.00        11.18        15.95         55         79
sde             700.60        11.27        16.19         56         80
md3            1641.00        30.30        29.87        151        149

I'm seeing this consistently across all methods of speed testing (dd, 
bonnie++, etc).

If I remove and attach a single disk from the array and run tests on 
that, I obtain full speed for the single drive. As soon as the array is 
passed, the speed drops significantly (as seen above).

I have copied in the linux-raid list to this - as it seems to only 
affect md arrays passed to the Xen DomU guests.

Where do we start debugging this?

-- 
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299
