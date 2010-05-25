From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: My Thecus RAID-0 filesystem unmountable with mdadm. Please help.
Date: Tue, 25 May 2010 08:59:10 +0100
Message-ID: <4BFB834E.4090808@anonymous.org.uk>
References: <AANLkTinJ2gaVnrPIlJT8m9Ic11qevFNRQgQ-shZropEt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinJ2gaVnrPIlJT8m9Ic11qevFNRQgQ-shZropEt@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Reniau <david.reniau@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/05/2010 13:40, David Reniau wrote:
> In Feb 2010, I (had to) extract(ed) the 4 disks off the NAS rack in
> order to remount the RAID under a regular Linux box. I placed the 4
> disks in USB cases, labelled the cases (1,2,3,4) according to the
> disks genuine order in the NAS rack (see Figure 1 below), and tried to
> rebuild the RAID-0 array by means of mdadm under Ubuntu 9.10, using
> the disks connection situation depited in Figure 2.
> 
> After several trial and error manipulations (not only, but in
> particular, to regenerate the RAID superblocks), I was able to
> re-create the RAID-0 array but... I am unable to mount the RAID file
> system in the end.

If you've recreated the array under Ubuntu with something like `mdadm -C 
/dev/mdX -l 0 -n 4 /dev/disc1p2 /dev/disc2p2 /dev/disc3p2 /dev/disc4p2` 
then you may have the discs in the wrong order, the NAS may internally 
count from the bottom up, so you should also try `mdadm -C /dev/mdX -l 0 
-n 4 /dev/disc4p2 /dev/disc3p2 /dev/disc2p2 /dev/disc1p2`. Other orders 
are also possible but perhaps unlikely.

It's also possible that Thecus used a non-default chunk size. If they 
did you need to find out and include it in your array creation line with 
-c. This is a good one to check out since if the order of the discs is 
right but the chunk size is wrong I can imagine perhaps a quarter of 
blocks appearing in the right places in the resulting /dev/mdX, perhaps 
enough for e2fsck to think there is a damaged ext2/3 filesystem there.

It's also possible that Thecus used a non-default metadata type. If they 
did you need to find out and include it in your array creation line with 
-e. Note also that mdadm's default metadata type has changed so if 
Ubuntu's mdadm is recent enough you may need to specify the 0.90 
metadata if that's what Thecus used.

If you have definitely only ever attempted to assemble the array with 
`mdadm -A` and never recreated it with `mdadm -C` then don't go trying 
any new create lines, there may be valuable information available in the 
RAID superblocks that I couldn't quite get a handle on from your 
original 50K+ email.

Good luck.

Cheers,

John.

