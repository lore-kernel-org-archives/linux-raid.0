From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 21:13:45 +0200
Message-ID: <fe996f6f-3b0a-4638-d74d-ae6dc99599df@peter-speer.de>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <5E95C698.1030307@youngman.org.uk>
 <13a3bc12-67f7-46d5-7e6a-c6880ace4b1c@peter-speer.de>
 <5E95F461.50209@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E95F461.50209@youngman.org.uk>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 14.04.20 19:35, Wols Lists wrote:
> I prefer swap to be at least twice ram. A lot of people think I'm daft
> for that, but it always used to be the rule things were better that way.
Twice RAM means 32G here, no prob, will do so. Not afraid of DoS-Attacks 
also - this machine operates in stealth mode and has got the most clean 
logs one could have seen so far :-)

>> OK. Does this mean that I have to partition my both drives first and
>> after that create the raid arrays, which will end in /dev/md0 for ESP
>> (mount point /boot), /dev/md1 (swap), /dev/md2 for the rest?
> Yup. Apart from the fact that they will probably be 126, 125 and 124 not
> 0, 1, 2. And if I were you I'd name them, for example EFI, SWAP, MAIN or
> LVM.
I will do so, thanks for the hint.

>> What Partition Type do I have to use for /dev/sd[a|b]3? Will it be LVM
>> or RAID?
>>
> I'd just use type linux ...
Could you please be a little more concrete on this one?
