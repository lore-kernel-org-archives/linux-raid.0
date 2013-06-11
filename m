From: Andrew Brooks <arb@sat.dundee.ac.uk>
Subject: Fwd: mismatches in raid1, clarification please
Date: Tue, 11 Jun 2013 14:49:03 +0100
Message-ID: <CAHOfOo0gjhXV701kwHcLS4-VYvxCnpLZp76P7hc_-e_g6vi-BA@mail.gmail.com>
References: <CAHOfOo1Ex+JsJ3NDzyKxAkabBMY4up0apftMK=mVwS4rw_E+Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHOfOo1Ex+JsJ3NDzyKxAkabBMY4up0apftMK=mVwS4rw_E+Bg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello

The md manual says that
 "If all blocks read successfully but are found to not be consistent, then
this is regarded as a mismatch."
whereas blocks that suffer from a read error are not counted as mismatches.

It then describes the action
 "If repair was used, then a mismatch will be repaired in the same way that
resync repairs arrays. For RAID1, all but one block are overwritten with the
content of that one block."

If there has been no read error then how does it know which block is good?

Andrew
