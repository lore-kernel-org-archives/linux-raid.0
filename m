From: CoolCold <coolthecold@gmail.com>
Subject: Re: raid(1) and block caching
Date: Sun, 30 Oct 2011 15:07:04 +0400
Message-ID: <CAGqmV7rO8hW9dFE0s_B6EG2Pc4EoqbH9ks=Lt1ycEW+OnoNMCA@mail.gmail.com>
References: <CAGqmV7p+GP-Ou-zUhq2rBb_9_tAEX6PRtQatvLCG9=FuOPNsow@mail.gmail.com>
	<20111029172641.57f92fc3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111029172641.57f92fc3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Oct 29, 2011 at 10:26 AM, NeilBrown <neilb@suse.de> wrote:
> On Sat, 29 Oct 2011 08:49:09 +0400 CoolCold <coolthecold@gmail.com> w=
rote:
>
>> Hello!
>>
>> There is holywar once again on nginx maillist about standalone drive=
s
>> vs raid1 arrays for serving static files. By standalone drives it is
>> assumed that file "Filename1" exist on /mnt/disk1, /mnt/disk2,
>> /mnt/diskN where /mnt/diskX is mountpoint for drives /dev/sdY.
>
> If you want fast reads, then use RAID0 if you don't care about losing=
 your
> data, and RAID10 in 'far' mode if you want RAID protection.
>
>>
>> As there are some pros and cons on both sides (at least theoreticall=
y)
>> =A0I have dumb question - let's say our array md1 consists on 3 driv=
es -
>> /dev/sd{a,b,c} - and when data read from md1 occurs, which block is
>> cached in VFS (or may be other cache in system, it would be nice to
>> know which part of system is doing caching) =A0- the block from md1
>> itself or from certain drive? If it is drive-based block cache, it's
>> gonna be potentially memory wasting to keep 3 similar data copies, s=
o
>> I assume md does data reads with something like O_DIRECT flag, but a=
s
>> I 1) don't know C 2) don't know kernel, I'm asking this on the list =
to
>> make this clean for myself.
>>
>
> The kernel caches pages of files, not pages of devices.
> It doesn't matter where the page of data came from - it is the page o=
f a file
> that is cached.
Neil, thanks for clearing it out!

>
> NeilBrown
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
