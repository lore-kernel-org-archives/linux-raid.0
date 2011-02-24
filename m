From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: high throughput storage server?
Date: Thu, 24 Feb 2011 21:53:51 +0100
Message-ID: <4D66C55F.2050003@gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>	<4D5A7198.7060607@hardwarefreak.com>	<AANLkTinpUmxQ6gMWPfyZsfUKjQZ_rGMETf3=BMu5o4Dj@mail.gmail.com>	<AANLkTikSehaGsna8z4qFH_S2JPSsepiTUV8OEYdQPykm@mail.gmail.com> <AANLkTim3uq8_oq07theLrR8qVc4iRBzJUWmAk99E-=Vm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim3uq8_oq07theLrR8qVc4iRBzJUWmAk99E-=Vm@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dne 24.2.2011 21:43, Matt Garman napsal(a):
> On Tue, Feb 15, 2011 at 7:03 AM, Roberto Spadim <roberto@spadim.com.br> wrote:
>> disks are good for sequencial access
>> for non-sequencial ssd are better (the sequencial access rate for a
>> ssd is the same for a non sequencial access rate)
> 
> I have a more general question: say I have an ultra simple NAS system,
> with exactly one disk, and an infinitely fast network connection.
> Now, with exactly one client, I should be able to do a sequential read
> that is exactly the speed of that single drive in the NAS box (assume
> network protocol overhead is negligible to keep it simple).
> 
> What happens if there are exactly two clients simultaneously
> requesting different large files?  From the client's perspective, this
> is a sequential read, but from the drive's perspective, it's obviously
> not.
> 
> And likewise, what if there are three clients, or four clients, ...,
> all requesting different but large files simultaneously?
> 
> How does one calculate the drive's throughput in these cases?  And,
> clearly, there are two throughputs, one from the clients'
> perspectives, and one from the drive's perspective.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

For rough estimate, try to simulate your workload in small scale, ie:
create files on your disk (fs), and run multiple processes (dd) reading
them. To summarize things together watch loads, ie for disk(s): iostat
-mx 1.

HTH, Z.

