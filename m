From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Wed, 01 Apr 2015 20:57:30 +0100
Message-ID: <551C4DAA.4010701@youngman.org.uk>
References: <20150330222459.GA575371@devbig257.prn2.facebook.com> <CAPcyv4jqb+OphP-1sy0dqMYG-uNK-CwtNDmOM4YeQU=MXH72Hw@mail.gmail.com> <20150401183630.GA3103@lazy.lzy> <CAB-428nVCN=5au0jONamXORNZ656UZ1Ecgrk-paArruX9tpHJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB-428nVCN=5au0jONamXORNZ656UZ1Ecgrk-paArruX9tpHJQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, Song Liu <songliubraving@fb.com>, Kernel-team@fb.com
List-Id: linux-raid.ids

On 01/04/15 19:46, Alireza Haghdoost wrote:
>> Now, how can be assured, in that case, that the "cache"
>> > device is safe after the power is restored?
> You do sync write-ahead logging on the Flash cache. If it return
> successful, you do fire the writes to the RAID. If system crash/fails
> during the RAID writes (Write-hole), you just recover data by scanning
> write-ahead log in the flash cache and replay the logs into the RAID
> drives.
> 
Just to throw something nasty into the mix, I'm not sure whether it's
SSDs or SD-cards, but there certainly *was* a spate of corrupted
*controllers*.

In other words, a power failure would RELIABLY TRASH the device, if it
happened at the wrong moment. Hopefully that's been fixed ...

Cheers.
Wol
