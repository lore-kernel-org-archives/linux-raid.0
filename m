From: Iustin Pop <iusty@k1024.org>
Subject: Re: raid10 vs raid5 - strange performance
Date: Sat, 29 Mar 2008 22:26:21 +0100
Message-ID: <20080329212621.GA30665@teal.hq.k1024.org>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com> <20080325233649.GA632@rap.rap.dk> <bb145bd20803251837x7ef1fa9dk6191fcaea7b02144@mail.gmail.com> <20080326072416.GA8674@rap.rap.dk> <bb145bd20803261016t351e4b98rb8989cc6c849108f@mail.gmail.com> <20080326192935.GB18621@rap.rap.dk> <47EAACAB.7070203@tmr.com> <bb145bd20803261902g44e88f64p982607b88d864678@mail.gmail.com> <47EEA5BB.5080106@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47EEA5BB.5080106@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Christian Pernegger <pernegger@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Mar 29, 2008 at 04:25:31PM -0400, Bill Davidsen wrote:
> Christian Pernegger wrote:
>>>  After doing a little research, I see that the original slowest form of PCI
>>>  was 32 bit 33MHz, with a bandwidth of ~127MB/s.
>>>     
>>
>> That's still the prevalent form, for anything else you need an (older)
>> server or workstation board. 133MB/s in theory, 80-100MB/s in
>> practice.
>>
>>   
> I just looked at a few old machine running here, ASUS P4P800 (P4-2.8  
> w/HT), P5GD1 (E6600), and A7V8X-X (Duron) boards, all 2-5 years old, and  
> lspci shows 66MHz devices on the bus of all of then, and the two Intel  
> ones have 64-bit devices attached.
>>>  The most common hardware used the v2.1 spec, which was 64 bit at 66MHz.
>>>     
>>
>> I don't think the spec version has anything to do with speed ratings, really.
>>
>>   
> That was the version which included 66MHz and 64-bit. I believe any
> board using 184, 200, or 240 (from memory) RAM is v2.1, and probably
> runs a fast bus. Pretty much anything not using PC-100 memory. See
> wikipedia or similar about the versions.

I think Christian is right - while PCI 2.1 allows faster buses, it does
not require them. AFAIK, no consumer boards ever included faster PCI
busses. The only version of PCI that was indeed faster was present on
server/workstation boards, but that is a different type of slot.

In order to run at 64bit, the physical slot must be twice the length (as
it's a parallel bus), which can be seen easily seen on wikipedia:
http://en.wikipedia.org/wiki/Image:Pci-slots.jpg is the standard 32-bit
pci slot, whereas http://en.wikipedia.org/wiki/Image:64bitpci.jpg is the
64 bit one - note the double length and the different keying.

The difference between 33MHz and 66MHz is that, while the standard
allows both, it requires a different keying of the slot. 66MHz is only
available on 3.3V slots, which are new in version 2.1, and I think no
vendor risked introducing a different slot just to provide more speed
and (possibly) sacrifice compatibility. Wikipedia says:

    * Card
          o 32-bit, 33 MHz (added in Rev. 2.0)
          o 64-bit, 33 MHz (added in Rev. 2.0)
          o 32-bit, 66 MHz (3.3 V only, added in Rev. 2.1)
          o 64-bit, 66 MHz (3.3 V only, added in Rev. 2.1)
    * Slot
          o 32-bit, 5 V (most common on desktop mainboard)
          o 32-bit, 3.3 V (rare)
          o 64-bit, 5 V (less common, but can also be found on earlier server mainboard)
          o 64-bit, 3.3 V (most common on server mainboard before PCI-X appears)

In the above, you can see that 32 bit, 66 MHz card requires a 32 bit,
3.3 V slot which is different keyed, see (link from wikipedia)
http://www94.web.cern.ch/hsi/s-link/devices/s32pci64/slottypes.html; I
found this picture of the A7V8X-X board here
http://www.motherboard.cz/mb/asus/a7v8x-x_l.jpg and it clearly looks
like a standard 32bit/33MHz/5V slot.

I only know all this as I fought with a 32-bit, 66MHz SATA card a few
years ago hoping that I can get a consumer board that runs at 66MHz. No
luck though.

The fact that lspci shows you 66 MHz capability for some devices doesn't
mean the bus itself runs at 66 MHz. Also, as the bus is shared, you
would need *only* 66MHz devices for the bus to run as that speed.

I'm not an expert in this area, so I'm happy to be corrected if I'm
wrong. I personally never saw a 32bit/66MHz slot, and 64bit only on
server boards as PCI-X.

regards,
iustin
