From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: using the raid6check report
Date: Mon, 9 Jan 2017 08:20:46 +1100
Message-ID: <d42c57a7-815d-bbbb-1712-bf1df9947c97@eyal.emu.id.au>
References: <14e8ec23-de4a-e90b-4b67-155e5e3cc228@eyal.emu.id.au>
 <20170108174010.GA3699@lazy.lzy>
 <a33dbf5c-465d-b5af-a9a9-a00664816489@eyal.emu.id.au>
 <20170108204659.GB7057@lazy.lzy> <5872A9C6.7010408@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5872A9C6.7010408@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/01/17 08:06, Wols Lists wrote:
> On 08/01/17 20:46, Piergiorgio Sartor wrote:
[trim]

> If one of the parity sectors is corrupted, it's easy. Calculate parity
> from the data, and either P or Q will be wrong, so fix it. But if it's a
> *data* sector that's corrupted, both P and Q will be wrong. How easy is
> it to work back from that, and work out *which* data sector is wrong? My
> fu makes me think you can't, though I could quite easily be wrong :-)

My understanding of RAID6 is that you CAN say which of the data/P/Q is
wrong if one assumes only one is wrong.

Is this not what raid6check claims to do?
	"In case of parity mismatches, "raid6check" reports, if possible,
	"which component drive could be responsible"

> But should that even happen, unless a disk is on its way out, anyway?

Not so. I get, from time to time, non zero mismatch where I saw no disk
errors of any sort in kernel messages or in smart status.

> I remember years ago, back in the 80s, our minicomputers had
> error-correction in the drive. I don't remember the algorithm, but it
> wrote 16-bit words to disk - each an 8-bit data byte. The first half was
> the original data, and the second half was some parity pattern such that
> for any single-bit corruption you knew which half was corrupt, and you
> could throw away the corrupt parity, or recreate the correct data from
> the parity. Even with a 2-bit error I think it was >90% detection and
> recreation. I can't imagine something like that not being in drive
> hardware today.

The disk thinks it has good data but md thinks not. Maybe bad data was
written due to some other bug? A corner case when the system rebooted
unexpectedly? Maybe the controller corrupted the data?

> Cheers,
> Wol

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
