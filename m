From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Thu, 7 Dec 2017 18:40:48 +0100
Message-ID: <20171207174048.GA6428@metamorpher.de>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru>
 <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
 <20171206104905.GA4383@metamorpher.de>
 <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
 <20171206160346.GA5806@metamorpher.de>
 <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
 <CACsGCyTZaqRxWFJ1NxN3jVktRcQv3_AdjRTT+3OfuYMuFYdr_w@mail.gmail.com>
 <20171207135832.GA4858@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171207135832.GA4858@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Wols Lists <antlists@youngman.org.uk>, Jeremy Graham <jeremy@doghouse.agency>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 07, 2017 at 02:58:32PM +0100, Andreas Klauer wrote:
> Perhaps it's an intermittent error specific to your smartctl version?

Looking at the source code, it seems to be a case of:

    sct supported, erc unsupported - exit 4 (fail)
    sct unsupported as a whole     - exit 0 (success)

So some drives will give the wrong exit code for this command.

Should probably be reported as a bug to smartmontools.

Regards
Andreas Klauer
