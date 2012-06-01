From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Thu, 31 May 2012 20:31:49 -0500
Message-ID: <4FC81B85.8090807@hardwarefreak.com>
References: <20120531083158.GE3867@bitfolk.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120531083158.GE3867@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/31/2012 3:31 AM, Andy Smith wrote:

> Now, is this sort of behaviour expected when under incredible load?
> Or is it indicative of a bug somewhere in kernel, mpt driver, or
> even flaky SAS controller/disks?

It is expected that people know what RAID is and how it is supposed to
be used.  RAID is to be used for protecting data in the event of a disk
failure and secondarily to increase performance.  That is not how you
seem to be using RAID.  BTW, I can't fully discern from your log
snippets...are you running md RAID inside of virtual machines or only on
the host hypervisor?  If the former problems like this are expected and
normal, which is why it is recommended to NEVER run md RAID inside a VM.

> Controller: LSISAS1068E B3, FwRev=011a0000h
> Motherboard: Supermicro X7DCL-3
> Disks: 4x SEAGATE  ST9300603SS      Version: 0006
> 
> While I'm familiar with the occasional big DDoS causing extreme CPU
> load, hung tasks, CPU soft lockups etc., I've never had it kick
> disks before. 

The md RAID driver didn't kick disks.  It kicked partitions, as this is
what you built your many arrays with.

> But I only have this one server with SAS and mdadm
> whereas all the others are SATA and 3ware with BBU.

Fancy that.

> Root cause of failure aside, could I have made recovery easier? Was
> there a better way than --create --assume-clean?
> 
> If I had done a --create with sdc5 (the device that stayed in the
> array) and the other device with the closest event count, plus two
> "missing", could I have expected less corruption when on 'repair'?

You could probably expect it to be more reliable if you used RAID as
it's meant to be used, which in this case would be a single RAID10 array
using none, or only one partition per disk, instead of creating 4 or 5
different md RAID arrays from 4-5 partitions on each disk.  This is
simply silly, and it's dangerous if doing so inside VMs.

md RAID is not meant to be used as a thin provisioning tool, which is
what you seem to have attempted here, and is almost certainly the root
cause of your problem.

I highly recommend creating a single md RAID array and using proper thin
provisioning tools/methods.  Or slap a real RAID card into this host as
you have the others.  The LSI (3ware) cards allow the creation of
multiple virtual drives per array, each being exposed as a different
SCSI LUN in Linux, which provides simple and effective thin
provisioning.  This is much simpler and more reliable than doing it all
with kernel drivers, daemons, and filesystem tricks (sparse files
mounted as filesystems and the like).

There are a number of scenarios where md RAID is better than hardware
RAID and vice versa.  Yours is a case where hardware RAID is superior,
as no matter the host CPU load, drives won't get kicked offline as a
result, as they're under the control of a dedicated IO processor (same
for SAN RAID).

-- 
Stan
