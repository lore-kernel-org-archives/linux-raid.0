From: antlists <antlists@youngman.org.uk>
Subject: Re: Raid-6 won't boot
Date: Thu, 26 Mar 2020 22:00:57 +0000
Message-ID: <3868d184-5e65-02e1-618a-2afeb7a80bab@youngman.org.uk>
References: <7ce3a1b9-7b24-4666-860a-4c4b9325f671@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7ce3a1b9-7b24-4666-860a-4c4b9325f671@shenkin.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/03/2020 17:07, Alexander Shenkin wrote:
> I surely need to boot with a rescue disk of some sort, but from there,
> I'm not sure exactly when I should do.  Any suggestions are very welcome!

Okay. Find a liveCD that supports raid (hopefully something like 
SystemRescueCD). Make sure it has a very recent kernel and the latest mdadm.

All being well, the resync will restart, and when it's finished your 
system will be fine. If it doesn't restart on its own, do an "mdadm 
--stop array", followed by an "mdadm --assemble"

If that doesn't work, then

https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn

Cheers,
Wol
