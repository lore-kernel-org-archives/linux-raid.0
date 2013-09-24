From: Phil Turmel <philip@turmel.org>
Subject: Re: [Recovery] RAID10 hdd failureS help requested
Date: Tue, 24 Sep 2013 11:50:15 -0400
Message-ID: <5241B4B7.1010305@turmel.org>
References: <CAB4fJqfd1zrw_AS89ufysfyCoKNf6VYj81xov0=7y0aXoYtjxw@mail.gmail.com> <5241A06F.10704@turmel.org> <CAB4fJqezb0sWcUUgRPd4BXoWr3hNBp725gv8xnMOPmcqU8RiRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB4fJqezb0sWcUUgRPd4BXoWr3hNBp725gv8xnMOPmcqU8RiRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Karel Walters <karel.walters@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Karel,

Please use reply-to-all on kernel.org lists, trim replies, and avoid
top-posting.

On 09/24/2013 11:07 AM, Karel Walters wrote:
> Dear Phil,
> 
> Thank you for the quick response!
> Unfortunately that does not work.
> The drives did fail their SMART test, one short and one long.
> That is how I judged they are indeed broken.
> 
> Thanks already!
> 
> Indeed these are consumer Seagate 7200RPM drives.
> 
> /sys/block/sda/device/timeout : 30
> /sys/block/sdb/device/timeout : 30
> /sys/block/sdc/device/timeout : 30
> /sys/block/sdd/device/timeout : 30
> /sys/block/sde/device/timeout : 30
> /sys/block/sdf/device/timeout : 30
> /sys/block/sdg/device/timeout : 30
> /sys/block/sdh/device/timeout : 30
> /sys/block/sdi/device/timeout : 30
> /sys/block/sdj/device/timeout : 30
> /sys/block/sdk/device/timeout : 30
> /sys/block/sdl/device/timeout : 30
> /sys/block/sdm/device/timeout : 30
> /sys/block/sdn/device/timeout : 30

Allow me to select critical info from these smartctl reports:

> /dev/sdc
> Device Model:     WDC WD30EFRX-68AX9N0
> Serial Number:    WD-WCC1T1255024
> SMART overall-health self-assessment test result: PASSED
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
> 197 Current_Pending_Sector  -O--CK   200   200   000    -    0
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)

/dev/sdc is healthy and has appropriate timeouts.

> /dev/sdd
> Device Model:     ST3000DM001-9YN166
> Serial Number:    W1F09XLV
> SMART overall-health self-assessment test result: PASSED
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    8
> 197 Current_Pending_Sector  -O--C-   096   096   000    -    656
> 198 Offline_Uncorrectable   ----C-   096   096   000    -    656
> Warning: device does not support SCT Data Table command
> Warning: device does not support SCT Error Recovery Control command

/dev/sdd is technically healthy, but approaching failure, and has been
neglected.  It has many pending sectors.  You clearly have not been
scrubbing your array, and if you had, it would have been bumped out of
your array long ago for timeout mismatch.

> /dev/sde
> Device Model:     ST3000DM001-9YN166
> Serial Number:    W1F0AXTQ
> SMART overall-health self-assessment test result: PASSED
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    144
> 198 Offline_Uncorrectable   ----C-   100   100   000    -    144
> Warning: device does not support SCT Data Table command
> Warning: device does not support SCT Error Recovery Control command

/dev/sde is technically healthy, and probably healthy in fact.  But like
/dev/sdd, it has many pending sectors due to lack of scrubbing.  And if
you had been scrubbing, the timeout mismatch would have kicked it out
anyways.

> /dev/sdf
> Device Model:     ST3000DM001-9YN166
> Serial Number:    W1F0B6X6
> SMART overall-health self-assessment test result: PASSED
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
> Warning: device does not support SCT Data Table command
> Warning: device does not support SCT Error Recovery Control command

/dev/sdf is healthy.  But it has the timeout mismatch problem.

> /dev/sdg
> Device Model:     ST3000DM001-9YN166
> Serial Number:    S1F04BZT
> SMART overall-health self-assessment test result: PASSED
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
> Warning: device does not support SCT Data Table command
> Warning: device does not support SCT Error Recovery Control command

/dev/sdg is healthy.  But it has the timeout mismatch problem.

> /dev/sdh
> Device Model:     ST3000DM001-9YN166
> Serial Number:    W1F0B9ER
> SMART overall-health self-assessment test result: PASSED
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
> Warning: device does not support SCT Data Table command
> Warning: device does not support SCT Error Recovery Control command

/dev/sdh is healthy.  But it has the timeout mismatch problem.

> /dev/sdi
> Device Model:     WDC WD30EFRX-68AX9N0
> Serial Number:    WD-WMC1T2341606
> SMART overall-health self-assessment test result: PASSED
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
> 197 Current_Pending_Sector  -O--CK   200   200   000    -    0
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)

/dev/sdi is healthy and has appropriate timeouts.


Before you do anything else, you have to compensate for the drives that
don't support error recovery control:

for x in /sys/block/sd[d-h]/device/timeout ; do echo 180 >$x ; done

You must do this for all of your Seagate drives on every powerup or your
arrays will always kick drives out instead of fixing the accumulating
pending errors.  (Pending errors are repaired or relocated by writing to
them.  MD will do this automatically on read errors, but cannot do so if
the drive won't respond in 30 seconds.)

{ In the future, buy drives that wake up with ERC enabled (like your WD
Reds), or at least capable of enabling ERC (at every powerup). }

Next, you will have to figure out which of the bumped drives belongs in
which slot in the array.  An old dmesg (from before the failures) or an
archived "mdadm --detail" would tell us that.  This is important,
because you *will* need to use --create --assume-clean as the drives are
now marked as spare--the info needed for forced assembly is gone.

You will also need to make sure that the create operation results in the
correct data offset on each device before accessing the array.

Phil
