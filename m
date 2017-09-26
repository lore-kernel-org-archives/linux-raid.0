From: "John Stoffel" <john@stoffel.org>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be
 needed.
Date: Tue, 26 Sep 2017 16:55:15 -0400
Message-ID: <22986.48819.81116.815726@quad.stoffel.home>
References: <87y3p372b0.fsf@notabene.neil.brown.name>
        <22985.8214.251962.72926@quad.stoffel.home>
        <87poae72z5.fsf@notabene.neil.brown.name>
        <250d2eff-ce7e-df72-1e6c-b4a8a2c43537@gmail.com>
        <59CAA6AE.9060908@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59CAA6AE.9060908@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Jes Sorensen <jes.sorensen@gmail.com>, NeilBrown <neilb@suse.com>, John Stoffel <john@stoffel.org>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Wols" == Wols Lists <antlists@youngman.org.uk> writes:

Wols> On 26/09/17 16:11, Jes Sorensen wrote:
>> I completely agree, I also think we shouldn't hardcode imposed layouts
>> unless there are very strong reasons for it. Someone may want to put
>> this into an initramfs or somewhere else and want to put it in a
>> different location.

Wols> Plus isn't /sbin deprecated?

LOL!  

Wols> Iirc (very debatable :-) the end goal of the FHS is to have a
Wols> read-only / with all executables in /bin. Okay it's going to
Wols> take a looonngg time to get there, but if I'm right hard-coding
Wols> already-deprecated standards isn't the best move.

Heh heh.

Wols> (Again, iirc :-) sbin stood for *static* binaries needed for
Wols> system recovery, so its original purpose has long been abused
Wols> ... :-)

I agree.  I more think of it as 'system binaries' myself.  Stuff
that's needed by the barebones system to just even run.

But others haven't asuaged my concerns, so I think we're ok.

John
