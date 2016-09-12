From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Inactive arrays
Date: Mon, 12 Sep 2016 22:39:30 +0100
Message-ID: <57D72092.20704@youngman.org.uk>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk>
 <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/09/16 22:13, Daniel Sanabria wrote:
> apologies for the verbosity just adding some more info which is now
> making me lose hope. Using parted -l instead of fdisk gives me this:

Hmmm...

I'd wait and let some of the experts in disk recovery chime in before it
gets that far. The fact that fdisk found the partitions on sdc and sde
is a hopeful sign. And providing something hasn't scribbled all over the
disk, several of them know their way around partition tables and can
recreate them if they're not totally scrambled.

I think using fdisk on the drives was a mistake, but seeing as -l
doesn't write anything it was a harmless mistake. iirc fdisk can't
handle gpt disks, or stuff over 2TB, so that's where that problem lay.
Try using gdisk instead of parted, that might behave just that little
bit differently, and so long as it doesn't write anything, it won't do
any harm.

What does smartctl report on sdc and sde (I think you want smartctl -x,
the extended "display everything" command)?

And looking at the lsdrv stuff, were you using LVM? That's got a load of
references to LV. The snag is, I'm now getting a bit out of my depth - I
tend to "first respond" and ask for the information that I know the
experts will want. If Phil or someone else now takes a look at this
thread it'll contain all the information they need, but I think we need
to wait for them to chime in now. So hopefully they'll see this tonight
and be on hand soon... I'll come back if I think of anything new ...

Cheers,
Wol
