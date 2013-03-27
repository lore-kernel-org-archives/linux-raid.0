From: "Paramasivam, Meenakshisundaram" <mparamas@iupui.edu>
Subject: RE: mdadm RAID6 faulty drive
Date: Wed, 27 Mar 2013 20:46:32 +0000
Message-ID: <B2B36B3006DB4C47A56D6BA19443F5D12DE7B5E2@IU-MSSG-MBX110.ads.iu.edu>
References: <B2B36B3006DB4C47A56D6BA19443F5D12DE79EF4@IU-MSSG-MBX110.ads.iu.edu>,<51508CD6.50702@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51508CD6.50702@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Thanks for the smartctl. Though smartctl -t short /dev/sdf passed the test, I was still unable to add the drive.

Then I did this:
#mdadm /dev/md2 --remove /dev/sdf
#mdadm --stop /dev/md2  (after turning off all processes
#dd if=/dev/zero of=/dev/sdf
dd: writing to `/dev/sdf': Input/output error
8522041+0 records in
8522040+0 records out
4363284480 bytes (4.4 GB) copied, 138.782 s, 31.4 MB/s

Appears to be a bad drive, I will replace it. 

Sundar

________________________________________
From: Phil Turmel [philip@turmel.org]
Sent: Monday, March 25, 2013 1:43 PM
To: Paramasivam, Meenakshisundaram
Cc: linux-raid@vger.kernel.org
Subject: Re: mdadm RAID6 faulty drive

On 03/25/2013 12:02 PM, Paramasivam, Meenakshisundaram wrote:
>
> Hi,
>
> As a result of extended power outage, the FedoraCore 17 machine with
> mdadm RAID went down. Bringing it up, I noticed "faulty /dev/sdf" in
> mdadm -detail. However mdadm -E /dev/sdf shows "State : clean".
> Details are shown below. When I tried to add the drive to array,
> resync fails (I see lots of eSATA bus resets), and I get the same
> message in mdadm -detail.
>
> Questions:
> 1. How can a clean drive be reported faulty?

When the drive is kicked out for I/O errors its superblock is left as-is
(just as if you pulled its sata cable).  The remaining devices'
superblocks are marked to show the failed drive, and *their*
superblocks' event count is bumped.  The failed status of that device is
derived during assembly when its superblock is found to be stale.

> 2. Is there a easy way to mark drive (/dev/sdf) as "assume-clean" and
> add it?

No.  The closest thing is to use a write-intent bitmap and "re-add"
devices that are disconnected.

That's not your problem.

> Please let me know if I should get an exact  replacement drive at
> this stage, pull out faulty /dev/sdf, and add the new drive to array.
> Thanks.

You very likely need a new drive.  You might want to try plugging that
drive into a different controller, or a different port on the same
controller, just to narrow the diagnosis.

You could also show us some of the kernel error messages, or show the
output of "smartctl -x /dev/sdf".

Phil
