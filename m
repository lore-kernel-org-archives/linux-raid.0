From: Phil Turmel <philip@turmel.org>
Subject: Re: Determining which spindle is out of order
Date: Wed, 03 Nov 2010 21:54:54 +0000
Message-ID: <4CD1DA2E.5060205@turmel.org>
References: <loom.20101103T115828-494@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20101103T115828-494@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Nat Makarevitch <Shelso@makarevitch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/3/2010 2:13 PM, Nat Makarevitch wrote:
> Hi,
> 
> After a spindle (physical hard disk, a "drive") failure in a "md" RAID array,
> how can we know which spindle must be replaced?
> 
> We want to avoid extracting a working spindle by mistakenly thinking it is the
> faulty one...

I wrote a little script that would tell me device name and serial number for each host port on my motherboard, along with anything else that lists a scsi host in sysfs.  Output like so:

Controller device @ pci0000:00/0000:00:1c.1/0000:06:00.0 [ahci]
  RAID bus controller: Marvell Technology Group Ltd. 88SE6145 SATA II PCI-E controller (rev a1)
    host4: [Empty]
    host5: /dev/sdd ATA WDC WD5000AAKS-7 {SN: WD-WMAWF1370668}
    host6: [Empty]
    host7: [Empty]
    host8: [Empty]
Controller device @ pci0000:00/0000:00:1f.1 [ata_piix]
  IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01)
    host9: [Empty]
    host10: [Empty]
Controller device @ pci0000:00/0000:00:1f.2 [ahci]
  SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA AHCI Controller (rev 01)
    host0: /dev/sda ATA ST31000333AS {SN: 9TE1LTW0}
    host1: /dev/sdb ATA ST31000333AS {SN: 9TE1MAJT}
    host2: /dev/sdc ATA ST31000333AS {SN: 9TE1MV1R}
    host3: /dev/sr0 HL-DT-ST BD-RE GBW-H20L

Shows me my empty ports, too.  As long as I keep my cables straight to my hot-swap bays, getting the right drive is a snap.

HTH,

Phil

I hereby release the following script into the public domain:

#! /bin/bash
#
# Examine specific system host devices to identify the drives attached
#

function describe_controller () {
        unset SUBSYSTEM PCI_ID DEVICE PCI_SLOT_NAME Manufacturer Product Serial
        eval `udevadm info --query=all --path="$1" |grep '^E: ' |cut -c 4-`
        echo "Controller device @ ${1##/sys/devices/} [$DRIVER]"
        if [[ -n "$PCI_SLOT_NAME" ]] ; then
                echo -e "  `lspci -s $PCI_SLOT_NAME |cut -d\  -f2-`"
        fi
        if [[ "${MODALIAS:0:4}" == "usb:" ]] ; then
                eval `lsusb -D ${DEVICE/proc/dev/} |sed -r -n -e 's% *i(Manufacturer|Product|Serial) +[0-9]+ +(.+) *$%\1="\2"%;tFND;b;:FND;p'`
                echo -e "  [$Manufacturer] $Product {SN: $Serial}"
        fi
}

function describe_device () {
        targ=${1%/block/*}
        vnd="`cat $targ/vendor`"
        mdl=`cat $targ/model`
        rdev=`readlink -f "$1"`
        if [[ -d $rdev ]] ; then
                bdev="`basename $rdev`"
                sn="`sginfo -s /dev/$bdev |sed -r -n -e \"/Serial Number/{s%^.+' *(.+) *'.*\\\$%\\\\1%;p;q}\"`" &>/dev/null
                if [[ -n "$sn" ]] ; then
                        echo -e "    $bhost: `echo /dev/$bdev $vnd $mdl {SN: $sn}`"
                else
                        echo -e "    $bhost: `echo /dev/$bdev $vnd $mdl`"
                fi
        else
                echo -e "    $bhost: Unknown $rdev"
        fi
}

function check_host () {
        local found=0
        local pController=
        while read shost ; do
                host=`dirname "$shost"`
                controller=`dirname "$host"`
                bhost=`basename "$host"`
                if [[ "$controller" != "$pController" ]] ; then
                        pController="$controller"
                        describe_controller "$controller"
                fi
                for dev in $host/target*/*/block/* ; do
                        if [[ "${dev: -1}" == '*' ]] ; then
                                echo -e "    $bhost: [Empty]"
                        else
                                describe_device "$dev"
                        fi
                done
        done
}

find /sys/devices/ -name scsi_host |check_host

