From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID creation resync behaviors
Date: Wed, 3 May 2017 23:06:01 +0200
Message-ID: <fe3c30e4-b0dd-639e-7db7-344aa93ce198@hesbynett.no>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170503202748.7r243wj5h4polt6y@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

On 03/05/17 22:27, Shaohua Li wrote:
> Hi,
>
> Currently we have different resync behaviors in array creation.
>
> - raid1: copy data from disk 0 to disk 1 (overwrite)
> - raid10: read both disks, compare and write if there is difference (compare-write)
> - raid4/5: read first n-1 disks, calculate parity and then write parity to the last disk (overwrite)
> - raid6: read all disks, calculate parity and compare, and write if there is difference (compare-write)
>
> Write whole disk is very unfriendly for SSD, because it reduces lifetime. And
> if user already does a trim before creation, the unncessary write could make
> SSD slower in the future. Could we prefer compare-write to overwrite if mdadm
> detects the disks are SSD? Surely sometimes compare-write is slower than
> overwrite, so maybe add new option in mdadm. An option to let mdadm trim SSD
> before creation sounds reasonable too.
>

When doing the first sync, md tracks how far its sync has got, keeping a 
record in the metadata in case it has to be restarted (such as due to a 
reboot while syncing).  Why not simply /not/ sync stripes until you 
first write to them?  It may be that a counter of synced stripes is not 
enough, and you need a bitmap (like the write intent bitmap), but it 
would reduce the creation sync time to 0 and avoid any writes at all.

David


