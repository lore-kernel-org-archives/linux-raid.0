From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: feature re-quest for "re-write"
Date: Tue, 25 Feb 2014 23:05:55 +1100
Message-ID: <530C8723.9050009@eyal.emu.id.au>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se> <530AA09B.3090708@fnarfbargle.com> <530AA460.602@eyal.emu.id.au> <530AAA55.2080508@fnarfbargle.com> <530ABF21.7030200@eyal.emu.id.au> <BLU0-SMTP340FC1C74C40495FA5F94298860@phx.gbl> <530BADF2.3090907@eyal.emu.id.au> <20140225141650.56b8dac4@notabene.brown> <530C4D18.4090403@eyal.emu.id.au> <20140225193501.080a8e61@notabene.brown> <530C79AD.2020400@eyal.emu.id.au> <alpine.DEB.2.02.1402251224390.747@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1402251224390.747@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yes, this matches what I saw. From "mdadm -E /dev/sdi1":

  Avail Dev Size : 7813771264 (3725.90 GiB 4000.65 GB)
      Array Size : 19534425600 (18629.48 GiB 20003.25 GB)
   Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors

Is the layout of this 128KB area documented? I expect basic superblock data, log, bitmap,
what else? Are there copies elsewhere on the disk that can be used? I wonder what the
bad sector 259648 (close to the end of the header) covers.

Can it be rebuilt from the other members of the array (when stopped one can expect the
log and bitmap to be clearable)? Don't know.

Maybe build a new array with the --assume-clean option that will rewrite the header but
leave the data alone? Doco says "not  recommended".

Or just give up: fail and remove the disk, clear the superblock then add it and go through
a full resync. This way feels safer as I do not touch the other members.

cheers
	Eyal

On 02/25/14 22:28, Mikael Abrahamsson wrote:
> On Tue, 25 Feb 2014, Eyal Lebedinsky wrote:
>
>> Final thought: if this sector is in an important header, when it *does* need to be read (and fail), how bad a reaction should I expect?
>
> I have two thoughts here:
>
> Check data offset when doing mdadm -E. There you will see how much unused data is allocated between the superblock and start of the actual array data contents. This might be where your pending block is.
>
> Regarding re-write. I have had happen to me that one drive that had bad blocks that "check" didn't find errors on, when I rebooted that drive had read errors on the superblock, was not assembled into the array, and instead md started rebuilding to a spare since the array was degraded. So my wonder is, when issuing "check" or "repair", does md actually check if the superblocks are readable? If not, perhaps it should? Should it check the contents of the superblocks are consistent with the data that the kernel has in its data structures?

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
