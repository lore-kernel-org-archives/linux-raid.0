From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 07:44:50 +0800
Message-ID: <4DD99FF2.2030609@fnarfbargle.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD9633E.5000101@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/05/11 03:25, Stan Hoeppner wrote:
>
> And that backup array may fail you when you need it most:  during a
> restore.  Search the XFS archives for the horrific tale at University of
> California Santa Cruz.  The SA lost ~7TB of doctoral student research
> data due to multiple WD20EARS drives in his primary storage arrays *and*
> his D2D backup array dying in quick succession.  IIRC multiple grad
> students were forced to attend another semester to redo their
> experiments and field work to recreate the lost data, so they could then
> submit their theses.

So I "googled" that thread, and after I picked my way past all the top rating hits which appear to 
be you telling people to google that thread I found the real problem.

He used WD commodity drives on a "hardware" RAID enclosure that needed TLER. The RAID-5 kicked out 4 
drives in a short period of time, so he power cycled it and re-initialised the array and it came up 
fine, but blank (as it would as he re-initialised it).

Sorry Stan, that's not a failure of the drives. He lost the data due to limitations in his RAID 
configuration and bad management.


