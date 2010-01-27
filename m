From: Maarten <maarten@ultratux.net>
Subject: Re: woes with... mdadm ?
Date: Wed, 27 Jan 2010 19:30:29 +0100
Message-ID: <4B608645.8030102@ultratux.net>
References: <4B5F6C5D.8020202@ultratux.net> <4877c76c1001262014w6219132ew552b092dab9aba62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1001262014w6219132ew552b092dab9aba62@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi Michael, thanks for your reply

Michael Evans wrote:
> Lets validate some basics first:
> 
> 1, 2) Have you stress-tested your CPU and ram?

Depending on your definition of such a test, yes. For starters, I've 
installed Gentoo with it & on it. I reckon no bad CPU and/or RAM would 
ever survive compiling of gcc, glibc and the kernel along with some 100 
other packages.  However, because DIMMs were swapped since then I did a 
10-hour memtest86 today to be doubly sure: no errors.

> 3: the CRC is off only on two nibbles (between bits 4 and 11); and
> nowhere else.  That usually doesn't happen with CRCs.

Okay... But I'm not sure what that points to exactly...

> 3) >> In the past I had some similar SATA controllers become corrupted
> by some test-debugging code in an older version of the kernel.  Even
> if the devices firmware is up to date TRY REFLASHING/'updating' THEM.

I'm not saying that's a bad idea, but just to clarify things: two of 
those 5 controllers plus the port replicator have been bought new just 
last week. No chance there is corruption there, I'd say. I'll swap the 
disks to not previously used cards and rerun some tests.

> 4) Have you run S.M.A.R.T. self tests

Not yet but of the 6 disks used, 4 of them are fresh new 1 TB drives. 
The two used for the raid1 test were older 320 GB drives.

In any case I have a large stockpile of both SATA cards of 5+ different 
makes, and many (15+) smaller disks of previously used arrays (<250GB). 
So I can easily repeat this with any arbitrary combination of devices. 
And they can't be all bad. But for now I have reproduced it only with 
two setups, yes. I'll change the setup to get more reliable results.

> 5) If possible badblocks as well; once you've verified everything else.

I appreciate you want to eliminate all possible sources of error but can 
I just say this does not look like a problem with the disk reliability?
Not that I consider myself an expert, but in the 12 years I've been 
using md raid I have not had such weird failures. And the chances of it 
happening on 3 separate drives, all in exactly the same manner, are 
really fairly slim.

> Those are all possible and easy to test for causes of data-corruption.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

