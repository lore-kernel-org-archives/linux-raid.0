From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Maintenance Checklist (sanity check request)
Date: Mon, 3 Nov 2014 16:45:08 -0600
Message-ID: <CAPSPcXhug=zNrS8yNANPyTFn2ri0-NgsfRs5YiCyHVX7O7HQXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am trying to put together a thorough(ish) checklist of things that I
can run through every few months to be sure everything is all good
with my array.  I'm interested in any suggestions about what I have as
well as anything else I should include for catching typical problems
of hobby level users with consumer grade hardware and just the kinds
of things you typically ask people who come on the list with crises.



1.  Which disks are part of the array?  Is everything active?
$ cat /proc/mdstat

2.   # for x in /dev/sd? ; do echo "Checking $x" ; smartctl -x $x |
grep "SCT Error Recovery Control " ; done
a. Which disks support ERC?
b. using "# smartctl -x /dev/sdX" on the devices supporing ERC, is ERC enabled?
c. if supported but Disabled, enable ERC with "# smartctl -l
scterc,70,70 /dev/sdX"
d. Which disks to not support ERC?
e. "$ for x in /sys/block/sd*/device/timeout ; do echo $x $(< $x) ;
done" What are the timeouts set to for each drive from d?
f. if any drive which does not support ERC has a default timeout, set
it to 180 with "# echo 180 >/sys/block/sdX/device/timeout"
g. Are any disks which support ERC using timeouts greater than the
default?  (they should not be)


3. # for x in /dev/sd? ; do echo "Checking $x" ; smartctl -x $x | grep
-e "Reallocated_Sector_Ct" -e "Current_Pending_Sector" ; done
Note which drives have nonzero reallocations or pending sectors.  Any
drive with double digits of reallocations should be replaced.

4.  Run a repair to resync the array "# echo repair >
/sys/block/md0/md/sync_action"
a.  did it complete without crashing?
b.  how long did it take?
c.  what is the value of /sys/block/md0/md/mismatch_cnt after the
repair was performed?

5.  Scan the filesystem.
sudo service nfs-kernel-server stop
sudo umount /dev/md0 (if this fails, "sudo lsof | grep vault", then
"sudo kill -KILL [pid]" of any processes using it and try again)
a. sudo e2fsck -y /dev/md0  is it clean?
b. sudo e2fsck -fy /dev/md0 any other errors on a full scan?




Thanks for your suggestions
