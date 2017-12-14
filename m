From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Thu, 14 Dec 2017 11:32:55 -0600
Message-ID: <CACsGCyRUXdVZsZxBniq+d45sOfzj_d95Z+eiqYVdpaj6zUXpNw@mail.gmail.com>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru> <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
 <20171206104905.GA4383@metamorpher.de> <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
 <20171206160346.GA5806@metamorpher.de> <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
 <CACsGCyTZaqRxWFJ1NxN3jVktRcQv3_AdjRTT+3OfuYMuFYdr_w@mail.gmail.com>
 <20171207135832.GA4858@metamorpher.de> <20171207174048.GA6428@metamorpher.de>
 <5A29D169.4000203@youngman.org.uk> <CACsGCyQ1vSy9f-uPc7X_m09AN1-Og_A3_eT0S=dbjBKE=R+RNA@mail.gmail.com>
 <65201272-bc96-65cc-9888-3163aaebbb2f@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <65201272-bc96-65cc-9888-3163aaebbb2f@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, smartmontools-support@listi.jpberlin.de, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 14, 2017 at 6:43 AM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
> I never claimed it was perfect, just "good enough for me(tm)".

Fair enough!  It may be worth a comment on the mdraid wiki where the
script is shown that older disks might need a manual addition to set
the timeouts, and how to check, maybe with some examples of models
known to have this issue.

How do SSDs behave on bad sectors?  Are SSds subject to the same long
delays, trying and retrying to read the sector from disk?  Is this
timeout a strong concern for SSDs?

Would it be worth trying to get a patch to smartctl?  (In other words,
is it likely they'd accept a change in behavior in this area?)

            Eddie
