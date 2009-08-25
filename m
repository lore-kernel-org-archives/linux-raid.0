From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: LVM cannot stop/remove LV, cannot stop/delete dead RAID situation.
Date: Tue, 25 Aug 2009 15:45:38 +0100
Message-ID: <4A93F912.5040900@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am having an issue with LVM and RAID in some failure cases:

It seems that any operations on a LVM LV (lvchange, lvremove, etc..), 
require this LV's metadata to be readable.

In case a LVM LV is setup ontop of a RAID 0, or a RAID 5 for instance, 
if two disks are lost from the RAID array, the array dies.

Now that the array is dead, I would like to recreate a new RAID 0 or 5 
using the remaining alive disks and some new ones. For this reason, I'd 
like to stop the previous dead RAID using mdadm.

However, because the LVM LV does still exists, it seems to have a handle 
on the dead RAID, as shon below:

# /opt/soma/bin/mdadm/mdadm --stop /dev/md/d0
raid manager: fail to stop array /dev/md/d0: Device or resource busy
Perhaps a running process, mounted filesystem or active volume group?

The Volume group created on this RAID's physical volume is:

/dev/1367191

The LVM LV that was created on this RAID is at the location:

/dev/1367191/1367259

Trying to stop or remove the LV as shown below will yield an error too, 
since the LVM metadata cannot be accessed, since the RAID this LVM is 
sitting on is dead:

# lvchange -an /dev/1367191/1367259
  /dev/1367191/1367259: read failed after 0 of 65536 at 0: Input/output 
error
  /dev/md/d0p2: read failed after 0 of 65536 at 0: Input/output error
  /dev/md/d0p3: read failed after 0 of 2048 at 0: Input/output error
  /dev/1367191/1367259: read failed after 0 of 65536 at 0: Input/output 
error
  /dev/1367191/1367259: read failed after 0 of 65536 at 0: Input/output 
error
  /dev/1367191/1367259: read failed after 0 of 65536 at 0: Input/output 
error
  /dev/md/d0: read failed after 0 of 65536 at 110275985408: Input/output 
error
  /dev/md/d0: read failed after 0 of 65536 at 110275985408: Input/output 
error
  /dev/md/d0p1: read failed after 0 of 1024 at 50266112: Input/output error
  /dev/md/d0p2: read failed after 0 of 65536 at 0: Input/output error
  /dev/md/d0p2: read failed after 0 of 65536 at 0: Input/output error
  /dev/md/d0p2: read failed after 0 of 65536 at 0: Input/output error
  /dev/md/d0p3: read failed after 0 of 512 at 110175191040: Input/output 
error
  /dev/md/d0p3: read failed after 0 of 512 at 110175293440: Input/output 
error
  /dev/md/d0p3: read failed after 0 of 512 at 0: Input/output error
  /dev/md/d0p3: read failed after 0 of 512 at 4096: Input/output error
  /dev/md/d0p3: read failed after 0 of 2048 at 0: Input/output error
  Volume group "1367191" not found

# lvremove -f /dev/1367191/1367259
  /dev/1367191/1367259: read failed after 0 of 65536 at 0: Input/output 
error
  /dev/md/d0p2: read failed after 0 of 65536 at 0: Input/output error
  /dev/md/d0p3: read failed after 0 of 2048 at 0: Input/output error
  /dev/1367191/1367259: read failed after 0 of 65536 at 0: Input/output 
error
  /dev/1367191/1367259: read failed after 0 of 65536 at 0: Input/output 
error
  /dev/1367191/1367259: read failed after 0 of 65536 at 0: Input/output 
error
  /dev/md/d0: read failed after 0 of 65536 at 110275985408: Input/output 
error
  /dev/md/d0: read failed after 0 of 65536 at 110275985408: Input/output 
error
  /dev/md/d0p1: read failed after 0 of 1024 at 50266112: Input/output error
  /dev/md/d0p2: read failed after 0 of 65536 at 0: Input/output error
  /dev/md/d0p2: read failed after 0 of 65536 at 0: Input/output error
  /dev/md/d0p2: read failed after 0 of 65536 at 0: Input/output error
  /dev/md/d0p3: read failed after 0 of 512 at 110175191040: Input/output 
error
  /dev/md/d0p3: read failed after 0 of 512 at 110175293440: Input/output 
error
  /dev/md/d0p3: read failed after 0 of 512 at 0: Input/output error
  /dev/md/d0p3: read failed after 0 of 512 at 4096: Input/output error
  /dev/md/d0p3: read failed after 0 of 2048 at 0: Input/output error
  Volume group "1367191" not found

-------------

The problem with the above is that because LVM depends on the RAID's 
good health to perform any operations, and the MD forbids to perform any 
operation should a handle be opened on itself, we cannot stop either the 
RAID or the LVM, unless the system is rebooted.

Since rebooting works, but that I cannot afford to reboot in this case, 
I was wondering if anybody
knew where to start looking to force the handle opened by LVM on the 
RAID to go away, maybe in the LVM admin programs (lvremove, lvchange) or 
in the dm driver itself?

Thanks a million in advance for your advices.

Ben - MPSTOR.
