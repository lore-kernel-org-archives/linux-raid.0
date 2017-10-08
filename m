From: Curt <lightspd@gmail.com>
Subject: Re: hung grow
Date: Sun, 8 Oct 2017 18:40:24 -0400
Message-ID: <CADg2FGY97NYLYPk9W3XL_WgbVdCvOWamF6gjbw9zqwPON5h2og@mail.gmail.com>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com> <d1bd0e82-9415-b6f4-2ffa-6e17bf636f34@youngman.org.uk>
 <CADg2FGaNtjN7=wYe6f07xEZ=mW2QFZdjtBFjQLDthn9w3Jw=NA@mail.gmail.com>
 <3173c10a-fbd9-f563-4c90-a9f63e020773@youngman.org.uk> <CADg2FGbSyvLykThXBpMd4MOuHgh2Q_-zPGm-HFxdYW2z4qsNDQ@mail.gmail.com>
 <c583e62d-f4c1-755e-3985-a37164910c2e@youngman.org.uk> <d21f169e-0546-aa00-ce19-b6688ba74da6@turmel.org>
 <CADg2FGbnMzLBqWthKY5Uo__ANC2kAqH_8B1G23nhW+7hWJ=KeA@mail.gmail.com>
 <CADg2FGYc-sPjwukuhonoUUCr3ze3PQWv8gtZPnUT=E4CvsQftg@mail.gmail.com>
 <7e23d39b-aebb-0852-c98f-758bd99d3eb9@turmel.org> <CADg2FGZatpLPHbuJUEuitbipfX77T1XXduEpLTQjPzq2e56fgg@mail.gmail.com>
 <89992d1f-172f-9fc6-3a1e-50df34e11d3b@turmel.org> <CADg2FGaPFTNLuQPussL=YFDCRndRDFX99D-KjnWfD93MqGJXmg@mail.gmail.com>
 <CADg2FGZNs9KmkKGvbCf-dwsqxYN5ftJd5v7RTJ1M=rLP=v6wJg@mail.gmail.com>
 <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com> <74fde85a-2bf0-a627-239d-b12721f0cc32@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <74fde85a-2bf0-a627-239d-b12721f0cc32@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 7, 2017 at 5:29 PM, Phil Turmel <philip@turmel.org> wrote:
> On 10/07/2017 04:45 PM, Curt wrote:
>
> Hmm.  Please run the assemble again, with the --verbose option, and
> paste all the output here so we can see what's happening.
>
> Also grab the corresponding tail of dmesg (however many lines cover the
> assembly attempt).
>
> Phil

You wouldn't think reply all would be such a hard thing to remember to do.

verbose didn't really add anything, here's my full command, maybe I
miss typed something and didn't notice.

# mdadm --assemble --force --update=revert-reshape --verbose
/dev/md127 /dev/sda1 /dev/sdc1 /dev/sdd1 /dev/sdg1 /dev/sdf1 /dev/sdz1
mdadm: looking for devices for /dev/md127
mdadm: superblock on /dev/sdf1 doesn't match others - assembly aborted

I've got nothing in dmesg or messages

If I can't get the old drive to work.  Is there any chance to still
getting some data from the other drives? Either running the above
without sdf or worse comes to worse the assume clean someone mentioned
before.

Cheers,
Curt
