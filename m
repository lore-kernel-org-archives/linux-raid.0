From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Sat, 29 Apr 2017 00:46:15 +0200
Message-ID: <4c5d312b-fba6-da20-e08f-ed1a4ba5c313@powerlamerz.org>
References: <20170424123706.GA6798@metamorpher.de>
 <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de>
 <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de>
 <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
 <20170425090122.GA4488@metamorpher.de>
 <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
 <20170425110807.GA5159@metamorpher.de>
 <5c3f7876-1b25-7020-5e7d-01776e7c9903@powerlamerz.org>
 <20170427231242.GA5138@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170427231242.GA5138@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/28/2017 01:12 AM, Andreas Klauer wrote:
> On Thu, Apr 27, 2017 at 09:57:20PM +0200, Patrik Dahlström wrote:
> The quick and dirty method is... grow using dd from 5disk raid (overlay)
> to 6disk raid (no overlay) starting from the correct offset (verify!). 
> That resumes your reshape in an offline-ish, hackish manner, and once 
> it's done you have the whole thing. That's the theory anyway.
> 
> Pseudocode:
> 
> mdadm --create /dev/md5 --assume-clean /dev/overlay/{a,b,c}
> mdadm --create /dev/md6 --assume-clean /dev/{a,b,c,d} # +1 drive
I'm stuck at this step
$ mdadm --create --assume-clean /dev/md1 --data-offset=126464K --level=5 --raid-devices=6 /dev/sda /dev/sdb /dev/sdd /dev/sdc /dev/sde /dev/sdf
mdadm: cannot open /dev/sda: Device or resource busy

My overlay setup is keeping /dev/sd[abdce] busy. How do I setup the
overlay to keep it from occupying the disks?
Overlays are currently created like this:
$ dmsetup create ${b} --table "0 $size_bkl snapshot $d $loop P 8"

Best regards
// Patrik

