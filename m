From: antlists <antlists@youngman.org.uk>
Subject: Re: Raid-6 won't boot
Date: Sat, 28 Mar 2020 10:47:43 +0000
Message-ID: <11a7a5ff-e95a-5068-1ba5-057f5a95f52c@youngman.org.uk>
References: <7ce3a1b9-7b24-4666-860a-4c4b9325f671@shenkin.org>
 <3868d184-5e65-02e1-618a-2afeb7a80bab@youngman.org.uk>
 <ccab6f84-aab3-f483-e473-64d95cbeb7cc@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ccab6f84-aab3-f483-e473-64d95cbeb7cc@shenkin.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/03/2020 15:27, Alexander Shenkin wrote:
> Thanks Wol,
> 
> Booting in SystemRescueCD and looking in /proc/mdstat, two arrays are
> reported.  The first (md126) in reported as inactive with all 7 disks
> listed as spares.  The second (md127) is reported as active
> auto-read-only with all 7 disks operational.  Also, the only
> "personality" reported is Raid1.  I could go ahead with your suggestion
> of mdadm --stop array and then mdadm --assemble, but I thought the
> reporting of just the Raid1 personality was a bit strange, so wanted to
> check in before doing that...

Always remember - provided you don't use a --force, it won't do any 
damange. Given that booting into a rescue CD didn't assemble correctly, 
it looks like --stop then --assemble won't work. You need to follow the 
instructions in "when things go wrogn".

Cheers,
Wol
