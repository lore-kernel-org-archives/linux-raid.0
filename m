From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: /dev/md/xxx sporadically unavailable after mdadm --assemble
 /dev/md/xxx
Date: Sun, 15 Mar 2015 10:42:55 +0300
Message-ID: <20150315104255.6c9f7af5@opensuse.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I hit this when running test suite that is using Linux MD over loop
devices. Sporadically it fails to mount raid after mdadm --assembly
with 

mdadm: array /dev/md/mdraid10_raid1_6 started.
mdadm: stopped /dev/md/mdraid10_raid1_6
mdadm: /dev/md/mdraid10_raid1_6 has been started with 6 drives.
mount: special device /dev/md/mdraid10_raid1_6 does not exist

How naive is the assumption that when "mdadm --assemble" returns
devices are available? Should every use of mdadm be now followed by
waiting for device?

Code is simply

                xmdraid*)
                    mdadm --assemble /dev/md/"${fs}_$NDEVICES" "${LODEVICES[@]}"
                    sleep 1
                    mount -t "$MOUNTFS" "${MOUNTDEVICE}" "$MNTPOINTRO" -o ${MOUNTOPTS}${SELINUXOPTS}ro ;;


but apparently even one second wait is not enough. But where is the
limit?

Of course when you look after test failure all devices are there.

Using mdadm 3.3.1 on openSUSE 13.2.
