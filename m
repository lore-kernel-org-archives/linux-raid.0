From: MRK <mrk@shiftmail.org>
Subject: Re: Suggestion needed for fixing RAID6
Date: Sun, 25 Apr 2010 00:47:54 +0200
Message-ID: <4BD3751A.5000403@shiftmail.org>
References: <626601cae203$dae35030$0400a8c0@dcccs>
 <20100423065143.GA17743@maude.comedia.it>
 <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org>
 <717901cae3e5$6a5fa730$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <717901cae3e5$6a5fa730$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/24/2010 09:36 PM, Janos Haar wrote:
>
> Ok, i am doing it.
>
> I think i have found some interesting, what is unexpected:
> After 99.9% (and another 1800minute) the array is dropped the 
> dm-snapshot structure!
>
> ...[CUT]...
>
> raid5:md3: read error not correctable (sector 2923767944 on dm-0).
> raid5:md3: read error not correctable (sector 2923767952 on dm-0).
> raid5:md3: read error not correctable (sector 2923767960 on dm-0).
> raid5:md3: read error not correctable (sector 2923767968 on dm-0).
> raid5:md3: read error not correctable (sector 2923767976 on dm-0).
> raid5:md3: read error not correctable (sector 2923767984 on dm-0).
> raid5:md3: read error not correctable (sector 2923767992 on dm-0).
> raid5:md3: read error not correctable (sector 2923768000 on dm-0).
>
> ...[CUT]...
>
> So, the dm-0 is dropped only for _READ_ error!

Actually no, it is being dropped for "uncorrectable read error" which 
means, AFAIK, that the read error was received, then the block was 
recomputed from the other disks, then a rewrite of the damaged block was 
attempted, and such *write* failed. So it is being dropped for a *write* 
error. People correct me if I'm wrong.

This is strange because the write should have gone to the cow device. 
Are you sure you did everything correctly with DM? Could you post here 
how you created the dm-0 device?

We might ask to the DM people why it's not working maybe. Anyway there 
is one good news, and it's that the read error apparently does travel 
through the DM stack.

Thanks for your work
