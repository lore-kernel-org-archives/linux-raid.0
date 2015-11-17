From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: WD Red vs Black drives for RAID1
Date: Tue, 17 Nov 2015 13:04:52 +0800
Message-ID: <564AB574.3010405@fnarfbargle.com>
References: <22090.1097.258820.65463@quad.stoffel.home> <20151116182731.Horde.4rj0hKH2I4Q0KSxmbRtF3Es@www3.nde.ag> <22090.4914.784452.360948@quad.stoffel.home> <20151116184407.Horde.3ODJYoTBtNA8WapjnAfIhkr@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151116184407.Horde.3ODJYoTBtNA8WapjnAfIhkr@www3.nde.ag>
Sender: linux-raid-owner@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>, John Stoffel <john@stoffel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/11/15 01:44, Jens-U. Mozdzen wrote:
> Hi John,
>
> Zitat von John Stoffel <john@stoffel.org>:

>> Jens-U> How are the drives to be attached to the server?
>>
>> I'm planning on just hooking them into the:
>>
>>   Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2008
>>   PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)
>
> according to WD support, hooking the Reds to the SAS adapter directly
> should be no problem. It's said to be the extender to cause the trouble.

I have 5 reds and 9 greens (all with TLER) connected to some of those 
controllers (except mine are rev 02). I have those drives in a 14 way 
RAID6, and I get some odd (non-terminal) errors on my monthly scrubs but 
nothing in normal use.

I think *my* problem is cheap cables to the backplane, but as it only 
occurs once a month during a scrub and a retry always succeeds I've not 
been bothered to do anything about it.

Errors like this :
[3385803.162623] sd 9:0:5:0: [sdr] UNKNOWN(0x2003) Result: hostbyte=0x00 
driverbyte=0x08
[3385803.193353] sd 9:0:5:0: [sdr] Sense Key : 0x3 [current]
[3385803.224289] sd 9:0:5:0: [sdr] ASC=0x11 ASCQ=0x0
[3385803.255393] sd 9:0:5:0: [sdr] CDB: opcode=0x28 28 00 24 84 65 00 00 
00 80 00
[3385803.287287] blk_update_request: critical medium error, dev sdr, 
sector 612656384

I have an array of SAS drives on one controller and I don't see those 
issues. It only happens on the SATA drives.

When setting up this system a few years ago I did borrow a SAS expander 
to play with, bit I encountered some odd issues with the SATA drives (WD 
Green) on the expander and ended up going with 3 controllers instead.

I've just been replacing the Greens with Reds when they start to fail. 
All in all I'm really happy with the Reds, and my next major hardware 
refresh will see the 14 current drives replaced with 6 6TB Reds.

The performance difference between the 5400 drives and the 7200 drives 
in an array turns out to be bugger all, plus the slower drives run 
cooler and use less power. I'd still be using Greens if they hadn't 
removed TLER.

