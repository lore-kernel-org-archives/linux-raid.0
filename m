From: Brad Hubbard <brad@congosystems.com>
Subject: Re: Winfast ATA100
Date: Mon, 8 Apr 2002 13:24:03 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <02040813240308.06637@badnote>
References: <20020312225411.6487E22AB@hermes.fra.hollants.com>
Reply-To: brad@congosystems.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-Reply-To: <20020312225411.6487E22AB@hermes.fra.hollants.com>
To: Pieter Hollants <pieter@hollants.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 13 Mar 2002 09:54, Pieter Hollants did align ASCII characters thusly:
> > Has anyone got any experience with getting the Leadtek Winfast ATA100
> > cards
> > under Linux?
>
> They seem to use the CMD/Silicon Image chips, which have excellent Linux
> support. When I researched chipsets in last August, the driver hadn't
> changed since kernel 2.4.4. My SW RAID-1 has run stable and reliable
> ever since.

Finally got this going (got absolutely no response from CMD or Leadtek by the 
way).

Needed a line like this in lilo.conf

append="ide2=0xdc00,0xd802,17 ide3=0xd400,0xd002,17 ide0=autotune 
ide1=autotune ide2=autotune ide3=autotune"

Note: This line is, of course, system specific.

Hope this stops someone burning as many hours on it as I did :-)

Cheers,
Brad
