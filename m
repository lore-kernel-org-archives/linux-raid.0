From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Write and verify correct data to read-failed sectors before degrading
 array?
Date: Fri, 17 Sep 2004 12:00:33 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16714.17729.576621.347771@cse.unsw.edu.au>
References: <41420D07.4060001@steeleye.com>
	<16709.12517.514905.627708@cse.unsw.edu.au>
	<41487D18.1050000@steeleye.com>
	<4149700F.6060509@buttersideup.com>
	<16714.12891.987589.769643@cse.unsw.edu.au>
	<414A40DB.6070309@thirdmartini.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sebastian Sobolewski on Thursday September 16
To: Sebastian Sobolewski <linux@thirdmartini.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 16, linux@thirdmartini.com wrote:
>     I have some experimental code that does the read-recovery piece for 
> raid1 devices against kernel 2.4.26.  If an error is encountered on a 
> read, the failure is delayed until the read is retried to the other 
> mirror.  If the retried read succeeds it then writes the recovered block 
> back over the previously failed block. 
>     If the write fails then the drive is marked faulty otherwise we 
> continue without setting the drive faulty.  ( The idea here is that 
> modern disk drives have spare sectors, and will be automatically 
> reallocate a bad sector to one of the spares on the next write ). 
>     The caveat is that if the drive is generating lots of bad/failed 
> reads it's most likely going south.. but that's what smart log 
> monitoring is for.  If anyone is interested I can post the patch.

Certainly interested.

Do you have any interlocking to ensure that if a real WRITE is
submitted immediately after (or even during !!!) the READ, it does not
get destroyed by the over-write.
e.g.

application     drive0          drive1
READ request
                READ from drive 0
		fails
				READ from drive 1
				success. Schedule over-write on drive0
READ completes
WRITE block
		WRITE to drive0 WRITE to drive1

                overwrite happens.


It is conceivable that the WRITE could be sent even *before* the READ
completes though I'm not sure if it is possible in practice.

NeilBrown
