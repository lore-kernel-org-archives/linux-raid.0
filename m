From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Sun, 25 Sep 2011 12:19:31 -0400
Message-ID: <4E7F5493.5050402@turmel.org>
References: <4E7EDE58.3000804@yazzy.org> <4E7F297C.9070403@turmel.org> <4E7F3D7C.3060705@yazzy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7F3D7C.3060705@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/25/2011 10:41 AM, Marcin M. Jessa wrote:
> On 9/25/11 3:15 PM, Phil Turmel wrote:
> 
> 
>> I'm sorry, Marcin, but you shouldn't expect to get your data back.  Per your "mdadm -D" report, the rebuild was already 63% done, so the destruction of your data is certainly complete now.
> 
> What I don't understand is I still have the LVM info. It's just the LVs don't have partition table stored anymore:

You probably got the device order partially correct, which would put some of your data blocks in the correct location.  Having the LVM metadata line up is not terribly surprising.  When some drives are placed back into the correct slots, but not others, only the non-parity data on the correctly placed drives will be correct.  The rebuild will destroy the parity data on those devices, and much of the data on the other devices.  Your partition tables were probably among the latter.

If chunk size, data offset, or layout were also incorrect, then even fewer good data blocks will show up by chance in the correct location.

Without the original mdadm -E reports (complete), there's no way I know of to figure out what happened, much less repair it.

Phil
