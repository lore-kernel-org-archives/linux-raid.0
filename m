From: Chris <email.bug@arcor.de>
Subject: block devices loosing state after resume: trigger udev rules to
 re-apply settings
Date: Sat, 28 Feb 2015 09:30:23 +0100
Message-ID: <20150228093023.14e30d9a@smtp.arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 779412@bugs.debian.org
Cc: 725284@bugs.debian.org, linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net
List-Id: linux-raid.ids

(http://bugs.debian.org/779412 explanation)

There is a general problem with non-permanent block devices settings
(hard disks, optical disks, usb storage, ...), that are not restored 
when resuming from suspend (instead using factory defaults and 
loosing all pre-suspend settings).

And as long as the ata/scsi command set drivers can not save and
restore every state register a device may have (impossible?),
systemd may ship a viable workaround for this:

A systemd unit file could trigger an udev change action upon resume for
block devices. This way the same udev rules that set up the devices when
they are first plugged, will re-apply their settings after resume.

Providing this centrally with the systemd package could avoid that 
multiple packages ship their own files, resulting in multiple change 
events triggerd on each resume.

Examples for very important (non-permanent) settings are with
hdparm (i.e. the important -B hard disk wear settings)
https://bugs.debian.org/725284
smartctl/mdadm/lvm/btrfs/zfs/... (i.e. set error recovery timeouts to
prevent controller resets and data loss)
http://sourceforge.net/p/smartmontools/mailman/message/33501936/




A draft for such a central systemd unit file:

[Unit]
Description=Trigger all block device udev rules on resume, to re-apply all non-permanent device settings (e.g. smartctl and hdparm rules).
After=suspend.target After=hibernate.target
After=hybrid-sleep.target

[Service]
Type=oneshot
ExecStart=/sbin/udevadm trigger --action=change --subsystem-match=block

[Install]
WantedBy=suspend.target
WantedBy=hibernate.target
WantedBy=hybrid-sleep.target

