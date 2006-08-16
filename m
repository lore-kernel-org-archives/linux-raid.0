From: Nix <nix@esperi.org.uk>
Subject: Re: remark and RFC
Date: Thu, 17 Aug 2006 00:43:57 +0100
Message-ID: <87psf0tfeq.fsf@hades.wkstn.nix>
References: <62b0912f0608160300g58bef34cj87300b32a83b17f0@mail.gmail.com>
	<200608161306.k7GD6Vs29677@inv.it.uc3m.es>
	<62b0912f0608160728x5328c513t582ac560e8c0b681@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0608160728x5328c513t582ac560e8c0b681@mail.gmail.com> (Molle Bestefich's message of "16 Aug 2006 15:28:22 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: ptb@inv.it.uc3m.es, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16 Aug 2006, Molle Bestefich murmured woefully:
> Peter T. Breuer wrote:
>> > The comm channel and "hey, I'm OK" message you propose doesn't seem
>> > that different from just hot-adding the disks from a shell script
>> > using 'mdadm'.
>>
>> [snip speculations on possible blocking calls]
> 
> You could always try and see.
> Should be easy to simulate a network outage.

Blocking calls are not the problem. Deadlocks are.

The problem is that forking a userspace process necessarily involves
kernel memory allocations (for the task struct, userspace memory map,
possibly text pages if the necessary pieces of mdadm are not in the page
cache), and if your swap is on the remote RAID array, you can't
necessarily carry out those allocations.

Note that the same deadlock situation is currently triggered by
sending/receiving network packets, which is why swapping over NBD is a
bad idea at present: however, this is being fixed at this moment because
until it's fixed you can't reliably have a machine with all storage on
iSCSI, for instance. However, the deadlock is only fixable for kernel
allocations, because the amount of storage that'll need is bounded in
several ways: you can't fix it for userspace allocations.  So you can
never rely on userspace working in this situation.

-- 
`We're sysadmins. We deal with the inconceivable so often I can clearly 
 see the need to define levels of inconceivability.' --- Rik Steenwinkel
