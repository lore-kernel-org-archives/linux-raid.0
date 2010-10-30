From: Phil Turmel <philip@turmel.org>
Subject: Re: argh!
Date: Sat, 30 Oct 2010 11:45:58 -0400
Message-ID: <4CCC3DB6.3020500@turmel.org>
References: <AANLkTin6huEzOP7FktRRMT7UMVqxxv7aHwXPRE9NjUXs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin6huEzOP7FktRRMT7UMVqxxv7aHwXPRE9NjUXs@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: Jon Hardcastle <jonathan.hardcastle@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/30/2010 07:56 AM, Jon Hardcastle wrote:
> Guys,
> 
> a new HDD has failed on me during a scrub.... i tried to remove/fail it but
> it kept saying the device was busy. so i forced a reboot.
> 
> I have physically disconnected the drive..
> 
> can anyone take alook at the examine below and tell me if it is should
> assemble ok?
> 
> I tried
> 
> mdadm --assemble /dev/md4 /dev/sda1 /dev/sdb1 /dev/sdd1 /dev/sde1 /dev/sdf1
> /dev/sdg1

I'd try:

mdadm --assemble /dev/md4 /dev/sd{g,a,e}1 missing /dev/sd{d,b,f}1

HTH,

Phil
