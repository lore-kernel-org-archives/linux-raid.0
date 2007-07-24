From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Software Raid 5, multiple raid controller disk mixup problem
Date: Tue, 24 Jul 2007 15:18:52 -0400
Message-ID: <46A6509C.6000302@tmr.com>
References: <469CED66.50109@crontex.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <469CED66.50109@crontex.de>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias Rehn <tr@crontex.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tobias Rehn wrote:
> Hey Guys,
>
> I am currently having a strange problem. I have a system with 4 
> onboard sata ports. The system also has four 4-port sata controllers 
> plugged into it.
>
> The raid works fine but if i reboot the system, sometimes my harddisks 
> are mixed up so that my system disk(normally sda) is sometimes sdb or 
> sdc... My system disk is plugged to one of onboard sata ports.
>
> I already tried to bind the disks statically via udev to a certain 
> device name, but no chance.
>
> Are there any other methods to stop this mixing of the drives? Or does 
> anyone have the same problem?
I was really hoping one of the hardware guys would answer this. My only 
thought is that you have a feature enabled which allows simultaneous 
discovery, and that the 1st drive spun up is sda,, etc. If you could 
save your dmesg from a good and bad boot, and make them available, 
someone may see the problem, I can't guess beyond what I've said already.

If you are building the arrays using UUID in the config file, it should 
matter what they are called, of course. Mine just list devices 
PARTITIONS and then a bunch of arrays based on UUID. It makes for a huge 
dmesg file, of course, filled meaningless babble about "found this" and 
"that doesn't match." But it works every blessed time, which is more 
important in the long run.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

