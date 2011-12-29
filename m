From: Jeremy Thompson <jeremythompson82@gmail.com>
Subject: Re: It is safe to stop Raid being reshaped
Date: Wed, 28 Dec 2011 18:23:51 -0800
Message-ID: <CAK90R-A9BmfjO4DtA+n+pXvv9ud39G8QqkvNOJ6c0Mo3aaBNow@mail.gmail.com>
References: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com>
 <4EFB67CC.7010500@shiftmail.org> <CAK90R-ATCf6iSgod4ktvaaiDmGaiaAPFQ+On=t0Ob4g6tUWhYA@mail.gmail.com>
 <4EFBCA47.9010401@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EFBCA47.9010401@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I checked the temperature of one of the drives, the reason I say
drives is because as soon as I wrote this email, a couple more drives
started throwing the same errors.  What boggles me is that I can't
have that many possible bad SATA cables? Can I?  The cables being used
are brand new, some off brand I know that but they are brand new.

I will certainly leave the reshape going since I'm almost 50% into it,
it would be dumb for me to stop it and then risk the whole array
losing data... not that the data is super important but I'd like to
keep it if at all possible.

Here is an excerpt from the dmesg log:

[77832.251754] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x280000 acti=
on 0x0
[77832.261281] ata3.00: BMDMA2 stat 0x696d0009
[77832.271043] ata3: SError: { 10B8B BadCRC }
[77832.280933] ata3.00: failed command: READ DMA EXT
[77832.290523] ata3.00: cmd 25/00:00:78:0f:c0/00:04:5b:00:00/e0 tag 0
dma 524288 in
[77832.290526]          res 51/04:6f:78:0f:c0/00:00:00:00:00/f0 Emask
0x1 (device error)
[77832.308903] ata3.00: status: { DRDY ERR }
[77832.318246] ata3.00: error: { ABRT }
[77832.408077] ata3.00: configured for UDMA/100
[77832.408142] ata3: EH complete

The same lines go for ata6 and ata5.  So 3 drives have bad cables?  I
have to mention before starting the reshaping process, I did not see
these errors or at least they were not as pronounced as they are
today.

Anything else you'd like me to check out?  I'd also like to know how
can I correlate between which drive is ata3, ata5, and ata6?  So ata6
could be /dev/sda for instance.

Here is what I get for the temperature from smartctl -a /dev/sdg:

190 Airflow_Temperature_Cel 0x0022   047   032   045    Old_age
Always   In_the_past 53 (77 0 55 36)
194 Temperature_Celsius     0x0022   053   068   000    Old_age
Always       -       53 (0 21 0 0)

I included both of those lines because I'm not sure which ones you
wanted to look at.

Thanks.

On Wed, Dec 28, 2011 at 6:02 PM, Asdo <asdo@shiftmail.org> wrote:
> On 12/28/11 20:06, Jeremy Thompson wrote:
>>
>> The RAID array consists of drives that are on cheap SATA controllers
>> no RAID function on them. =A0That is why I chose to use mdadm instea=
d of
>> a true RAID card.
>
>
> Me too, I meant 3ware used as classic sata controller
>
>
>> So the errors would happen regardless if heat was an issue?
>
>
> I think that with temperature you would get a different error: disk g=
oing
> completely offline due to thermal shutdown.
> Anyway Gordon showed you how to check for temperatures; try that.
> Another way is via "smartctl -a /dev/sdX"
>
> SCSI errors are usually due to cabling, not perfect firmware, not per=
fect
> controller, not perfect controller drivers.
> If you show us the exact error we can be a bit more precise.
> Note: 5 retries (for each scsi command) by the SCSI layer also applie=
s to
> SATA disks, which is your case
>
>
>> I'll wait until the reshape is done then, shutdown the machine and
>> re-arrange the drives before I add another drive to the array.
>
>
> Yes this would be my suggestion, but I don't know everything.
>
> Have a look at the temperatures though, and compare to max temp by yo=
ur HDD
> specs. I suggest you don't stop the array if they are lower.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
