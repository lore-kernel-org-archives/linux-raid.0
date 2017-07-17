From: Veljko <veljko3@gmail.com>
Subject: Re: Linear device of two arrays
Date: Mon, 17 Jul 2017 12:16:34 +0200
Message-ID: <38e015fa-a07c-8f1a-3a04-384d973966be@gmail.com>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
 <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk>
 <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com>
 <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org>
 <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com>
 <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org>
 <87van15j9b.fsf@notabene.neil.brown.name>
 <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com>
 <87o9sn232n.fsf@notabene.neil.brown.name>
 <1eefd627-1aba-a795-05f0-d2106d3a62a3@gmail.com>
 <87shhyzhg5.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87shhyzhg5.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/15/2017 02:12 AM, NeilBrown wrote:

> So command should be
>
>>>   dd if=/dev/md2 of=SOMEWHERE/SAFE bs=1M skip=5626590
>
> and expect it to create a 3M file.
>
> Use this 'skip' number of the 'seek' number later.
>
> NeilBrown

Thanks, Neil, now it makes more sense.

I tried to create new linear device, but mdadm is complaining about 
data-offset:

# mdadm -C /dev/md4 -l linear -n 2 --rounding=1M -e 1.0 --data-offset=0 
/dev/md2 /dev/md3
  mdadm: invalid data-offset: 0

I'm using Debian 8.8 if it makes any difference.

# mdadm -V
  mdadm - v3.3.2 - 21st August 2014

What could be the problem?

Regards,
Veljko
