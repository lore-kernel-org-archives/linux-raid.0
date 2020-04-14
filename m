From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 18:41:01 +0200
Message-ID: <bfb8fd04-0f6e-62af-44f8-c9336ef0dd66@peter-speer.de>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <f9f2f479-2899-6774-eb20-bf81ed24bc7b@shaw.ca>
 <f857fc03-d18b-a489-54c9-49c22ad19c39@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f857fc03-d18b-a489-54c9-49c22ad19c39@thelounge.net>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, G <garboge@shaw.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 14.04.20 18:20, Reindl Harald wrote:
> RAID machines are supposed to
> live many many years and you just move the disks to your next machine
> and boot as yesterday

This is exactly the idea behind that setup. My OS will be Arch Linux 
which is a rolling distribution. I have some years of very good 
experience with it on my development machine and I love to have the 
newest and supported software/kernel/libs it is providing.

For these very rare cases in which the system update will somehow hurt 
something I need the LVM snapshots to get me running again pretty soon 
if needed. I bought double hardware like motherboard/processor and will 
change disks at latest after 5 years. The system is supposed to run for 
10+ years and will host some virtual machines based on KVM (one of them 
is from 2006 :-) running ubuntu LTS, totally outdated but always there, 
when needed, guess the next 10 years, LOL).
