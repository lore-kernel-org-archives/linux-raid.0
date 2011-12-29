From: Jeremy Thompson <jeremythompson82@gmail.com>
Subject: Re: It is safe to stop Raid being reshaped
Date: Thu, 29 Dec 2011 15:37:31 -0800
Message-ID: <CAK90R-DWAAhOx_yJsVev4+szUmkkPr-fpvT0jUFD_W1aMNhYRw@mail.gmail.com>
References: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com>
 <4EFB67CC.7010500@shiftmail.org> <CAK90R-ATCf6iSgod4ktvaaiDmGaiaAPFQ+On=t0Ob4g6tUWhYA@mail.gmail.com>
 <4EFBCA47.9010401@shiftmail.org> <CAK90R-A9BmfjO4DtA+n+pXvv9ud39G8QqkvNOJ6c0Mo3aaBNow@mail.gmail.com>
 <4EFCF93F.6000607@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EFCF93F.6000607@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@fnarfbargle.com>
Cc: Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I thought about this as well - I have an Enermax 450 in there right
now... I'll have to look for a higher watt power supply next I guess.

Thanks,
Jeremy

On Thu, Dec 29, 2011 at 3:35 PM, Brad Campbell <brad@fnarfbargle.com> w=
rote:
> On 29/12/11 10:23, Jeremy Thompson wrote:
>>
>> Here is an excerpt from the dmesg log:
>>
>> [77832.251754] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x280000 a=
ction
>> 0x0
>> [77832.261281] ata3.00: BMDMA2 stat 0x696d0009
>> [77832.271043] ata3: SError: { 10B8B BadCRC }
>> [77832.280933] ata3.00: failed command: READ DMA EXT
>> [77832.290523] ata3.00: cmd 25/00:00:78:0f:c0/00:04:5b:00:00/e0 tag =
0
>> dma 524288 in
>> [77832.290526] =A0 =A0 =A0 =A0 =A0res 51/04:6f:78:0f:c0/00:00:00:00:=
00/f0 Emask
>> 0x1 (device error)
>> [77832.308903] ata3.00: status: { DRDY ERR }
>> [77832.318246] ata3.00: error: { ABRT }
>> [77832.408077] ata3.00: configured for UDMA/100
>> [77832.408142] ata3: EH complete
>>
>> The same lines go for ata6 and ata5. =A0So 3 drives have bad cables?=
 =A0I
>> have to mention before starting the reshaping process, I did not see
>> these errors or at least they were not as pronounced as they are
>> today.
>>
> I'd have a close look at your power supply rather than the cables.
>
> I've seen odd behaviour across multiple drives when they were all und=
er load
> (as they are in a reshape) which went away when I replaced the margin=
al
> power supply with something more substantial and better engineered.
>
> Regards,
> Brad
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
