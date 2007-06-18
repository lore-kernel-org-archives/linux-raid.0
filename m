From: Tejun Heo <htejun@gmail.com>
Subject: Re: Machine hanging on synchronize cache on shutdown 2.6.22-rc4-git[45678]
Date: Mon, 18 Jun 2007 16:09:49 +0900
Message-ID: <46762FBD.20209@gmail.com>
References: <200706161909.l5GJ9Q9P021615@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200706161909.l5GJ9Q9P021615@harpo.it.uu.se>
Sender: linux-ide-owner@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: brad@wasp.net.au, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Mikael Pettersson wrote:
> On Sat, 16 Jun 2007 15:52:33 +0400, Brad Campbell wrote:
>> I've got a box here based on current Debian Stable.
>> It's got 15 Maxtor SATA drives in it on 4 Promise TX4 controllers.
>>
>> Using kernel 2.6.21.x it shuts down, but of course with a huge "clack" as 15 drives all do emergency 
>> head parks simultaneously. I thought I'd upgrade to 2.6.22-rc to get around this but the machine 
>> just hangs up hard apparently trying to sync cache on a drive.
>>
>> I've run this process manually, so I know it is being performed properly.
>>
>> Prior to shutdown, all nfsd processes are stopped, filesystems unmounted and md arrays stopped.
>> /proc/mdstat shows
>> root@storage1:~# cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> unused devices: <none>
>> root@storage1:~#
>>
>> Here is the final hangup.
>>
>> http://www.fnarfbargle.com/CIMG1029.JPG
> 
> Something sent a command to the disk on ata15 after the PHY had been
> offlined and the interface had been put in SLUMBER state (SStatus 614).
> Consequently the command timed out. Libata tried a soft reset, and then
> a hard reset, after which the machine hung.

Hmm... weird.  Maybe device initiated power saving (DIPS) is active?

> I don't think sata_promise is the guilty party here. Looks like some
> layer above sata_promise got confused about the state of the interface.

But locking up hard after hardreset is a problem of sata_promise, no?

Thanks.

-- 
tejun
