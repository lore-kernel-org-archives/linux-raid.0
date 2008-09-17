From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Re: Slow RAID5 build on ata_piix vs. fast on sata_mv
Date: Wed, 17 Sep 2008 10:44:23 -0400
Message-ID: <20080917144423.GC9481@nexus.edgeofthenet.org>
References: <20080908175021.GA7730@nexus.edgeofthenet.org> <20080908213222.GB9484@nexus.edgeofthenet.org> <20080916031601.GC24791@nexus.edgeofthenet.org> <48D03D3C.9000309@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48D03D3C.9000309@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I see I left the original version out of my message. :)

They all arrived with SN04 and I received SN05 from Seagate.

Note that if you look around, people have discussed flashing this drive
with AN05 (which is the firmware Adaptec distributes, IIRC).  I
preferred to contact Seagate directly and follow their advice, using the
firmware they provided based on my serial numbers.

Regards,
Richard

On Wed, Sep 17, 2008 at 11:11:56AM +1200, Richard Scobie wrote:
>
> Interesting, as I have just received 4 of theses drives.
>
> Can you tell me the version of both the faulty and good firmware?
>
> Regards,
>
> Richard
>
> Richard Michael wrote:
>> I'll reply to myself again, since I've solved the issue and figure it
>> might as well go into archives somewhere. :)
>>
>> After discovering Adaptec acknowledged an issue these (and related)
>> drives on their controllers and provides updated drive firmware on their
>> website, I guess-timated a drive issue.  I obtained the new SN05
>> firmware directly from Seagate and the drives are performing much faster
>> on the Intel controller.
>>
>> For good measure, I flashed the other three drives (on the Marvell
>> chipset controller), and they're still fine too.
>>
>> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
