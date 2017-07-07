From: Nix <nix@esperi.org.uk>
Subject: Re: Linear device of two arrays
Date: Fri, 07 Jul 2017 12:07:35 +0100
Message-ID: <8737a8o688.fsf@esperi.org.uk>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
        <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <595D2ADA.8010907@youngman.org.uk> (Wols Lists's message of "Wed,
        5 Jul 2017 19:07:22 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Roman Mamedov <rm@romanrm.net>, Veljko <veljko3@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5 Jul 2017, Wols Lists spake thusly:
> My feeling was, if you can't just add drives to the existing raid 10,
> create a new one which you can expand, migrate the fs across (btrfs
> would let you do that live, I believe, so xfs probably can too), then
> you can scrap the old raid-10 and add the drives into the new one.

In extremis you can always connect multiple block devices into one, or
indeed multiple *pieces* of them into one, using dmsetup with the linear
table. (However, this is not persistent, so you'd need to script redoing
it on every boot.)

-- 
NULL && (void)
