From: Gionatan Danti <g.danti@assyoma.it>
Subject: Filesystem corruption on RAID1
Date: Thu, 13 Jul 2017 17:35:12 +0200
Message-ID: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: g.danti@assyoma.it
List-Id: linux-raid.ids

Hi list,
today I had an unexpected filesystem corruption on a RAID1 machine used 
for backup purposes. I would like to reconstruct what possibly happened 
on why, so I am asking for your help.

System specs:
- OS CentOS 7.2 x86_64 with kernel 3.10.0-514.6.1.el7.x86_64
- 2x SEAGATE ST4000VN000-1H4168 (4 TB 5900rpm disks)
- 4 GB DDR3 RAM
- Intel(R) Pentium(R) CPU G3260 @ 3.30GHz

Today, I found the machine crashed with an XFS warning about corrupted 
metadata. The warning stated that in-core (or in-memory) data corruption 
was detected so, thinking about a DRAM-related problem (no ECC memory on 
this small box...) I simply rebooted tha machine. To no avail - the same 
problem immediately happened, preventing the machine from booting (the 
root filesystem did not mount).

After the filesystem was repaired (with significant corruption signs, 
also due to the clearing of the XFS journal), I looked at dmesg and 
found something interesting: a raid-resync action was *automatically* 
performed, as when re-attaching a (detached) disk.

I start investigating in /var/log/messages and found plenty of these 
errors, spanning many days:

...
Jul 10 03:24:01 nas kernel: ata1.00: failed command: READ FPDMA QUEUED
Jul 10 14:50:54 nas kernel: ata1.00: failed command: FLUSH CACHE EXT
Jul 12 03:14:41 nas kernel: ata1.00: failed command: WRITE FPDMA QUEUED
...

To me, it seems that a disks (the first one, sda) had problem executing 
some SATA commands, becoming out-of-sync from the second one (sdb). 
However it was not kicked out the array, as both /var/log/messages *and* 
my custom monitoring script (which keep an eye on /proc/mdstat) reported 
nothing. Moreover, inspecting both the SMART values and log show *no* 
error at all.

Question 1: it is possible to have such a situation, where a failed 
command *silently* put the array in out-of-sync state?

At a certain point, the machine crashed. I noticed and rebooted it.

Question 2: it is possible that the old disk become offline just before 
the crash and, by rebooting, the mdadm re-added it to the array?

Question 3: if so, it is possible that the corruption was due to the 
first disk being the one read by the md array and, by extension, by the 
filesystem?

Any thoughts will be greatly appreciated.
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
