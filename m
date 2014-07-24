From: Kay Sievers <kay@vrfy.org>
Subject: Re: udev 215 creates inactive MD devices upon
	stopping them
Date: Thu, 24 Jul 2014 23:53:30 +0200
Message-ID: <CAPXgP11XeMFHiWryu1kgYC9__w1YUsMsrx=F8+sg1M_tro8n4g@mail.gmail.com>
References: <53D11CCA.1050602@profitbricks.com>
 <53D12AB5.5090102@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <systemd-devel-bounces@lists.freedesktop.org>
In-Reply-To: <53D12AB5.5090102@profitbricks.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/systemd-devel>,
 <mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
 <mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: systemd-devel-bounces@lists.freedesktop.org
Sender: "systemd-devel" <systemd-devel-bounces@lists.freedesktop.org>
To: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, artur.paszkiewicz@intel.com, systemd-devel@freedesktop.org, Francis Moreau <francis.moro@gmail.com>
List-Id: linux-raid.ids

On Thu, Jul 24, 2014 at 5:48 PM, Sebastian Parschauer
<sebastian.riemer@profitbricks.com> wrote:

> as discussed on linux-raid, please fix the bug that udev 215 creates
> inactive MD devices upon stopping them.
>
> Reference: http://www.spinics.net/lists/raid/msg46676.html
> Reported-by: Francis Moreau <francis.moro@gmail.com>
>
> An open() call to /dev/mdX after creating it with mknod is enough to
> create such inactive MD device.
>
> According to Artur the issue is caused by this change in udev:
>
>> commit 3ebdb81ef088afd3b4c72b516beb5610f8c93a0d
>> Author: Kay Sievers <kay at vrfy.org>
>> Date:   Sun Apr 13 19:54:27 2014 -0700
>>
>>      udev: serialize/synchronize block device event handling with file locks
>>
>> http://cgit.freedesktop.org/systemd/systemd/commit/?id=3ebdb81ef088afd3b4c72b516beb5610f8c93a0d
>>
>> It seems that they have already disabled this for dm for some reason,
>> but not for md:
>>
>> commit e918a1b5a94f270186dca59156354acd2a596494
>> Author: Kay Sievers <kay@vrfy.org>
>> Date:   Tue Jun 3 16:49:38 2014 +0200
>>
>>     udev: exclude device-mapper from block device ownership event locking
>>
>> http://cgit.freedesktop.org/systemd/systemd/commit/?id=e918a1b5a94f270186dca59156354acd2a596494

MD devices are excluded now from the locking logic, like dm devices already are.

Instantiation of devices at open() is incompatible with udev's locking
logic. That feature is not useful on most systems today, mknod()
should never be done by any tools, only by the kernel itself. It
should probably be disabled by default.

(The locking scheme is used to support partitioning programs, to make
sure udev will not interfere with the partitioning tool while it
creates/removes partitions. As long as an exclusive lock is held on
the disk device node, all udev events are suppressed, the close() of
the disk which war opened for writing will re-read the partition table
and synthesize all suppressed udev events for the partitions again.)

Thanks,
Kay
