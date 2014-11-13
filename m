From: Anton Ekermans <antone@true.co.za>
Subject: Re: md with shared disks
Date: Thu, 13 Nov 2014 15:14:16 +0200
Message-ID: <5464AEA8.3010106@true.co.za>
References: <545F2630.8090307@true.co.za> <546138B5.7020101@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <546138B5.7020101@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you very much for your clear response.
The purpose of this hardware is to primarily host ample VM storage for 
the 2 nodes itself and 3 other i7 PC/servers.
The HA was hoped to be achieved as active/active with both nodes sharing 
the same disks and non-cluster servers(i7) having multi-path to these 
two nodes. This is advertised as HA active/active in storage software 
such as Nexenta using RSF-1. However upon closer inspection, their 
active/active means both nodes share some data and the other can take 
over. So for me, in essence it is "active/passive + passive/active" and 
not truly "active/active". We will try to config this way to get quasi 
active/active for best performance with kind-of high-availability. Seems 
the shared disks is not the problem, but combining them on a cluster is.

Thank you again

Best regards
Untitled Document

Anton Ekermans

> It's not possible to do what you mention as md is not cluster aware.  It
> will break, badly.  What most people do in such cases in create two md
> arrays, one controlled by each host, and mirror them with DRBD, then put
> OCFS/GFS atop DRBD.  You lose half your capacity doing this, but it's
> the only way to do it and have all disks active.  Of course you lose
> half your bandwidth as well.  This is a high availability solution, not
> high performance.
>
> You bought this hardware to do something.  And that something wasn't
> simply making two hosts in one box use all the disks in the box.  What
> is the workload you plan to run on this hardware?  The workload dictates
> the needed hardware architecture, not the other way around.  If you want
> high availability this hardware will work using the stack architecture
> above, and work well.  If you need high performance shared filesystem
> access between both nodes you need an external SAS/FC RAID array and a
> cluster FS.  In either case you're using a cluster FS which means high
> file throughput but low metadata throughgput.
>
> If it's high performance you need, an option is to submit patches to
> make md cluster aware.  Another is the LSI clustering RAID controller
> kit for internal drives.  Don't know anything about it other than it is
> available and apparently works with RHEL and SUSE.  Seems suitable for
> what you express as your need.
>
> http://www.lsi.com/products/shared-das/pages/syncro-cs-9271-8i.aspx#tab/tab2
>
>
> Cheers,
> Stan

