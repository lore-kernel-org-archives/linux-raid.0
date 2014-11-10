From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: md with shared disks
Date: Mon, 10 Nov 2014 16:14:13 -0600
Message-ID: <546138B5.7020101@hardwarefreak.com>
References: <545F2630.8090307@true.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <545F2630.8090307@true.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: Anton Ekermans <antone@true.co.za>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/09/2014 02:30 AM, Anton Ekermans wrote:
> Good day raiders,
> I have a question on md that I cannot find (up to date) answer to.
> We use SuperMicro server with 16 shared disks on a shared backplane
> between two motherboards, running up to date CentOS7.
> If I create an array on one node, the other node can detect it. I put
> GFS2 on top of the array so both system can share the filesystem, but I
> want to know if md raid is safe to be used in this way with possibly 2
> active/active nodes changing the metadata at the same time. I've
> disabled raid-check cron job on one node so they don't both resync the
> drives weekly, but I suspect there's a lot more to it than that.
> 
> If it's not possible, then alternatively some advice on strategy to have
> a large active/active shared disk/filesystem would also be welcome.

It's not possible to do what you mention as md is not cluster aware.  It
will break, badly.  What most people do in such cases in create two md
arrays, one controlled by each host, and mirror them with DRBD, then put
OCFS/GFS atop DRBD.  You lose half your capacity doing this, but it's
the only way to do it and have all disks active.  Of course you lose
half your bandwidth as well.  This is a high availability solution, not
high performance.

You bought this hardware to do something.  And that something wasn't
simply making two hosts in one box use all the disks in the box.  What
is the workload you plan to run on this hardware?  The workload dictates
the needed hardware architecture, not the other way around.  If you want
high availability this hardware will work using the stack architecture
above, and work well.  If you need high performance shared filesystem
access between both nodes you need an external SAS/FC RAID array and a
cluster FS.  In either case you're using a cluster FS which means high
file throughput but low metadata throughgput.

If it's high performance you need, an option is to submit patches to
make md cluster aware.  Another is the LSI clustering RAID controller
kit for internal drives.  Don't know anything about it other than it is
available and apparently works with RHEL and SUSE.  Seems suitable for
what you express as your need.

http://www.lsi.com/products/shared-das/pages/syncro-cs-9271-8i.aspx#tab/tab2


Cheers,
Stan
