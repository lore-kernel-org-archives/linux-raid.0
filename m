From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: read errors corrected
Date: Thu, 30 Dec 2010 11:13:35 +0100
Message-ID: <4D1C5B4F.8050506@texsoft.it>
References: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/30/2010 04:20 AM, James wrote:
> Can someone point me in the right direction?
> (a) what causes these errors precisely?
> (b) is the error benign? How can I determine if it is *likely* a
> hardware problem? (I imagine it's probably impossible to tell if it's
> HW until it's too late)
> (c) are these errors expected in a RAID array that is heavily used?
> (d) what kind of errors should I see regarding "read errors" that
> *would* indicate an imminent hardware failure?

(a) these errors usually come from defective disk sectors. raid 
recostructs the missing sector from parity from other disks in the 
array, then rewrites the sector on the defective disk; if the sector is 
rewritten without error (maybe the hd remaps the sector into its 
reserved area), then just the log messages is displayed.

(b) with raid-6 it's almost benign; to get troubles you should get a 
read error on same sector for >2 disks; or have 2 disks failed and out 
of the array and get a read error on one of the other disks while 
recostructing the array; or have 1 disk failed and get a read error on 
same sector on >1 disk while recostructing (with raid-5 it's almost 
dangerous instead, as you can have big troubles if a disk fails and you 
get a read error on another disk while recostructing; that happened to me!)

(c) no; it's also a good rule to perform a periodic scrub of the array 
(check of the array), to reveal and correct defective sectors

(d) check smart status of the disks, for "relocated sectors count"; also 
if md superblock is >= 1 there is a persistent count of corrected read 
errors for each device into /sys/block/mdXX/md/dev-XX/errors, when this 
counter reaches 256 the disk is marked failed; ihmo when a disk is 
giving even few corrected read errors in a short interval its better to 
replace it.

-- 
Yours faithfully.

Giovanni Tessore


