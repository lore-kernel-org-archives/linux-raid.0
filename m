From: Roman Mamedov <rm@romanrm.net>
Subject: Re: md resync ignoring unreadable sectors
Date: Sun, 8 Feb 2015 04:49:50 +0500
Message-ID: <20150208044950.738bd0dd@natsu>
References: <20150208024745.01b9d3ff@natsu>
	<54D69433.9060605@eyal.emu.id.au>
	<20150208040438.156a8554@natsu>
	<54D6A2CC.3050102@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54D6A2CC.3050102@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 07 Feb 2015 18:42:04 -0500
Phil Turmel <philip@turmel.org> wrote:

> Hi Roman,
> 
> On 02/07/2015 06:04 PM, Roman Mamedov wrote:
> > On Sun, 08 Feb 2015 09:39:47 +1100
> > Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:
> 
> >> I looked up the size of the different parts of the RAID to arrive at that conclusion. Dumping the sectors
> >> around the bad area also showed it to be all zeroes.
> > 
> > I wouldn't expect mdadm to have any headers or unused areas as far as 133 MB
> > into a RAID member.
> 
> Look at mdadm -E for that drive and your partition start sector.  I bet
> Eyal is right.  Latest mdadm gives me a 128MB data offset.

Oh indeed:

    Data Offset : 262144 sectors

The unreadable area was at 260200 sectors.

Thanks

-- 
With respect,
Roman
