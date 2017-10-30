From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Raid 5 array down/missing - went through wiki steps
Date: Mon, 30 Oct 2017 11:18:05 -0700
Message-ID: <CAK2H+efxSWfJ9ehoOr-tRazDNMzhR=ZdsfRS1z4dziDz23kf0A@mail.gmail.com>
References: <CAA4aoFardnK8fOck4kkCWeYNZc=8-03FJzn6KxS6K9wuYN5bdg@mail.gmail.com>
 <e917e077-a87e-5322-68dd-e25b53bf7678@youngman.org.uk> <CAA4aoFatrJQFPHOUm9C6LjUAeNkSE9eH08T8xphuYNPErVg=QQ@mail.gmail.com>
 <59F51E3C.1050509@youngman.org.uk> <CAA4aoFb-QoHoL0ucTPXiCJMPXfxTtXOF51UjzRC+ViLHEvkW1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA4aoFb-QoHoL0ucTPXiCJMPXfxTtXOF51UjzRC+ViLHEvkW1g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jun-Kai Teoh <kai.teoh@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Oct 30, 2017 at 11:08 AM, Jun-Kai Teoh <kai.teoh@gmail.com> wrote:
> Thanks for all the responses, Mark, Anthony and Wol.
>
> I have another hard drive on the way, just in case sda is truly dead.
> I had no idea that when a drive "dies" in a RAID5 array - nothing
> would notify me. I obviously have much to learn, really appreciate all
> the input from folks so far.
>
> I think I've provided the details of my setup (kernel, mdadm ver,
> distro, smartctl output, and mdadm -E output) - do let me know if I've
> left anything out. Left the machine alone this weekend and did not do
> anything with it.
>
> Kai Teoh
>

Kai Teoh,
   I don't think it's fair to say 'nothing will warn you' as there are ways to
get messages about this stuff. More fair to say that different distros will
better automate some of this stuff but it's always up to the sys admin to
ensure the system does what you want.

   Someone will likely give you input in the next day or two. Give folks
a chance to catch up.

Good luck,
Mark
