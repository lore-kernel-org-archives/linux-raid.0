From: Tobias Hofmann <tobias.hofmann@medien.uni-weimar.de>
Subject: Re: Spare disk could not sleep / standby
Date: Wed, 09 Mar 2005 10:03:47 +0100
Message-ID: <422EBBF3.70201@medien.uni-weimar.de>
References: <422D327D.11718.F8DB3@localhost>  <200503080414.j284EG510309@www.watkins-home.com>  <16941.11443.107607.735855@cse.unsw.edu.au>  <62b0912f0503072120776e0b56@mail.gmail.com>  <16941.14813.465306.72004@cse.unsw.edu.au>  <62b0912f05030721465e84e4da@mail.gmail.com>  <16941.16439.595486.231598@cse.unsw.edu.au>  <62b0912f050307222494fe17f@mail.gmail.com>  <422D625C.5020803@medien.uni-weimar.de> <62b0912f0503080057488f13ad@mail.gmail.com> <422D83B1.5060709@medien.uni-weimar.de> <Pine.LNX.4.56.0503081133140.4055@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.56.0503081133140.4055@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08.03.2005 14:13, Gordon Henderson wrote:
> On Tue, 8 Mar 2005, Tobias Hofmann wrote:

[...]

>>I had found postings on the net claiming that doing so without
>>unmounting the fs on the raid, this would lead to bad things happening -
>>  but your report seems to prove them wrong...
> 
> 
> I've been using something called noflushd on a couple of small "home
> servers" for a couple of years now to spin the disks down. I made a
> posting about it here some time back and the consensus seemed to be (at
> the time) that it all should "just work"... And indeed it has been just
> working.

Thanks for mentioning this...

> They are only running RAID-1 though, 2.4 and ext2. I understand the ext3
> would force spin-up every 5 seconds which would sort of defeat it. There
> are other things to be aware of to (things that will defeat using hdparm)
> - making sure every entry in syslog.conf is -/var/log/whatever (ie. with
> the hyphen prepended) to stop if doing the fsync on every write which will
> spin up the disks. They are on UPSs, but they have been known to run-out
> in the past )-: so a long fsck and some data loss is to be expected.
> 
> Essentially noflushd blocks the kernel from writing to disk until memory
> fills up.. So most of the time the box sits with the disks spun down, and
> only spins up when we do some file reading/saving to them.

...and this is no prob for me, as my idea is to only spin down a raid 
used for data, not OS...

> Noflushd is at http://noflushd.sourceforge.net/ and claims to work with
> 2.6, but says it will never work with journaling FSs like ext3 and XFS.
> (which is understandable)

...true, but bites me. I,ll still look into it, once I am free to fool 
around with the raid (which currently is a backup, so I,d hesitate to 
"kill" it... :)

greets, tobi... :)
