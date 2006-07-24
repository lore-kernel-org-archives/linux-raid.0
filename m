From: hahn@physics.mcmaster.ca
Subject: Re: I travelled twice in the past !!
Date: Mon, 24 Jul 2006 09:30:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0607240920150.24050@coffee.psychology.mcmaster.ca>
References: <44C4C6BE.9030305@ensg.ign.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44C4C6BE.9030305@ensg.ign.fr>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Edouard_Gaulu=E9?= <edouard.gaulue@ensg.ign.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> - The system answered it had to resynchronize the disks.
> - After this, the data I got were about one year ago...

you mean that you lost a year's worth of updates?

> - I thought that in RAID 1, writes were made on the 2 disks and reads 
> half/half on the first and the second. Am I wrong ?

no.

> - I've got the feeling that starting a certain day  (don't know which one), 
> it stopped behave this way. Is this happening often ? Is it a bug ? How to 
> detect this behaviour ?

my only theory is that one of your disks fell out of the raid a year ago.
that would explain why it contained old data.  but in rebuilding the raid,
the more recent disk should be overwriting the old one.  unless you do
cruel things to the raid superblocks, I don't really see how this could 
happen.  afaikt, someone would have to jump the event counter on the stale
disk to or past the fresher one, and I expect MD would only do that after a
rebuild succeeds...
