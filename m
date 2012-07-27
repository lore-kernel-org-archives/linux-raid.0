From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID10 Performance
Date: Fri, 27 Jul 2012 02:07:24 -0500
Message-ID: <50123E2C.8090108@hardwarefreak.com>
References: <50115123.1020900@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50115123.1020900@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/26/2012 9:16 AM, Adam Goryachev wrote:

> I've got a system with the following config that I am trying to improve
> performance on. Hopefully you can help guide me in the best direction
> please.

> 3 x 2TB WDC WD2003FYYS-02W0B1
...
> The three HDD's are configured in a single RAID10
...
> Which is then shared with DRBD to another identical system.
> Then LVM is used to carve the redundant storage into virtual disks
> Finally, iSCSI is used to export the virtual disks to the various
> virtual machines running on other physical boxes.
> 
> When a single VM is accessing data, performance is more than acceptable
> (max around 110M/s as reported by dd)
> 
> The two SAN machines have 1 Gb ethernet crossover between them, and 4 x
> Gb bonded to the switch which connects to the physical machines running
> the VM's (which have only a single Gb connection).
> 
> The issue is poor performance when more than one machine attempts to do
> disk intensive activity at the same time (ie, when the anti virus scan
> starts on all VM's at the same time, or during the backup window, etc).
...

I'm really surprised you don't already know the answer, and that you
gave such a lengthy detailed description.

Your problem is very simple.  It is suffered by many people, who lack
basic understanding of rotating drive performance in relation to their
workloads.

You don't have enough seek bandwidth.  The drive heads simply can't move
fast enough to service all sector requests in a timely manner.  There is
no way to fix this by tweaking the operating system.  You need to
increase your seek rate.

1.  Recreate the arrays with 6 or 8 drives each, use a 64KB chunk
2.  Replace the 7.2k WD drives with 10k SATA, or 15k SAS drives
3.  Replace the drives with SSDs

Any of these 3 things will decrease latency per request.

-- 
Stan

