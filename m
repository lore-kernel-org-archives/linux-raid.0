From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: high throughput storage server?
Date: Thu, 24 Feb 2011 14:43:17 -0600
Message-ID: <AANLkTim3uq8_oq07theLrR8qVc4iRBzJUWmAk99E-=Vm@mail.gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<4D5A7198.7060607@hardwarefreak.com>
	<AANLkTinpUmxQ6gMWPfyZsfUKjQZ_rGMETf3=BMu5o4Dj@mail.gmail.com>
	<AANLkTikSehaGsna8z4qFH_S2JPSsepiTUV8OEYdQPykm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikSehaGsna8z4qFH_S2JPSsepiTUV8OEYdQPykm@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 15, 2011 at 7:03 AM, Roberto Spadim <roberto@spadim.com.br> wrote:
> disks are good for sequencial access
> for non-sequencial ssd are better (the sequencial access rate for a
> ssd is the same for a non sequencial access rate)

I have a more general question: say I have an ultra simple NAS system,
with exactly one disk, and an infinitely fast network connection.
Now, with exactly one client, I should be able to do a sequential read
that is exactly the speed of that single drive in the NAS box (assume
network protocol overhead is negligible to keep it simple).

What happens if there are exactly two clients simultaneously
requesting different large files?  From the client's perspective, this
is a sequential read, but from the drive's perspective, it's obviously
not.

And likewise, what if there are three clients, or four clients, ...,
all requesting different but large files simultaneously?

How does one calculate the drive's throughput in these cases?  And,
clearly, there are two throughputs, one from the clients'
perspectives, and one from the drive's perspective.
