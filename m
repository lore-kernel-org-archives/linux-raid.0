From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Fri, 8 Dec 2017 18:20:44 -0600
Message-ID: <CACsGCyQ1vSy9f-uPc7X_m09AN1-Og_A3_eT0S=dbjBKE=R+RNA@mail.gmail.com>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru> <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
 <20171206104905.GA4383@metamorpher.de> <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
 <20171206160346.GA5806@metamorpher.de> <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
 <CACsGCyTZaqRxWFJ1NxN3jVktRcQv3_AdjRTT+3OfuYMuFYdr_w@mail.gmail.com>
 <20171207135832.GA4858@metamorpher.de> <20171207174048.GA6428@metamorpher.de> <5A29D169.4000203@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A29D169.4000203@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, smartmontools-support@listi.jpberlin.de, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 7, 2017 at 5:40 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> But if this is true, for a drive that doesn't support sct (I don't have
> one to test), the command will fail but return 0!!! So the script
> doesn't realise anything is wrong, doesn't fix the defaults, and leaves
> the raid array in the dangerous situation where linux will time out long
> before the drive does.
>
> So does smartctl return 0 if the drive doesn't support sct? If so why?
> And what's the easiest way to detect such a drive if so?

I can reproduce this on a Samsung 830 SSD (released in 2011, probably
purchased in 2012).  I also have an 840 Pro SSD which does not have
this problem -- it fully supports SCTERC being set.  I don't know how
representative of SSD models these two are, but that gives a time
frame for this support appearing in SSD drives.

               Eddie
