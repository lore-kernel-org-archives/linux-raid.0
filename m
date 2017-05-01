From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Tue, 2 May 2017 03:03:07 +0500
Message-ID: <20170502030307.4d7a77dd@natsu>
References: <590117CD.1000009@tesco.net>
        <22785.65375.947842.648174@quad.stoffel.home>
        <5492628.c8B43Z4h0G@matkor-lenovo>
        <22786.16524.435313.304834@quad.stoffel.home>
        <87o9veje3v.fsf@esperi.org.uk>
        <20170430182134.0e8c6dc0@natsu>
        <87fugpkhap.fsf@esperi.org.uk>
        <20170430214729.2a02cce5@natsu>
        <8737cojn54.fsf@esperi.org.uk>
        <20170502024657.6d33fd88@natsu>
        <6398208a-1345-bdec-4be6-a8bd98bfb089@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6398208a-1345-bdec-4be6-a8bd98bfb089@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: Nix <nix@esperi.org.uk>, John Stoffel <john@stoffel.org>, Mateusz Korniak <mateusz-lists@ant.gliwice.pl>, Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 1 May 2017 22:53:14 +0100
Anthony Youngman <antlists@youngman.org.uk> wrote:

> That's what I understood you to mean, but you are aware that SOME raid 
> management still has to be done with echo > /sys/... ?
> 
> So mdadm isn't perfect, not  by a long chalk, yet :-)

Well, why not post some examples of what you find yourself doing often
via /sys, that's not available in mdadm (maybe as a new thread).

One that I remember is the "want_replacement" mechanism, which was initially
only available via "echo > /sys/..." but quickly got added to mdadm as
"--replace".

People (and various outdated wikis) also tend to suggest using "echo check..."
or "echo repair...", but those are available in mdadm as well, via "--action=".

Lastly, I change the "stripe_cache_size" via /sys/, but that's fine-tuning,
which feels OK to do via sysfs parameters, whereas needing to use sysfs for the
most basic operations of managing the storage system does not.

-- 
With respect,
Roman
