From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Nested RAID and booting
Date: Tue, 21 Jun 2011 10:28:17 -0400
Message-ID: <4E00AA81.2030100@cfl.rr.com>
References: <D1.7A.00666.3AE0FED4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D1.7A.00666.3AE0FED4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

These days most ( all? ) distributions use udev for plug and play.  When 
the physical disks are detected, udev notices ( with blkid ) that they 
are raid members, and runs mdadm --incremental on them.  Once they are 
all detected, the array goes active, and udev runs blkid on the array, 
notices that is a component, and runs mdadm --incremental on that.

On 6/8/2011 1:54 AM, Leslie Rhorer wrote:
>
> 	For financial reasons, I have had to temporarily create two members
> of a RAID6 array by first creating a pair of RAID0 arrays from four member
> disks.  The RAID6 array is currently re-shaping, and so far all seems well.
> I do have a concern about what will happen when the system reboots, however.
> In order to properly assemble the RAID6 array, the two RAID0 arrays will
> first need to be assembled and running, correct?  How do I guarantee the two
> RAID0 arrays will be up before mdadm attempts to assemble the RAID6 array?
> Will simply putting them in the mdadm.conf file prior to the RAID6 array do
> the trick?

