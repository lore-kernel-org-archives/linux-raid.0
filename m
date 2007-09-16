From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: reducing the number of disks a RAID1 expects
Date: Mon, 17 Sep 2007 00:09:24 +0200
Message-ID: <874phu5kkr.fsf@informatik.uni-tuebingen.de>
References: <46E49991.9000000@getsu.com> <46E4AC1A.3010509@sauce.co.nz>
	<46E4F2EA.3020901@getsu.com>
	<20070910095557.GA22549@teal.hq.k1024.org>
	<18150.41048.240735.467994@notabene.brown>
	<46EC4B0A.9040906@getsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46EC4B0A.9040906@getsu.com> (J. David Beutel's message of "Sat,
	15 Sep 2007 11:13:46 -1000")
Sender: linux-raid-owner@vger.kernel.org
To: "J. David Beutel" <jdb@getsu.com>
Cc: Neil Brown <neilb@suse.de>, Iustin Pop <iusty@k1024.org>, Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"J. David Beutel" <jdb@getsu.com> writes:

> Neil Brown wrote:
>> 2.6.12 does support reducing the number of drives in a raid1, but it
>>     will only remove drives from the end of the list. e.g. if the
>>     state was
>>
>>       58604992 blocks [3/2] [UU_]
>>
>> then it would work.  But as it is
>>
>>       58604992 blocks [3/2] [_UU]
>>
>> it won't.  You could fail the last drive (hdc8) and then add it back
>> in again.  This would move it to the first slot, but it would cause a
>> full resync which is a bit of a waste.
>>
>
> Thanks for your help!  That's the route I took.  It worked ([2/2]
> [UU]).  The only hiccup was that when I rebooted, hdd2 was back in the
> first slot by itself ([3/1] [U__]).  I guess there was some contention
> in discovery.  But all I had to do was physically remove hdd and the
> remaining two were back to [2/2] [UU].

mdadm --zero-superblock /dev/hdd

Never forget that when removing a disk. It sucks when you reboot and
your / is suddenly on the removed disk instead of the remaining raid.

MfG
        Goswin
