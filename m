From: David Brown <david@westcontrol.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Mon, 13 Feb 2012 09:54:13 +0100
Message-ID: <4F38CFB5.3090102@westcontrol.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/02/2012 21:16, CoolCold wrote:
> First of all, Stan, thanks for such detailed answer, I greatly appreciate this!
>
> On Sat, Feb 11, 2012 at 8:05 AM, Stan Hoeppner<stan@hardwarefreak.com>  wrote:
>> On 2/10/2012 9:17 AM, CoolCold wrote:
>>> I've got server with 7 SATA drives ( Hetzner's XS13 to be precise )
>>> and created mdadm's raid10 with two near copies, then put LVM on it.
>>> Now I'm planning to create xfs filesystem, but a bit confused about
>>> stripe width/stripe unit values.
>>
>> Why use LVM at all?  Snapshots?  The XS13 has no option for more drives
>> so it can't be for expansion flexibility.  If you don't 'need' LVM don't
>> use it.  It unnecessarily complicates your setup and can degrade
>> performance.
> There are several reasons for this - 1) I've made decision to use LMV
> for all "data" volumes (those are except /, /boot, /home , etc)  2)
> there will be mysql database which will need backups with snapshots 3)
> I often have several ( 0-3 ) virtual environments (OpenVZ based) which
> are living on ext3/ext4 (because of extensive metadata updates on xfs
> makes it the whole machine slow) filesystem and different LV because
> of this.
>

This is a bit off-topic, but do you know of any way to get OpenVZ 
running on a kernel newer than 2.6.32?  One important feature in 2.6.33 
is mergeable LVM snapshots, which would be particularly useful for 
OpenVZ, such as when updating, upgrading or otherwise changing a virtual 
machine.  With mergeable snapshots you could take a snapshot, apply the 
changes to the snapshot, and if it works you merge them back into the 
main logical partition.

mvh.,

David

