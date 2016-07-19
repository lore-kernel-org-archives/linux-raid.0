From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recovering RAID Volumes from 6 Disks
Date: Tue, 19 Jul 2016 20:57:10 +0100
Message-ID: <578E8616.4000908@youngman.org.uk>
References: <CADsVfeyiiAgxeeATrX9UqmWb+Hr3MCf2_eMPjL8hbD7Gpj5Ksg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADsVfeyiiAgxeeATrX9UqmWb+Hr3MCf2_eMPjL8hbD7Gpj5Ksg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Amit Biswas <abiswas@nyu.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Another bit of useful information - can you post the output of smartctl
on all your drives?

smartctl -x /dev/sd[a,b,c...]

Seeing as the drives are Seagate 1TB drives, I suspect they do support
ERC and timeout mismatch is not the problem, but this will tell us.

I'll let others chime in with recovery info, but this information will
definitely help them.

Cheers,
Wol

On 19/07/16 17:29, Amit Biswas wrote:
> Greetings!
> 
> Backup server was acting up and the issue was the drives (all of them)
> :( Could use some guidance or verdict.
> 
> It has a total of 6 drives: sda,b,c,d,e,f. From the superblock info
> (attached), there is a raid 1, and a raid 10 volume. Problem is all
> the disks are part of both raid volumes (according to superblock).
> 
> I am currently booted into an ubuntu live disk shell.
> 

