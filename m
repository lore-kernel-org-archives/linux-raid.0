From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 8 Jan 2005 21:33:38 +0100
Message-ID: <crpg32$2rr$1@sea.gmane.org>
References: <200501081855.j08It8910389@www.watkins-home.com> <200501082025.20463.maarten@ultratux.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten <maarten@ultratux.net> wrote:
> On Saturday 08 January 2005 19:55, you wrote:
>> My disks claim to be able to re-locate bad blocks on read error.  But I am
>> not sure if this is correctable errors or not.  If not correctable errors
>> are re-located, what data does the drive return?  Since I don't know, I
...
> Afaik, if a drive senses it gets more 'difficult' than usual to read a sector, 
> it will automatically copy it to a spare sector and reassign it. However, I 

No, this is usually not the case. At least I don't know IDE drives
that do so. This is why I call it `sector read error'.
Each newer disk has some amount of `spare sectors' which can be
used to relocate bad sectors. Usually, you have two situations
where you can detect a bad sector:
1. If you write to it and this attempt fails and
2. If you read from it and this attempt fails.
1. would require some verify-operation, so I'm not sure if this
is done at all in the wild.
2. has a simple problem: If you get a read-request for sector x
and you cannot read it, what data should you return then? The
answer is simple: you don't return data but an error (the read-
error). Additionally you mark the sector as bad and relocate the
next write-request for that sector to some spare sector and further
read-requests then too. However, you still have to respond error
messages for each subsequent read-request before the first
relocated write-request appears.
And afaik this is what current disks do. That's why you can just
re-sync the failed disk to the array again without any problem -
because the write-request happens then, the relocation takes place
and everything's fine.


regards,
   Mario
-- 
The social dynamics of the net are a direct consequence of the fact that
nobody has yet developed a Remote Strangulation Protocol.  -- Larry Wall

