From: Matt Simonsen <matt_lists@careercast.com>
Subject: Re: RAID5 causing lockups
Date: 25 Jun 2003 13:36:35 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1056573394.24919.62.camel@mattswrk>
References: <200306251216300921.4D495D48@shargaas.coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200306251216300921.4D495D48@shargaas.coreyfro.com>
To: Corey McGuire <coreyfro@coreyfro.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2003-06-25 at 12:16, Corey McGuire wrote:
> Hey folks,
> 
> I just upgraded my system from a ~200GB mirror to a ~1TB RAID5, but all has
> not transitioned well.


Did the RAID array every finish syncing? It may take a long time
(1048576 megs / 10 mb/sec / 3600 seconds/hr = 29 hours!) ... 

I have one (SCSI) system with a slower CPU, syncing the array I was sure
something was wrong. Once the array was up, though, everything has
worked great. I just have to be sure it shuts down clean or the rebuild
is painful!

Maybe I'm way off, but I'd just give it a day to see if it eventually
syncs. If you can login, do a cat of /proc/mdstat every 15 minutes, if
it's making progress I'd leave it.

Matt

