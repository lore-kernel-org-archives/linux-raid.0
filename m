From: Phil Turmel <philip@turmel.org>
Subject: Re: md resync ignoring unreadable sectors
Date: Sat, 07 Feb 2015 18:42:04 -0500
Message-ID: <54D6A2CC.3050102@turmel.org>
References: <20150208024745.01b9d3ff@natsu>	<54D69433.9060605@eyal.emu.id.au> <20150208040438.156a8554@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150208040438.156a8554@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Roman,

On 02/07/2015 06:04 PM, Roman Mamedov wrote:
> On Sun, 08 Feb 2015 09:39:47 +1100
> Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:

>> I looked up the size of the different parts of the RAID to arrive at that conclusion. Dumping the sectors
>> around the bad area also showed it to be all zeroes.
> 
> I wouldn't expect mdadm to have any headers or unused areas as far as 133 MB
> into a RAID member.

Look at mdadm -E for that drive and your partition start sector.  I bet
Eyal is right.  Latest mdadm gives me a 128MB data offset.

Phil

