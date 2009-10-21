From: Neil Brown <neilb@suse.de>
Subject: Re: [Fwd: Re: BUG: soft lockup - CPU#0 stuck for 10s! [md2_raid1:358]]
Date: Thu, 22 Oct 2009 08:48:14 +1100
Message-ID: <19167.33182.441497.969731@notabene.brown>
References: <4ADEFFC9.10405@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Asdo on Wednesday October 21
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday October 21, asdo@shiftmail.org wrote:
> (whops I forgot to cc the list... here it is)
> 
> Lee Howard wrote:
> 
> > I've been deliberately monitoring the kernel via the git web 
> > interfaces, and I can't yet see the patch committed that supposedly 
> > fixed this.  (Please correct me if it was actually committed.)
> 
> Somebody told it was fixed in 2.6.32. Have you checked that one?

As 2.6.32 doesn't exist yet, that should be "will be fixed".

If the problem if what I think it is, then it should be fixed by 
  http://neil.brown.name/git?p=md;a=commitdiff;h=1d9d52416c0445019ccc1f0fddb9a227456eb61b

which I have not yet sent to Linus.

NeilBrown
