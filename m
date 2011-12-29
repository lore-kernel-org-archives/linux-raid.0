From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: It is safe to stop Raid being reshaped
Date: Fri, 30 Dec 2011 07:35:27 +0800
Message-ID: <4EFCF93F.6000607@fnarfbargle.com>
References: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com> <4EFB67CC.7010500@shiftmail.org> <CAK90R-ATCf6iSgod4ktvaaiDmGaiaAPFQ+On=t0Ob4g6tUWhYA@mail.gmail.com> <4EFBCA47.9010401@shiftmail.org> <CAK90R-A9BmfjO4DtA+n+pXvv9ud39G8QqkvNOJ6c0Mo3aaBNow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK90R-A9BmfjO4DtA+n+pXvv9ud39G8QqkvNOJ6c0Mo3aaBNow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Thompson <jeremythompson82@gmail.com>
Cc: Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29/12/11 10:23, Jeremy Thompson wrote:
> Here is an excerpt from the dmesg log:
>
> [77832.251754] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x280000 action 0x0
> [77832.261281] ata3.00: BMDMA2 stat 0x696d0009
> [77832.271043] ata3: SError: { 10B8B BadCRC }
> [77832.280933] ata3.00: failed command: READ DMA EXT
> [77832.290523] ata3.00: cmd 25/00:00:78:0f:c0/00:04:5b:00:00/e0 tag 0
> dma 524288 in
> [77832.290526]          res 51/04:6f:78:0f:c0/00:00:00:00:00/f0 Emask
> 0x1 (device error)
> [77832.308903] ata3.00: status: { DRDY ERR }
> [77832.318246] ata3.00: error: { ABRT }
> [77832.408077] ata3.00: configured for UDMA/100
> [77832.408142] ata3: EH complete
>
> The same lines go for ata6 and ata5.  So 3 drives have bad cables?  I
> have to mention before starting the reshaping process, I did not see
> these errors or at least they were not as pronounced as they are
> today.
>
I'd have a close look at your power supply rather than the cables.

I've seen odd behaviour across multiple drives when they were all under load (as they are in a 
reshape) which went away when I replaced the marginal power supply with something more substantial 
and better engineered.

Regards,
Brad
