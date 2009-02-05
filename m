From: Nicolas Brisac <nico@sol1.com.au>
Subject: Specify device to use as primary on Raid1 array re-sync
Date: Thu, 5 Feb 2009 17:42:35 +1100 (EST)
Message-ID: <2088961572.1121233816155917.JavaMail.root@subscribe>
References: <1832653339.1101233816115791.JavaMail.root@subscribe>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1832653339.1101233816115791.JavaMail.root@subscribe>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone,

we have several servers running OpenVZ virtual machines.
We are trying to put in place a system that allows us to "migrate" virtual machines from one host to another quickly and easily, to perform maintenance on a host for example.

To achieve this, we decided to export an LVM slice over ISCSI from one host and raid it (Raid1) with a local LVM slice on the host that is running the virtual machine (each VM has its own LVM slice).
We are using an internal bitmap in the Raid1 arrays to speed the re-sync up.
This works fine and we are able to:

  - stop the VM on the primary host
  - stop the array on the primary host and logout the ISCSI target
  - assemble a degraded array on the failover host with the LVM slice that was exported over ISCSI
  - start the VM on the failover host without any data loss

we are using a degraded array on the failover host rather than mounting the LVM slice directly, so that the bitmap gets updated.

The problem occurs when doing the opposite steps:
If we assemble a degraded array on the primary host with the ISCSI target only, we can see the latest data fine.
But as soon as we re-add the local LVM slice to the array, the data that are used are those from before the fail-over (from the local LVM slice).

I would have assumed that, as the bitmap on the remote (ISCSI) LVM slice had been updated and was the more recent, it would be used as the "primary" device in the re-sync process.

The only way we have found so far to access the latest data is to zero-out the local LVM slice superblock or remove its bitmap.
Both solutions have the same result: a complete re-sync.
However, some of the VM are more than 100G big and therefore the re-sync takes way too long.

Even marking the local device as failed before stopping the array on the primary host, and re-adding it when assembling the array doesn't seem to solve the problem.

Is there any way to specify to mdadm which device to use as the "primary" when doing he re-sync?
Or maybe a way to mark a raid member as out-of-date so that it's data get overwritten by the other member's data, but using the bitmap to make the re-sync faster?

Let me know if you need more details.
Any other suggestion is welcome of course.

Thanks,

Nicolas Brisac
