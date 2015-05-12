From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Installing Linux directly onto RAID6 Array...........
Date: Tue, 12 May 2015 15:05:31 +0100
Message-ID: <CAOS+5GH7hQtJccqU0pp00wpj_43PpMp=wqVN8gftBWiMMqh8_w@mail.gmail.com>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
	<BLU436-SMTP20942BFA85744B69593179D98DA0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP20942BFA85744B69593179D98DA0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "Wilson, Jonathan" <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It's a new z97 board so EFI rules apply.

I have some spare 3TB drives sitting around that I may try to practice
on.......see what will and won't work.

Still open to all suggestions and especially from anyone who's
actually done this.

On 12 May 2015 at 14:27, Wilson, Jonathan <piercing_male@hotmail.com> wrote:
> On Tue, 2015-05-12 at 11:08 +0100, Another Sillyname wrote:
>> I've tried to do some research on this but the information out there
>> seems a bit contradictory (mainly because some is so old).
>>
>> I want to install Fedora directly onto a RAID array (no separate boot disk).
>>
>> My plan is to 'pre configure' the 6 drives as a clean RAID6 array,
>> effectively sd[a-f] without partitions and then attempt to install
>> Fedora 21, from sources it looks like Grub2 should recognise the array
>> and then allow the Kernel to boot thereby 'enabling' the array to
>> become visible and active.
>>
>> However I have not been able to find an actual example of someone
>> trying this......thoughts?
>>
>> The reason to do this is I'm intending to use a Mini ITX board with 6
>> sata ports and want to use 8TB drives in Raid6 to give me a very high
>> density data resilient small form factor storage box.
>
> Grub2 can handle booting into raid6, but some while ago the support was
> sketchy if the array was degraded; this may have improved.
>
> Your problem would be that it would require a biosboot (GPT, type:EF02,
> size:1 MiB) partition to hold part of the loader as it will not fit
> entirely into the "mbr."
>
> A second problem might be that while drives larger than 2 GB can be used
> on (most?) older boards they might not be able to be accessed/read
> correctly/bootable by older non-EFI bios's. My old MB was quite happy to
> boot from a 1 TB drive and linux could see and use my 3TB drives but the
> bios only saw the 3TB drives as 700MB (approx, I recall)
>
> If you are using an EFI system in EFI mode, you will need an EFI
> partition(s) somewhere. On my new system I have all 5 of my 3TB drives
> contain an EFI-dos partition of about 200-500MB and the the rest as one
> large partition for the raid6 containing everything else (/, /home,
> etc.). The only pain in the neck is remembering to copy everything from
> the "live EFI" (default loaded as "/boot") to the backup EFI's when ever
> I change/update stuff in it.
>>
>> Ideas/Suggestions?
>>
>> Thanks
>>
>> Tony
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
