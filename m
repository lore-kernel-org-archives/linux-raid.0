From: Rob Harris <rharris@shabadoo.org>
Subject: Re: no-reboot mirror creation
Date: Tue, 28 Mar 2006 09:46:04 -0500
Message-ID: <44294C2C.6080406@shabadoo.org>
References: <4429435C.6070704@shabadoo.org> <20060328141523.GD18942@chihiro.cern.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060328141523.GD18942@chihiro.cern.ch>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

KELEMEN Peter wrote:
> * Rob Harris (rharris@shabadoo.org) [20060328 09:08]:
> 
>> - created a one-drive mirror using mdadm (requiring --force) on
>> the new disk
> 
> Repeat the exercise, but create a two-drive mirror with one of the
> disks missing.
> 
> 	mdadm -C /dev/mdX -l1 -n2 missing /dev/XXX
> 

Thanks all--I figured it out.

Actually, I just failed and removed the drive that was added as a spare, 
then did:

mdadm /dev/md1 --grow -n2
mdadm /dev/md1 --add /dev/hde1

It's happily resyncing right now. Thanks again!
-R

