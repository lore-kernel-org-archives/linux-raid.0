From: P Orrifolius <porrifolius@gmail.com>
Subject: Re: Advice for recovering array containing LUKS encrypted LVM volumes
Date: Tue, 6 Aug 2013 13:54:05 +1200
Message-ID: <CAC38o7TqO9m=6LDHxDiV=XYcfAdbnpa=GZuft-TAqFDvdqvJ4A@mail.gmail.com>
References: <CAC38o7ScozDqspEH-FSyoa_W5W8s+VfYd1RTAitz574wMYqhkA@mail.gmail.com>
	<51FE529C.6000502@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51FE529C.6000502@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your response...

On 5 August 2013 01:09, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 8/4/2013 12:49 AM, P Orrifolius wrote:
>
>> I have an 8 device RAID6.  There are 4 drives on each of two
>> controllers and it looks like one of the controllers failed
>> temporarily.
>
> Are you certain the fault was caused by HBA?  Hardware doesn't tend to
> fail temporarily.  It does often fail intermittently, before complete
> failure.  If you're certain it's the HBA you should replace it before
> attempting to bring the array back up.
>
> Do you have 2 SFF8087 cables connected to two backplanes, or do you have
> 8 discrete SATA cables connected directly to the 8 drives?  WRT the set
> of 4 drives that dropped, do these four share a common power cable to
> the PSU that is not shared by the other 4 drives?

The full setup, an el-cheapo rig used for media, backups etc at home, is:

8x2TB SATA drives, split across two Vantec NexStar HX4 enclosures.
These separately powered enclosures have a single USB3 plug and a
single eSATA plug.  The documentation states that a "Port Multiplier
Is Required For eSATA".

The original intention was to connect them via eSATA directly to my
motherboard.  Subsequently I determined that my motherboard only
supports command-based not FIS.  I had a look for a FIS
port-multiplier card but USB3 (which my motherboard doesn't support)
controllers seemed about a 1/4 the price so I thought I'd try that
out.  lsusb tells me that there are JMicron USB3-to-ATA bridges in the
enclosures.

So, each enclosure is actually connected by a single USB3 connection
to one of two ports on a single controller.


Logs show that all 4 drives connected to one of the ports were reset
by the XHCI driver (more or less simultaneously) losing the drives and
failing the array.  In the original failure they were back with the
same /dev/sd? in a few minutes, but I guess the Event count had
diverged already.

Perhaps that suggests the enclosure bridge is at fault, unless an
individual port on the controller freaked out.  Definitely not a power
failure, could be a USB3 cable issue I guess.

> The point of these
> questions is to make sure you know the source of the problem before
> proceeding.  It could be the HBA, but it could also be a
> power/cable/connection problem, a data/cable/connection problem, or a
> failed backplane.  Cheap backplanes, i.e. cheap hotswap drive cages
> often cause such intermittent problems as you've described here.

Truth is the USB3 has been a bit of a pain anyway... the enclosure
bridge seems to prevent direct fdisk'ing and SMART at least.  My
biggest concern was that it spits out copious 'needs
XHCI_TRUST_TX_LENGTH quirk?' warnings.
But I burned it in with a few weeks of read/write/validate work
without any apparent negative consequence and it's been fine for about
a year of uptime under light-moderate workload.  My trust was perhaps
misplaced.

>> What is the best/safest way to try and get the array up and working
>> again?  Should I just work through
>> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID
>
> Again, get the hardware straightened out first or you'll continue to
> have problems.

It seems I'd probably be better of going to eSATA... any
recommendations on port multipying controllers?

Is the Highpoint RocketRAID 622 ok?  More expensive than I'd like but
one of the few options that doesn't involve waiting on international
shipping.

>
> Once that's accomplished, skip to the "Force assembly" section in the
> guide you referenced.  You can ignore the preceding $OVERLAYS and disk
> copying steps because you know the problem wasn't/isn't the disks.
> Simply force assembly.

Good news is I worked through the recovery instructions, including
setting up the overlays (due to an excess of paranoia), and I was able
to mount each XFS filesystem and get a seemingly good result from
xfs_repair -n.

Haven't managed to get my additional backups up to date yet due to USB
reset happening again whilst trying but I presume the data will be
ok... once I can get to it.

Thanks.
