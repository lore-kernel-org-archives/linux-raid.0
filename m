From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Mon, 1 May 2017 22:53:14 +0100
Message-ID: <6398208a-1345-bdec-4be6-a8bd98bfb089@youngman.org.uk>
References: <590117CD.1000009@tesco.net>
 <22785.65375.947842.648174@quad.stoffel.home>
 <5492628.c8B43Z4h0G@matkor-lenovo>
 <22786.16524.435313.304834@quad.stoffel.home> <87o9veje3v.fsf@esperi.org.uk>
 <20170430182134.0e8c6dc0@natsu> <87fugpkhap.fsf@esperi.org.uk>
 <20170430214729.2a02cce5@natsu> <8737cojn54.fsf@esperi.org.uk>
 <20170502024657.6d33fd88@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170502024657.6d33fd88@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, Nix <nix@esperi.org.uk>
Cc: John Stoffel <john@stoffel.org>, Mateusz Korniak <mateusz-lists@ant.gliwice.pl>, Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/05/17 22:46, Roman Mamedov wrote:
> On Mon, 01 May 2017 22:13:59 +0100
> Nix <nix@esperi.org.uk> wrote:
>
>>> (having to fiddle with "echo > /sys/..." and "cat /sys/..." is not the state
>>> of something you'd call a finished product).
>> You mean, like md? :)
> You must be kidding. On the contrary I was looking to present md as the
> example of how it should be done, with its all-encompassing and extremely
> capable 'mdadm' tool -- and a complete lack of a similar tool for bcache.
>
That's what I understood you to mean, but you are aware that SOME raid 
management still has to be done with echo > /sys/... ?

So mdadm isn't perfect, not  by a long chalk, yet :-)

Cheers,
Wol
