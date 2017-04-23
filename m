From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 13:12:54 +0200
Message-ID: <754209bb-9990-2a36-2233-d7d1273c8e37@powerlamerz.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
 <20170423104606.GA4603@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170423104606.GA4603@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/23/2017 12:46 PM, Andreas Klauer wrote:
> On Sun, Apr 23, 2017 at 12:23:17PM +0200, Patrik Dahlström wrote:
>> At this point, it is incorrect.
> 
> :-(
> 
>> I've lost the output from the working
>> raid too, unless it's located in any log in /var/log/.
> 
> If you have kernel logs from before your accident...
> check for stuff like this:
> 
> [    7.328420] md: md6 stopped.
> [    7.329705] md/raid:md6: device sdb6 operational as raid disk 0
> [    7.329705] md/raid:md6: device sdg6 operational as raid disk 6
> [    7.329706] md/raid:md6: device sdh6 operational as raid disk 5
> [    7.329706] md/raid:md6: device sdf6 operational as raid disk 4
> [    7.329706] md/raid:md6: device sde6 operational as raid disk 3
> [    7.329707] md/raid:md6: device sdd6 operational as raid disk 2
> [    7.329707] md/raid:md6: device sdc6 operational as raid disk 1
> [    7.329924] md/raid:md6: raid level 5 active with 7 out of 7 devices, algorithm 2
> [    7.329936] md6: detected capacity change from 0 to 1500282617856
> 
> That's not everything but it's something.
I got some of that!
[    3.100350] md/raid:md1: device sde operational as raid disk 4
[    3.100350] md/raid:md1: device sdc operational as raid disk 3
[    3.100350] md/raid:md1: device sdd operational as raid disk 2
[    3.100351] md/raid:md1: device sda operational as raid disk 0
[    3.100351] md/raid:md1: device sdb operational as raid disk 1
[    3.100689] md/raid:md1: allocated 5432kB
[    3.100699] md/raid:md1: raid level 5 active with 5 out of 5 devices,
algorithm 2
[    3.100700] RAID conf printout:
[    3.100700]  --- level:5 rd:5 wd:5
[    3.100700]  disk 0, o:1, dev:sda
[    3.100700]  disk 1, o:1, dev:sdb
[    3.100701]  disk 2, o:1, dev:sdd
[    3.100701]  disk 3, o:1, dev:sdc
[    3.100701]  disk 4, o:1, dev:sde
[    3.101006] created bitmap (44 pages) for device md1
[    3.102245] md1: bitmap initialized from disk: read 3 pages, set 0 of
89423 bits
[    3.159019] md1: detected capacity change from 0 to 24004163272704

At least I now know in what order that I should assemble my original 5
drives:
sda, sdb, sdd, sdc, sde
It would only be logical for the new drive (sdf) to be last in that list.

> 
> Also in the future for experiments, go with overlays.
> 
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
> (and the overlay manipulation functions below that)
> 
> Lets you mess with mdadm --create stuff w/o actually overwriting original metadata.
Will do
> 
> Regards
> Andreas Klauer
> 
