From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: help with bad performing raid6
Date: Mon, 27 Jul 2009 21:44:41 +0100
Message-ID: <4A6E11B9.3080908@anonymous.org.uk>
References: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-suse@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/07/2009 20:19, Jon Nelson wrote:
> I have a raid6 which is exposed via LVM (and parts of which are, in
> turn, exposed via NFS) and I'm having some really bad performance
> issues
[...]

Probably the first thing to do is to isolate the problem. First up, I'd 
say run bonnie++ against the filesystem locally, then you can eliminate 
the possibility of NFS or networking causing problems. Then, have you 
any spare space on the LVM VG with which you could try another filesystem?

> If I look at the load on the server the top process is
> md0_raid5 (the raid6 process for md0, despite the raid5 in the name).
> The load hovers around 8 or 9 at this time.

You say it's the top process, but is it using any CPU, or just blocked 
waiting for the discs?

Cheers,

John.

