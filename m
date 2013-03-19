From: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: Re[2]: SATA start unit command?
Date: Tue, 19 Mar 2013 21:09:36 +0100
Message-ID: <764451547.20130319210936@oudeis.org>
References: <103777438.20130318003050@oudeis.org>
 <20130318173233.GA2295@lazy.lzy>
 <CAD9gYJLkpmgSY1_U=1H6b+oJJB_R60cHKqs2NCY4wkRL9xmu5w@mail.gmail.com>
Reply-To: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAD9gYJLkpmgSY1_U=1H6b+oJJB_R60cHKqs2NCY4wkRL9xmu5w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?=CD=F5=BD=F0=C6=D6?= <jinpuwang@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


tnx for the info. looks like I need to upgrade from centos5 to centos6
to get the proper versions of the kernel and hdparm.

and also be ready to ship the drive back to WDC if its firmware also
has this bug that prevents disabling PUIS.

=CD> Hi,

=CD> Hdparm offer some method to control power management:
=CD>  -B   Set Advanced Power Management setting (1-255)
=CD>  -s   Set power-up in standby flag (0/1) (DANGEROUS)
=CD>  -S   Set standby (spindown) timeout
=CD>  -y   Put drive in standby mode
=CD>  -Y   Put drive to sleep

=CD> You can more info in the man page

=CD> Regards,
=CD> Jack



=CD> 2013/3/18 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>

>> On Mon, Mar 18, 2013 at 12:30:50AM +0100, Rainer F=FCgenstein wrote:
>> > hi,
>> >
>> > for some reasons I need to keep power consumption at startup as lo=
w as
>> > possible. since the server is booting from SSD, it is possible to =
send
>> > a "start unit" (or similar) command to all SATA drives early in th=
e
>> > init process.
>> >
>> > as far as I've searchengined, the drives and the SATA controller n=
eed
>> > to support this feature. but my assumption is that when the drives=
 are
>> > not needed at startup (since they would be started by the OS), the
>> > controller won't need to support "start unit".  what is your
>> > experience on this matter?
>> >
>> > drives in question are WD Green 3TB drives (WDC WD30EZRX-00DC0B0),=
 the
>> > controllers at hand are a promise SATA 300 TX4 (don't laugh ;-) ) =
and
>> > a supermicro AOC-SAT2-MV8.
>>
>> Hi Rainer,
>>
>> I'm facing a similar issue.
>>
>> That's what I got so far...
>>
>> Many HDDs, but it seems not all, support the so
>> called Staggered Spin Up, this means they are in
>> sleep mode, when powered up.
>> A SATA bus scan will wake them up.
>>
>> The Linux AHCI driver performs, per default, but
>> it could be changed by parameter, a serial bus
>> scan. This means it will wake up the HDDs one after
>> the other sequentially and not alltogether.
>> At least, this is what I understood, but I did not
>> tested it personally, I just trust the information
>> I found around.
>> Check "Linux AHCI SSS" with some search engine and
>> some patience.
>>
>> Other drivers I do not know.
>>
>> If you boot from SSD and you program the HDDs to
>> stay sleepy (jumper, firmware or cable select,
>> more info at https://en.wikipedia.org/wiki/Spin-up
>> and referenced links) it *should* work.
>>
>> Hope this helps,
>>
>> bye,
>>
>> pg
>>
>> >
>> > tnx.
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>>
>> piergiorgio
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>


-----------------------------------------------------------------------=
-------
Unix gives you just enough rope to hang yourself -- and then a couple o=
f more=20
feet, just to be sure.
(Eric Allman)
-----------------------------------------------------------------------=
-------

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
