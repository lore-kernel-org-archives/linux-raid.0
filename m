From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: On URE and RAID rebuild - again!
Date: Mon, 04 Aug 2014 15:27:13 +0200
Message-ID: <53DF8A31.8060609@assyoma.it>
References: <53D8ACF0.1070202@assyoma.it>	<alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>	<53D8ED99.90606@assyoma.it>	<20140731073121.38cd1773@notabene.brown>	<53D9ED48.9000307@assyoma.it>	<1370eb7a35b628323646a86094a26912@assyoma.it> <20140803134834.7773b0ab@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140803134834.7773b0ab@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids



On 03/08/2014 05:48, NeilBrown wrote:

> You are very unlikely to see UREs just be reading the drive over and over a
> again.  You easily do that for years and not get an error.  Or maybe you got
> one just then.

True. I read over 40 TB from this disk and I haven't find any error. 
Some SMART attribute reported so far:
ID  NAME                    FLAG     V     W     T      R
197 Current_Pending_Sector  0x0012   100   100   000    0
198 Offline_Uncorrectable   0x0010   100   100   000    0

As you can find, no error was reported, and I don't find anything 
suspicious in dmesg. At least, this should prove that article as this 
[1] are quite wrong.

Maybe URE errors are related to unsuccessful writes in the first place. 
I will try to repeat the test intermixing read with full-disk writes.


[1] 
http://subnetmask255x4.wordpress.com/2008/10/28/sata-unrecoverable-errors-and-how-that-impacts-raid/

> If you want to see how the system responds when it hits a URE, you can use the
> hdparm command and the "--make-bad-sector" option.  There is also a
> "--repair-sector" option which will (hopefully) repair the sector when you
> are done.
>
> NeilBrown
>
>
>>
>> Thanks.
>>
>> Il 2014-07-31 09:16 Gionatan Danti ha scritto:
>>>> Yes, you can usually get your data back with mdadm.
>>>>
>>>> With latest code, a URE during recovery will cause a bad-block to be
>>>> recorded
>>>> on the recovered device, and recovery will continue.  You end up with
>>>> a
>>>> working array that has a few unreadable blocks on it.
>>>>
>>>> NeilBrown
>>>
>>> This is very good news :)
>>> I case of parity RAID I assume the entire stripe is marked as bad, but
>>> with mirror (eg: RAID10) only a single block (often 512B) is marked
>>> bad on the recovered device, right?
>>>
>>>  From what mdadm/kernel version the new behavior is implemented? Maybe
>>> the software RAID on my CentOS 6.5 is stronger then expected ;)
>>>
>>> Regards.
>>
>

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
