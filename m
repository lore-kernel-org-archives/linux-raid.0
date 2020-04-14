From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 18:14:00 +0200
Message-ID: <c6be03e8-7726-f184-7752-b41732a9e015@peter-speer.de>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <f9f2f479-2899-6774-eb20-bf81ed24bc7b@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f9f2f479-2899-6774-eb20-bf81ed24bc7b@shaw.ca>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: G <garboge@shaw.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 14.04.20 18:00, G wrote:
> Since you are running disks less than 2TB I would suggest a more 
> rudimentary setup using legacy bios booting. This setup will not allow 
> disks greater than 2TB because they would not be partitioned GPT. There 
> would still be an ability to increase total storage using more disks. 
> There would be raid redundancy with the ability for grub to boot off 
> either disk.
> 
> Two identical partitions on each disk using mbr partition tables.

Thank you for your thoughts and input.
I would prefer using uefi/gpt in favor of legacy setup even you are 
totally right about the 2TB border.
