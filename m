From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: md raid behavior, bad sector uncorrectable read error
Date: Sun, 19 Aug 2012 12:39:18 +0200
Message-ID: <5030C256.7080708@schinagl.nl>
References: <3E06D7FC-092A-4CB6-B79C-7EC94424DEEE@colorremedies.com> <alpine.DEB.2.00.1208191145230.27104@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1208191145230.27104@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/19/12 11:47, Mikael Abrahamsson wrote:
> On Sat, 18 Aug 2012, Chris Murphy wrote:
>
>> If the affected chunk is rebuilt from parity (or copy in case of
>> mirror), does md raid issue a write command to write the rebuilt chunk
>> back to the disk at the same LBAs? If so, shouldn't this force the
>> drive to determine if the sector error is transient or persistent, and
>> if persistent the disk firmware will remap the bad sector to a reserve
>> sector?
>
> If I remember correctly from what has been described here before, a read
> error will cause a re-write with information created from parity, and
> the drive should figure it out (either is successfully writes the new
> information to the existing sector, or if it can't, it writes it to a
> spare sector (re-map)). If it throws a write error, the drive is kicked
> from the array (because a drive with write errors is clearly defective).
>
> So yes, you're correct in your assumption from what I know.
>
Also, SMARTd would throw up errors when monitoring such drive when a 
re-map occurs, mdadm may not even notice this if the remap happens 
successfully.
