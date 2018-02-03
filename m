From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [LSF/MM TOPIC] De-clustered RAID with MD
Date: Sat, 3 Feb 2018 15:53:15 +0000
Message-ID: <5A75DAEB.9030805@youngman.org.uk>
References: <mqdvafkhep0.fsf@linux-x5ow.site>
 <5A6F4CA6.5060802@youngman.org.uk> <87fu6o5o83.fsf@notabene.neil.brown.name>
 <5A704C59.4000705@youngman.org.uk> <87372n613s.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87372n613s.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 30/01/18 11:24, NeilBrown wrote:
> When Ax are a logical stripe and Bx are the next,  then you have a
> slightly better distribution.  If device XX fails then the reads needed
> for the first stripe mostly come from different drives than those for
> the second stripe, which are mostly different again for the 3rd stripe.

Well, my maths has been well and truly proved wrong. But. Does streaming
from one drive directly onto another have value in reducing stress? I've
just done a worked example for four drives, mirrored three times across
eighteen drives.

The result is that the drives have ended up in six groups of three
mirrored drives. So if any drive fails, I can just copy an
almost-identical drive from the mirror.

I'll have to play with eg 17 drives and see if this alters the dynamics
- it'll be interesting.

 0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
a1  b2  c3  a4  c1  a2  b3  c4  b1  c2  a3  b4  a1  b2  c3  a4  c1  a2
b3  c4  b1  c2  a3  b4  a1  b2  c3  a4  c1  a2  b3  c4  b1  c2  a3  b4

Note I'm rotating 5 drives at a time, so a1,a2,a3,a4 goes on drives
0,5,10,15 ... But pick any drive and you'll notice the drives six away
are almost mirrors.

Cheers,
Wol
