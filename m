From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: recovering failed raid5
Date: Fri, 28 Oct 2016 21:52:34 -0500
Message-ID: <CACsGCyTYeC4rrLts9y1Hdor-h8YnHDnoHmFmth_gquv7QPi8Cw@mail.gmail.com>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de> <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133304.GA11564@metamorpher.de> <b878efa4-2581-9284-90ca-170ece7219b5@turmel.org>
 <20161028234529.GA3909@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161028234529.GA3909@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Phil Turmel <philip@turmel.org>, Alexander Shenkin <al@shenkin.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Oct 28, 2016 at 6:45 PM, Andreas Klauer
<Andreas.Klauer@metamorpher.de> wrote:
> You'd think timeouts would solve all problems. They probably don't.
> In some exceedingly rare cases, they might not even matter at all.

As someone who has experienced this problem, no-one is saying that
having correct timeouts fixes *all* problems.  Obviously, drives fail.
However, it's very clear that having mismatched timeouts can cause a
single-sector failure to escalate to the whole drive being kicked from
the array, exposing you to a much bigger risk of data loss if anything
else at all goes wrong while you have no redundancy.

Right, timeouts won't matter all the time.  They only matter when
mismatched and when you hit a condition that causes the OS to give up
before the drive does.  Is that a good reason to look the other way
and not even check to see if you are exposed to risk by having
mismatched timeouts?  Would you tell someone to go boating without a
life jacket because most of the time they might not matter at all?

         Eddie
