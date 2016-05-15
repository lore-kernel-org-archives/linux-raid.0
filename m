From: Wolfgang Denk <wd@denx.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller
Date: Sun, 15 May 2016 15:37:40 +0200
Message-ID: <20160515133740.85EC3100879@atlas.denx.de>
References: <20160515124534.A42D0100879@atlas.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20160515124534.A42D0100879@atlas.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

In message <20160515124534.A42D0100879@atlas.denx.de> I wrote:
> 
> I managed to kill a RAID6...
...

Trying to follow the overlay method in [1], I run into errors; guess I
must be missing something:


[1] https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file


# DEVICES="/dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf"

# ls /dev/loop*
/dev/loop-control  /dev/loop0  /dev/loop1  /dev/loop2  /dev/loop3  /dev/loop4
# parallel 'test -e /dev/loop{#} || mknod -m 660 /dev/loop{#} b 7 {#}' ::: $DEVICES
# ls /dev/loop*
/dev/loop-control  /dev/loop0  /dev/loop1  /dev/loop2  /dev/loop3  /dev/loop4  /dev/loop5  /dev/loop6

# parallel truncate -s4000G overlay-{/} ::: $DEVICES

# parallel 'size=$(blockdev --getsize {}); loop=$(losetup -f --show -- overlay-{/}); echo 0 $size snapshot {} $loop P 8 | dmsetup create {/}' ::: $DEVICES

# OVERLAYS=$(parallel echo /dev/mapper/{/} ::: $DEVICES)
# echo $OVERLAYS 
/dev/mapper/sda /dev/mapper/sdb /dev/mapper/sdc /dev/mapper/sdd /dev/mapper/sde /dev/mapper/sdf

# dmsetup status
castor2-git_backup: 0 67108864 linear 
live-base: 0 12582912 linear 
castor2-f22: 0 67108864 linear 
castor2-root: 0 134217728 linear 
castor2-f19: 0 100663296 linear 
castor2-f19: 100663296 33554432 linear 
castor2-f21: 0 134217728 linear 
castor2-f18: 0 67108864 linear 
castor2-f20: 0 67108864 linear 
sdf: 0 1953525168 snapshot 16/8388608000 16
sde: 0 1953525168 snapshot 16/8388608000 16
sdd: 0 1953525168 snapshot 16/8388608000 16
live-osimg-min: 0 12582912 snapshot 3688/3688 24
sdc: 0 1953525168 snapshot 16/8388608000 16
live-rw: 0 12582912 snapshot 462664/1048576 1816
sdb: 0 1953525168 snapshot 16/8388608000 16
sda: 0 1953525168 snapshot 16/8388608000 16

# devices="/dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf"
# overlay_create()
> {
>         free=$((`stat -c '%a*%S/1024/1024' -f .`))
>         echo free ${free}M
>         overlays=""
>         overlay_remove
>         for d in $devices; do
>                 b=$(basename $d)
>                 size_bkl=$(blockdev --getsz $d) # in 512 blocks/sectors
>                 # reserve 1M space for snapshot header
>                 # ext3 max file length is 2TB   
>                 truncate -s$((((size_bkl+1)/2)+1024))K $b.ovr || (echo "Do you use ext4?"; return 1)
>                 loop=$(losetup -f --show -- $b.ovr)
>                 # https://www.kernel.org/doc/Documentation/device-mapper/snapshot.txt
>                 dmsetup create $b --table "0 $size_bkl snapshot $d $loop P 8"
>                 echo $d $((size_bkl/2048))M $loop /dev/mapper/$b
>                 overlays="$overlays /dev/mapper/$b"
>         done
>         overlays=${overlays# }
> }
# overlay_remove()
> {
>         for d in $devices; do
>                 b=$(basename $d)
>                 [ -e /dev/mapper/$b ] && dmsetup remove $b && echo /dev/mapper/$b 
>                 if [ -e $b.ovr ]; then
>                         echo $b.ovr
>                         l=$(losetup -j $b.ovr | cut -d : -f1)
>                         echo $l
>                         [ -n "$l" ] && losetup -d $(losetup -j $b.ovr | cut -d : -f1)
>                         rm -f $b.ovr &> /dev/null
>                 fi
>         done
> }

# echo $OVERLAYS
/dev/mapper/sda /dev/mapper/sdb /dev/mapper/sdc /dev/mapper/sdd /dev/mapper/sde /dev/mapper/sdf
#  mdadm --create --force --verbose /dev/md2 --metadata=1.2 --level=6 --raid-devices=6 --chunk=16 --assume-clean  $OVERLAYS
mdadm: layout defaults to left-symmetric
mdadm: super1.x cannot open /dev/mapper/sda: Device or resource busy
mdadm: /dev/mapper/sda is not suitable for this array.
mdadm: super1.x cannot open /dev/mapper/sdb: Device or resource busy
mdadm: /dev/mapper/sdb is not suitable for this array.
mdadm: super1.x cannot open /dev/mapper/sdc: Device or resource busy
mdadm: /dev/mapper/sdc is not suitable for this array.
mdadm: super1.x cannot open /dev/mapper/sdd: Device or resource busy
mdadm: /dev/mapper/sdd is not suitable for this array.
mdadm: super1.x cannot open /dev/mapper/sde: Device or resource busy
mdadm: /dev/mapper/sde is not suitable for this array.
mdadm: super1.x cannot open /dev/mapper/sdf: Device or resource busy
mdadm: /dev/mapper/sdf is not suitable for this array.
mdadm: create aborted

mdadm --assemble --force /dev/md2  $OVERLAYS
mdadm: /dev/mapper/sda is busy - skipping
mdadm: /dev/mapper/sdb is busy - skipping
mdadm: /dev/mapper/sdc is busy - skipping
mdadm: /dev/mapper/sdd is busy - skipping
mdadm: /dev/mapper/sde is busy - skipping
mdadm: /dev/mapper/sdf is busy - skipping

# overlay_create
free 1843M
device-mapper: remove ioctl on sda failed: Device or resource busy
Command failed
device-mapper: remove ioctl on sdb failed: Device or resource busy
Command failed
device-mapper: remove ioctl on sdc failed: Device or resource busy
Command failed
device-mapper: remove ioctl on sdd failed: Device or resource busy
Command failed
device-mapper: remove ioctl on sde failed: Device or resource busy
Command failed
device-mapper: remove ioctl on sdf failed: Device or resource busy
Command failed
device-mapper: create ioctl on sda failed: Device or resource busy
Command failed
/dev/sda 953869M /dev/loop11 /dev/mapper/sda
device-mapper: create ioctl on sdb failed: Device or resource busy
Command failed
/dev/sdb 953869M /dev/loop12 /dev/mapper/sdb
device-mapper: create ioctl on sdc failed: Device or resource busy
Command failed
/dev/sdc 953869M /dev/loop13 /dev/mapper/sdc
device-mapper: create ioctl on sdd failed: Device or resource busy
Command failed
/dev/sdd 953869M /dev/loop14 /dev/mapper/sdd
device-mapper: create ioctl on sde failed: Device or resource busy
Command failed
/dev/sde 953869M /dev/loop15 /dev/mapper/sde
device-mapper: create ioctl on sdf failed: Device or resource busy
Command failed
/dev/sdf 953869M /dev/loop16 /dev/mapper/sdf


What am I doing wrong?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"Do we define evil as the absence of goodness? It seems only  logical
that shit happens--we discover this by the process of elimination."
                                                        -- Larry Wall
