From: Martin Wilck <mwilck@arcor.de>
Subject: Suspicious test failure - mdmon misses recovery events on loop devices
Date: Fri, 26 Jul 2013 22:58:05 +0200
Message-ID: <51F2E2DD.8090204@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090408060108070505060002"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090408060108070505060002
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Neil, everybody,

I am currently pulling my hair over strange failures I am observing. I
was trying to create a new unit test for DDF along the same lines as
09imsm-create-fail-rebuild. That's of course a very important test -
making sure that an array can actually recover from a disk failure.

The script does just that - create a container with 2 subarrays, fail a
disk, add a spare, and expect everything to be recovered after that.

What I find is that the recovery actually works, but sometimes the meta
data is broken after the test has finished. The added disk is shown in
"Rebuilding" state and/or one or both subarrays are considered
"degraded" although the kernel log clearly shows that the recovery
finished. The problem occurs almost always if the test is done on loop
devices, as in mdadm's "test" script. Just did another test, failed
10/10 attempts on loop devices. If I use LVM logical volumes instead (on
the same physical disk), the test never fails (0/10).

In the success case, the script prints only one line (its log file). In
the bad case, it will print some more lines of mdadm -E information. The
log file contains all the details.

I have come to the conclusion that if the failure occurs, mdmon simply
misses one or more state changes of the arrays and/or disks. For mdmon
to notice that the recovery has finished, it is crucial to see a
situation where sync_action is "idle", and had been "recover" before,
for both subarrays. This happens if I run the test on LVM, but not if I
run it on a loop device.

Thinking about it - what guarantee is there that mdmon catches a certain
kernel status change? If I read the code correctly, mdmon will only
catch it if
 (a) the status change occurs while mdmon is in the select() call, and
 (b) the status in sysfs doesn't change again between the return from
select() and mdmon reading the sysfs file contents.

I can see no guarantee that this always works, and with my loop device
test case I seem to have found a scenario where it actually doesn't. I
suppose that mdmon may be busy writing the DDF metadata while the kernel
event about finished recovery is arriving.

My first idea was that the the cause were the loop devices on my CentOS6
kernel not supporting O_DIRECT properly (recovery finishes almost
immediately in the page cache, perhaps too quickly for mdmon to notice),
but running a more recent kernel with proper O_DIRECT in the loop
device, I still see the problem, although the recovery takes longer now.

There is still a chance that I messed something up in DDF (I haven't
seen the problem with IMSM), but it isn't likely given that the test
always works fine on LVM. I am pretty much at my wit's end here and I'd
like to solicit some advice.

I'd definitely like to understand exactly what's going wrong here, but
it's very hard to debug because it's a timing issue involving the
kernel, mdadm, mdmon, and the manager. Adding debug code changes the
probability to hit the problem

Thanks for reading this far, I hope someone has an idea.

Martin

PS: In that context, reading mdmon-design.txt, is it allowed at all to
add dprintf() messages in the code path called by mdmon? That would also
affect some DDF methods where I currently have lots of debug code.

--------------090408060108070505060002
Content-Type: text/plain;
 name="22-ddf-fail"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="22-ddf-fail"

#! /bin/bash
mdadm=/home/martin/mdadm/mdadm
n=1
log=$(printf /var/tmp/md-%04d.log $n)
while [ -e $log ]; do
    n=$((n+1))
    log=$(printf /var/tmp/md-%04d.log $n)
done
echo log=$log

exec 3>&2
exec 1>$log 2>&1

TRAP=
trap 'eval "$TRAP"' 0

set -x
setup_lo() {
    for i in `seq 8 13`; do
	mknod /dev/loop$i b 7 $i
	losetup /dev/loop$i /var/tmp/mdtest$i
	eval "dev$i=/dev/loop$i"
    done >/dev/null 2>&1
    TRAP="cleanup_lo; $TRAP"
}

cleanup_lo() {
    for i in `seq 8 13`; do
	eval "losetup -d \$dev$i"
    done >/dev/null 2>&1
}

setup_lvm() {
    for i in `seq 8 13`; do
	eval "dev$i=/dev/tosh/rd$((i-7))"
    done
}

#setup_lvm
setup_lo

# for testing with IMSM instead of DDF
#export IMSM_NO_PLATFORM=1
#export IMSM_DEVNAME_AS_SERIAL=1
#export IMSM_TEST_OROM=1
#export MDADM_EXPERIMENTAL=1

dmesg -c >/dev/null
#date +"CREATE %H:%M:%S.%N"
$mdadm --quiet -CR /dev/md/ddf -e ddf -n 4 $dev8 $dev9 $dev10 $dev11 --auto=yes
$mdadm --quiet -CR /dev/md/vol1 $dev8 $dev9 $dev10 $dev11 -n 4 -l 5 -z 4000 -c 64 --auto=yes
$mdadm --quiet -CR /dev/md/vol0 $dev8 $dev9 $dev10 $dev11 -n 4 -l 10 -z 9000 -c 64 --auto=yes
$mdadm --quiet --wait /dev/md/vol[01]
#date +"WAIT %H:%M:%S.%N"

# get PID of mdmon for tracing
#for x in $(ps --no-heading -Lo lwp -C mdmon); do trace_cmd="$trace_cmd -p $x"; done

$mdadm --quiet --fail /dev/md/vol0 $dev11
#date +"FAIL %H:%M:%S.%N"

#strace -tt -x -o /tmp/md.str $trace_cmd &

$mdadm --quiet --add /dev/md/ddf $dev12
#date +"ADD %H:%M:%S.%N"

$mdadm --quiet --wait /dev/md/vol[01]
#date +"WAIT %H:%M:%S.%N"

cat /proc/mdstat
dmesg -c
$mdadm -E $dev11
$mdadm -E $dev12
$mdadm -Ss

# if strace was used above
#cat /tmp/md.str
set +x
egrep -i 'error|failed|rebuilding|Degraded,' $log >&3

--------------090408060108070505060002--
