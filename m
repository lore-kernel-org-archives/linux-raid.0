From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Spares and partitioning huge disks
Date: Fri, 7 Jan 2005 21:59:26 +0100
Message-ID: <crmt7e$8d6$1@sea.gmane.org>
References: <200501061516.47376.maarten@ultratux.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten <maarten@ultratux.net> wrote:
> I just got my 4 new 250GB disks.  I have read someone on this list advocating 
> that it is better to build arrays with smaller volumes, as that decreases the 
> chance of failure, especially failures of two disks in a raid5 configuration. 

This might be true for read-errors.
However, if a whole disk dies (perhaps because the IDE controller fails,
I assume you're having IDE disks or because of a temperature failure or
something like that) with a couple of partitions on it, you get a lot of
simultaneously 'disks' (partitions), which would completely kill your
RAID5, because RAID5 can IMHO only recover one failing device.
I'd assume, such a setup would kill you in this case, while with only
4 devices (whole 250G disks) you'd survive it. I'm quite sure one
could get it managed back together with more or less expert knowledge,
but I belive the complete RAID would stop processing first.
Just to make this clear - all this are spontaneous assumptions, I did
never play with RAID5.



regards,
   Mario
-- 
I heard, if you play a NT-CD backwards, you get satanic messages...
That's nothing. If you play it forwards, it installs NT.

