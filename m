From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Something is broken with SATA RAID ?
Date: Thu, 03 Mar 2005 09:03:42 +0400
Message-ID: <42269AAE.7080106@wasp.net.au>
References: <1109810381l.5754l.0l@werewolf.able.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <1109810381l.5754l.0l@werewolf.able.es>
Sender: linux-kernel-owner@vger.kernel.org
To: "J.A. Magallon" <jamagallon@able.es>
Cc: Lista Linux-Kernel <linux-kernel@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

J.A. Magallon wrote:
> Hi...
> 
> I posted this in other mail, but now I can confirm this.
> 
> I have a box with a SATA RAID-5, and with 2.6.11-rc3-mm2+libata-dev1
> works like a charm as a samba server, I dropped it 12Gb from an
> osx client, and people does backups from W2k boxes and everything was fine.
> With 2.6.11-rc4-mm1, it hangs shortly after the mac starts copying
> files. No oops, no messages... It even hanged on a local copy (wget),
> so I will discard samba as the buggy piece in the puzzle.
> 
> I'm going to make a definitive test with rc5-mm1 vs rc5-mm1+libata-dev1.
> I already know that plain rc5-mm1 hangs. I have to wait the md reconstruction
> of the 1.2 TB to check rc5-mm1+libata (and no user putting things there...)
> 
> But, anyone has a clue about what is happening ? I have seen other
> reports of RAID related hangs... Any important change after rc3 ?
> Any important bugfix in libata-dev1 ? Something broken in -mm ?

There was (is) a bug in -rc4-mm1 that may still be there in -rc5-mm1 related to the way RAID-5 and 
RAID-6 writes out blocks that can cause a deadlock in the raid code. Do you processes just hang in 
the D state and any access to /proc/mdstat do the same thing?

Can you try with just 2.6.11+libata+libata-dev?

I moved to 2.6.11+libata+libata-dev+netdev and all my problems went away.

CC'd to linux-raid

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
