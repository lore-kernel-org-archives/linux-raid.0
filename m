From: "Ryan Wagoner" <rswagoner@gmail.com>
Subject: Re: Superblock limits / conversion
Date: Thu, 13 Nov 2008 13:56:03 -0500
Message-ID: <7d86ddb90811131056t16b42e2eu510ab13b9018a379@mail.gmail.com>
References: <7d86ddb90811130646k440676aakecc62defc8d42b7a@mail.gmail.com>
	 <20081113151206.GB25751@cthulhu.home.robinhill.me.uk>
	 <alpine.DEB.1.10.0811131019350.7992@p34.internal.lan>
	 <491C6F33.1040904@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <491C6F33.1040904@sauce.co.nz>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for clarifying the 2TB size. I'm still unsure of whether v1
allows for a recovery to continue after a restart. When I moved
everything over to an LSI controller I had to use the system rescue cd
which somehow marked my array as dirty. During the RAID recovery I had
to reboot and it started the recovery over. It only takes 3 hours to
rebuild the 3 TB drives, but if v1 offered this feature I might switch
in the rare case I need it.

I'm assuming enabling bitmaps could do the same thing for v0.90?
However I've heard there is performance degradation of the array from
this.

Ryan

On Thu, Nov 13, 2008 at 1:17 PM, Richard Scobie <richard@sauce.co.nz> wrote:
> Justin Piszcz wrote:
>>
>>
>> On Thu, 13 Nov 2008, Robin Hill wrote:
>>
>>> On Thu Nov 13, 2008 at 09:46:23AM -0500, Ryan Wagoner wrote:
>>>
>>>> I have a RAID 5 array with 3 TB drives. When reading through the list
>>>> I realized that the v0.90 superblock doesn't support arrays over 2TB.
>>>> This means I can never grow this array to 4 drives?
>>>>
>>> That's my understanding, yes.
>>
>> I grew 400GiB drives in a raid5 configuration  from 1.8TiB to 3.3TiB one
>> at a time with the 0.90 superblock (I believe), is that limit correct?
>
> My understanding is that the 2TB limit on 0.90 superblocks, is for md
> component size, not md device size.
>
> Regards,
>
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
