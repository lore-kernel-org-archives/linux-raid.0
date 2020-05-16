From: dfavro@meta-dynamic.com
Subject: Script to demonstrate underflow in mdadm
Date: Sat, 16 May 2020 00:56:52 -0400
Message-ID: <20200516045652.618FB19801B4@minderbinder.meta-dynamic.com>
References: <20200516035020.ABA6D19801B5@minderbinder.meta-dynamic.com>
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200516035020.ABA6D19801B5@minderbinder.meta-dynamic.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Below is a script which makes a few very small (<128K) loopback
devices, then tries to assemble them with mdadm.  It demonstrates
the underflow bug for which I previously sent the patch.  It's a
bash script, not a posix-shell script, as indicated in the shebang.
It creates and destroys devices with hard-coded paths
(/dev/loop[1-3], /dev/md99, etc.), so only run it with caution!


==== Here is the output when I run it:


% sudo ./mdadm-patch-test.bash

RAID-5, metadata 1.2, unpatched:
 /sbin/mdadm --create --verbose /dev/md99 --chunk=256 --level=5 --layout=left-symmetric --raid-devices=3 /dev/loop1 /dev/loop2 /dev/loop3 --metadata=1.2
mdadm: size set to 9223372036854774784K
mdadm: automatically enabling write-intent bitmap on large array
./mdadm-patch-test.bash: line 24: 554310 Floating point exception${cmd}

RAID-5, metadata 1.2, patched:
 ./mdadm --create --verbose /dev/md99 --chunk=256 --level=5 --layout=left-symmetric --raid-devices=3 /dev/loop1 /dev/loop2 /dev/loop3 --metadata=1.2
device /dev/loop1 is too small (64K) for required metadata!
mdadm: /dev/loop1 is not suitable for this array.
device /dev/loop2 is too small (64K) for required metadata!
mdadm: /dev/loop2 is not suitable for this array.
device /dev/loop3 is too small (64K) for required metadata!
mdadm: /dev/loop3 is not suitable for this array.
mdadm: create aborted

RAID-5, metadata 1.1, unpatched:
 /sbin/mdadm --create --verbose /dev/md99 --chunk=256 --level=5 --layout=left-symmetric --raid-devices=3 /dev/loop1 /dev/loop2 /dev/loop3 --metadata=1.1
mdadm: size set to 9223372036854774784K
mdadm: automatically enabling write-intent bitmap on large array
./mdadm-patch-test.bash: line 24: 554321 Floating point exception${cmd}

RAID-5, metadata 1.1, patched:
 ./mdadm --create --verbose /dev/md99 --chunk=256 --level=5 --layout=left-symmetric --raid-devices=3 /dev/loop1 /dev/loop2 /dev/loop3 --metadata=1.1
device /dev/loop1 is too small (64K) for required metadata!
mdadm: /dev/loop1 is not suitable for this array.
device /dev/loop2 is too small (64K) for required metadata!
mdadm: /dev/loop2 is not suitable for this array.
device /dev/loop3 is too small (64K) for required metadata!
mdadm: /dev/loop3 is not suitable for this array.
mdadm: create aborted

RAID-1, metadata 1.2, unpatched:
 /sbin/mdadm --create --verbose /dev/md99 --level=1 --raid-devices=2 /dev/loop1 /dev/loop2 --metadata=1.2
mdadm: size set to 9223372036854774784K
mdadm: automatically enabling write-intent bitmap on large array
./mdadm-patch-test.bash: line 24: 554339 Floating point exception${cmd}

RAID-1, metadata 1.2, patched:
 ./mdadm --create --verbose /dev/md99 --level=1 --raid-devices=2 /dev/loop1 /dev/loop2 --metadata=1.2
device /dev/loop1 is too small (32K) for required metadata!
mdadm: /dev/loop1 is not suitable for this array.
device /dev/loop2 is too small (32K) for required metadata!
mdadm: /dev/loop2 is not suitable for this array.
mdadm: create aborted

RAID-1, metadata 1.1, unpatched:
 /sbin/mdadm --create --verbose /dev/md99 --level=1 --raid-devices=2 /dev/loop1 /dev/loop2 --metadata=1.1
mdadm: size set to 9223372036854774784K
mdadm: automatically enabling write-intent bitmap on large array
./mdadm-patch-test.bash: line 24: 554349 Floating point exception${cmd}

RAID-1, metadata 1.1, patched:
 ./mdadm --create --verbose /dev/md99 --level=1 --raid-devices=2 /dev/loop1 /dev/loop2 --metadata=1.1
device /dev/loop1 is too small (32K) for required metadata!
mdadm: /dev/loop1 is not suitable for this array.
device /dev/loop2 is too small (32K) for required metadata!
mdadm: /dev/loop2 is not suitable for this array.
mdadm: create aborted
%


==== Here's the script:

#!/bin/bash


#sudo="sudo" # empty-string if run as root
sudo=""

md_dev="/dev/md99"


# Create test devices:
mk_devs() {
  n_dev="${1}"
  devsize="${2}"
  for (( n=1; n<="${n_dev}"; ++n )) do
    dev="/dev/loop${n}"
    file="/tmp/component-0${n}"
    truncate -s "${devsize}" "${file}"
    ${sudo} losetup "${dev}" "${file}"
  done
}


# Do one test run:
do_run() {
  lbl="${1}"
  mdvers="${2}"
  echo -e "\n${lbl}, metadata ${mdvers}, unpatched:"
  cmd="${sudo} /sbin/mdadm ${args} --metadata=${mdvers}"
  echo "${cmd}"
  ${cmd}
  ${sudo} /sbin/mdadm --stop "${md_dev}" 2>/dev/null
  echo -e "\n${lbl}, metadata ${mdvers}, patched:"
  cmd="${sudo} ./mdadm ${args} --metadata=${mdvers}"
  echo "${cmd}"
  ${cmd}
  ${sudo} /sbin/mdadm --stop "${md_dev}" 2>/dev/null # not necessary, create fails
}


# --- RAID level 5:
mk_devs 3 65536

args="--create --verbose ${md_dev} --chunk=256 --level=5 --layout=left-symmetric --raid-devices=3 /dev/loop1 /dev/loop2 /dev/loop3"
do_run RAID-5 1.2
do_run RAID-5 1.1

${sudo} losetup -d /dev/loop1 /dev/loop2 /dev/loop3
rm -f /tmp/component-01 /tmp/component-02 /tmp/component-03


# --- RAID level 1:
mk_devs 2 32768

args="--create --verbose ${md_dev} --level=1 --raid-devices=2 /dev/loop1 /dev/loop2"
do_run RAID-1 1.2
do_run RAID-1 1.1

${sudo} losetup -d /dev/loop1 /dev/loop2
rm -f /tmp/component-01 /tmp/component-02
