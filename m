From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: fd filesystem and RAID1
Date: Tue, 06 Apr 2004 00:48:46 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87fzbimqep.fsf@enki.rimspace.net>
References: <1080948756.999.10.camel@localhost>
	<87oeq7me9d.fsf@enki.rimspace.net>
	<1081152016.2301.40.camel@localhost>
	<1081156121.2301.55.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1081156121.2301.55.camel@localhost> (Ninti Systems's message
 of "05 Apr 2004 18:38:41 +0930")
To: office@ninti.com.au
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05 Apr 2004, Ninti Systems wrote:
>> > 
>> > The kernel auto-discovery will only probe a partition that has type
>> > 'fd', so if you want both parts of the mirror to work, both need to
>> > be type 'fd'.
> 
> I tried doing this to partitions on both IDE devices pre-install
> (Slackware saw them all as md devices, install impossible), and I also
> tried changing the original install disk's partitions over to 'fd'
> type after copying their content to the md device (the second disk
> also all 'fd' type).
> 
> But whatever I do the arrays never have usable superblocks, are always
> degraded and always want to resync on boot.

Hrm.  I am sorry that things have proved to be such a challenge.  One
thing to note, of course, is that a software RAID root file system is
much harder to use than any other partition done as software RAID.

You may have better luck by creating a couple of small partitions and
working with those as an "extra" drive, until you resolve the problems.

One final note:  I found the 'mdadm' tool a *vast* improvement over the
traditional RAID tools for Linux.  

> Thanks for all your help, but I'm starting to get over this RAID on
> Slackware thing. I think I'll reconsider my distro (RedHat) or my
> backup strategy (rsync).

RedHat certainly seems to offer good graphical tools for managing this
sort of thing, which can be very useful while you learn how things work.

There is nothing wrong with using a helping hand in software rather than
by email. :)

Good luck.
     Daniel

-- 
All that you suspect about women's friendships is true. We talk about dick size.
        -- Cynthia Heimel
