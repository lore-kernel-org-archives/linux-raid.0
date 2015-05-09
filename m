From: Hans Kraus <hans@hanswkraus.com>
Subject: Re: mdadm Raid level change from 1 to 5?
Date: Sat, 09 May 2015 10:58:50 +0200
Message-ID: <554DCC4A.1090700@hanswkraus.com>
References: <554C7F74.5010404@hanswkraus.com> <20150508104722.GA21989@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150508104722.GA21989@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: robin@robinhill.me.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks a lot, that was it. After fail & remove one HD, set
--raid-devices=3D2 and re-add the removed HD as spare, the --grow worke=
d.

Regards, Hans

Am 08.05.2015 um 12:47 schrieb Robin Hill:
> On Fri May 08, 2015 at 11:18:44AM +0200, Hans Kraus wrote:
>
>> Hi,
>>
>> I have a Raid 1 with 3 drives, the following layout (the internal
>> bitmap is already removed):
>> -----------------------------------------------------------------
>> md20 : active raid1 sdj1[2] sdi1[1] sdn1[0]
>>         732442432 blocks super 1.2 [3/3] [UUU]
>> -----------------------------------------------------------------
>> I tried to change it to Raid 5, but I'm getting aways an error.
>> -----------------------------------------------------------------
>> mdadm --grow /dev/md20 --level=3D5 --raid-devices=3D3 -c 32 \
>>     --backup-file=3D/home/kraush/work/raidLevelChange
>>
>> Impossibly level change request for RAID1
>> -----------------------------------------------------------------
>> I tried it with various permutations (+/- raid-devices, c, ...).
>>
>> Is something in my command wrong or is the level change not
>> possible?
>> This is on Debian 7, mdadm - v3.3-65-g2167de7 - 11th March 2014
>>
> I think you'll need one of the disks to be spare first. Try reducing =
the
> RAID1 to a 2-disk plus spare configuration, then rerunning the grow.
> Alternately you'd need to add a new disk as a spare first, then grow =
to
> a 4 disk RAID5.
>
> HTH,
>      Robin
>

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren gepr=FCft.
http://www.avast.com

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
