From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 16:27:15 +0200
Message-ID: <e23e36e5-7cb0-4e9c-5929-adce833c45f9@thelounge.net>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <5E95C698.1030307@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E95C698.1030307@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 14.04.20 um 16:20 schrieb Wols Lists:
> On 14/04/20 14:02, Stefanie Leisestreichler wrote:
>> Hi List.
>> I want to set up a new server. Data should be redundant that is why I
>> want to use RAID level 1 using 2 HDs, each having 1TB. Like suggested in
>> the wiki, I want to have the RAID running on a partition which has
>> TOTAL_SIZE - 100M allocated for smoother replacement of an array-disk in
>> case of failure.
>>
>> The firmware is UEFI, Partitioning will be made using GPT/gdisk.
>>
>> Boot manager should be GRUB (not legacy).
> 
> Why? Why not EFI? That can boot linux just as easily as it can boot grub

because people prefer to boot the old kernel when something goes wrong
which is somehow difficult by just using uefi-stub
