From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Thu, 17 Jun 2004 13:57:13 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40D1DB79.5080507@steeleye.com>
References: <40198E85.29EBC8E0@SteelEye.com>	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>	<4027E342.D02202F1@SteelEye.com>	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>	<402D3A86.97CF894F@SteelEye.com>	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>	<4048F9AA.1BBD67F@SteelEye.com>	<406B1024.7BF88C@SteelEye.com>	<16528.49083.998593.199805@cse.unsw.edu.au>	<40C6273B.2060200@steeleye.com> <16590.38597.170409.499394@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16590.38597.170409.499394@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@steeleye.com>
List-Id: linux-raid.ids

Neil Brown wrote:

> The changes to mdadm need a bit of work.
>  
> You have added "--persistent" and "--non-persistent" flags for
> --create.  This is wrong.
> --create always uses persistent superblocks.
> --build makes arrays without persistent superblocks.

Yes, I think --build didn't use to work for raid1, though, which is why 
I went the create route. I'll fix this.

> I don't think I like --create-bitmap.  A bitmap file should always be
> created in the context of a particular array (partly so that the size
> and uuid can be set correctly).  I think I would like to bitmap to be
> specified as a "--bitmap=filename" option to --create, --build, or
> --grow.  I haven't thought this through in great detail yet, but that
> is my leaning.

That all sounds fine except for --build. How do we know if we're doing 
the initial build or just a rebuild. We need to know this so we know 
whether to initialize the bitmap or simply use it. So I think we still 
need --create-bitmap for the build command (and then build will just use 
the bitmap, not initialize it). For --create I can make it so that the 
bitmap is always initialized using the array parameters, so no separate 
--create-bitmap will be needed. I'll need to work out the conflict that 
this will create with the --chunk option, though, since --chunk is the 
array chunk size for --create and --chunk is the bitmap chunk size for 
--bitmap-create. Any suggestions?

> --examine-bitmap is a bit of a pain too. 

-X is usually what I use...that's a lot easier to remember and type...

> I think I would like
> --examine to figure out what it has been given to look at, and report
> on whatever it finds.

Well, that gets into a little bit of black magic when you're talking 
about examining a disk or partition, which could conceivably contain 
both an md superblock at the end and a bitmap at the front. How do we 
know which one it is "supposed" to be? Or do you just want examine to 
print information for both? That would seem a little confusing to me 
(granted this would only happen when a disk changed roles between bitmap 
and array component).

--
Paul
