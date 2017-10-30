From: Jun-Kai Teoh <kai.teoh@gmail.com>
Subject: Re: Raid 5 array down/missing - went through wiki steps
Date: Mon, 30 Oct 2017 11:08:55 -0700
Message-ID: <CAA4aoFb-QoHoL0ucTPXiCJMPXfxTtXOF51UjzRC+ViLHEvkW1g@mail.gmail.com>
References: <CAA4aoFardnK8fOck4kkCWeYNZc=8-03FJzn6KxS6K9wuYN5bdg@mail.gmail.com>
 <e917e077-a87e-5322-68dd-e25b53bf7678@youngman.org.uk> <CAA4aoFatrJQFPHOUm9C6LjUAeNkSE9eH08T8xphuYNPErVg=QQ@mail.gmail.com>
 <59F51E3C.1050509@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59F51E3C.1050509@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for all the responses, Mark, Anthony and Wol.

I have another hard drive on the way, just in case sda is truly dead.
I had no idea that when a drive "dies" in a RAID5 array - nothing
would notify me. I obviously have much to learn, really appreciate all
the input from folks so far.

I think I've provided the details of my setup (kernel, mdadm ver,
distro, smartctl output, and mdadm -E output) - do let me know if I've
left anything out. Left the machine alone this weekend and did not do
anything with it.

Kai Teoh


On Oct 28, 2017, at 5:18 PM, Wols Lists <antlists@youngman.org.uk> wrote:

On 28/10/17 23:15, Jun-Kai Teoh wrote:

Thanks for the response Anthony & Mark, really appreciate how helpful
both of you are.

I did try to reassemble last night (before I found the wiki and all)
and it would assemble, but then it'll say it can't bring the array up
6 drives with 1 rebuilding, and the array thinks that there should be
8 drives. Does that mean I'm... screwed?


Nope! Definitely not.

Six drives, one rebuilding, array of 8.

That means you have seven *working* drives out of eight. That's enough.
Get the array working, it will continue rebuilding, and will leave you
with seven drives out of eight. In other words, everything is CURRENTLY
okay. But YOU HAVE NO REDUNDANCY. One more problem, and yes you are
screwed. Which is why I say "wait for the experts". But, hardware
permitting, I think this is an easy situation to recover.

Cheers,
Wol
