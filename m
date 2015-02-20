From: email.bug@arcor.de
Subject: rules and scripts (erc timeout fix)
Date: Fri, 20 Feb 2015 17:54:42 +0100 (CET)
Message-ID: <1964706709.59890.1424451282393.JavaMail.ngmail@webmail11.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello all,

enjoy, I tested the scripts set timeouts ok here, but I only have
drives that support erc timeouts (even if some have it disabled by default) none that
would really require setting a long controller timeout.

Cheers,
Chris




smartctl-timeouts README

The smartctl-timeouts scripts adjust the disk timeouts according to use-cases,
fixing common mismatching defaults that have often lead to data loss.

The scripts are to be called by udev rules during device initialization.
Every redundancy providing block device module may ship with proper udev rules
that initialize the timeouts for their possibly redundant devices.
The module may further adjust the actual status according to run-time changes.


NOTE: Correct execution during boot requires that distro package managers
      hook smartctl and the smartctl-timeouts scripts into the initramfs.



RATIONALE

The error recovery (ERC) timout *must* be shorter than the controller timeout.

Otherwise read errors will cause controller resets, leading to direct data loss
or, if it is a redundant disk, loss of redundancy and a very high probability
of another read error and data loss when re-establishing the redundancy.

If a drive does not support adjusting its ERC timout, the controller timeout
must be increased above the drive's 'maximal error recovery time.
If you don't want that kind of long device timeout, you should look for a drive
with SCT ERC timout support. (smartctl -l scterc /dev/...)


IMPACT

If possible, the ERC timeout is adjusted to the controller timeout minus 5 seconds,
for all disks that contain possibly redundant data.

The controller timeout is only changed (raising it to LONG_CTRL_WAIT_SECONDS)
for drives without SCTERC support and entirely non-redundant-disks, to allow these
drives to properly finish their error recovery before a reset is triggerd.

Because controller timeouts are only increased selectively (only drives without SCTERC
support and surely non-redundant disks), the scripts won't change any timeouts in
professional, dedicated, redundant setups (e.g. storage servers etc.), except if
LONG_WAIT_ALL_NONREDUND_DISKS is configured to be true.


TODO

* non-redundant-partitions: conditional udev triggering, or a test in the script could
  determine if all partions of the disk have been detected already and are all
  non-redundant, to call non-redundant-disk in this case.

* parser to read ERC timout values?
    - redundant-disk: a previously set "controller timeout - 5 seconds" ERC timeout
      (possibly-redundant), could also be reset to 7 seconds, not just a "Disabled" value.

* If a redundancy controlling kernel module is to make dynamic adjustments,
  "redundant-partition" needs implementation.


