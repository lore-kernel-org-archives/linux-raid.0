From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: sbp2 logging out causing raid1 to fail
Date: Thu, 25 Mar 2004 13:36:24 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16482.17832.115638.995092@notabene.cse.unsw.edu.au>
References: <s061fb8d.089@med-gwia-02a.med.umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robert Welsh on Wednesday March 24
To: Robert Welsh <rcwelsh@med.umich.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 24, rcwelsh@med.umich.edu wrote:
> Neil,
> 
> I am running kernel 2.4.25 which has the latest (1193) release of
> ieee1394 as far as I can tell by comparing kernel source to ieee1394
> branch.
> 
> Anyway I have built a raid1 array with two 200 gig lacie fw800  drives
> using a lacie fw pci card (ohci compliant chip). The build went fine as
> did the resync. But then I started copying alot over and it died. 
> 
> >From what I can gather in the log files it looks like sbp2 is logging
> out of one of the drives when then manifests as a drive failure - which
> it in a way is. 
> 
> I did see that you had made change in 1016 of sbp2 to allow a second to
> log back in after a bus reset. But what is causing this to actually log
> out and is there a way to prevent?

I'm afraid I cannot help you.  I have never dealt with firewire.

This looks like a firewire problem.  It is returning an error so raid
is failing the drive. I don't know what is causing the error, whether
it should be fixed, and if so, how.

Maybe you should ask on a fire-wire related list, or on linux-kernel.

NeilBrown
