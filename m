From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Optimizing small IO with md RAID
Date: Mon, 30 May 2011 12:57:28 +0100
Message-ID: <4DE38628.1050201@anonymous.org.uk>
References: <BANLkTi=236kncpunzodSci-1K33u_FBkPA@mail.gmail.com> <irvuj1$rc3$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <irvuj1$rc3$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/05/2011 12:20, David Brown wrote:
> (This is in addition to what Stan said about filesystems, etc.)
[...]
> Try your measurements with a raid10,far setup. It costs more on data
> space, but should, I think, be quite a bit faster.

I'd also be interested in what performance is like with RAID60, e.g. 4 
6-drive RAID6 sets, combined into one RAID0. I suggest this arrangement 
because it gives slightly better data space (33% better than the RAID10 
arrangement), better redundancy (if that's a consideration[1]), and 
would keep all your stripe widths in powers of two, e.g. 64K chunk on 
the RAID6s would give a 256K stripe width and end up with an overall 
stripe width of 1M at the RAID0.

You will probably always have relatively poor small write performance 
with any parity RAID for reasons both David and Stan already pointed 
out, though the above might be the least worst, if you see what I mean.

You could also try 3 8-drive RAID6s or 2 12-drive RAID6s but you'd 
definitely have to be careful - as Stan says - with your filesystem 
configuration because of the stripe widths, and the bigger your parity 
RAIDs the worse your small write and degraded performance becomes.

Cheers,

John.

[1] RAID6 lets you get away with sector errors while rebuilding after a 
disc failure. In addition, as it happens, setting up this arrangement 
with two drives on each controller for each of the RAID6s would mean you 
could tolerate a controller failure, albeit with horrible performance 
and you would have no redundancy left. You could configure smaller 
RAID6s or RAID10 to tolerate a controller failure too.

