From: Konstantin Svist <fry.kun@gmail.com>
Subject: Re: Changing Chunk Size on Array
Date: Mon, 19 Jul 2010 17:17:14 -0700
Message-ID: <4C44EB0A.2060604@gmail.com>
References: <CC.8D.04655.49D124C4@cdptpa-omtalb.mail.rr.com> <20100720014955.529eb9ca@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100720014955.529eb9ca@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  On 07/19/2010 04:49 PM, Neil Brown wrote:
> On Sat, 17 Jul 2010 16:15:55 -0500
> "Leslie Rhorer"<lrhorer@satx.rr.com>  wrote:
>
>> 	I'm thinking about changing the chunk size on one of my arrays in
>> order to potentially improve performance.  The man page rather suggests -c
>> is a vlaid option under Grow mode, although it doesn't specifically say
>> mdadm supports it under --grow.  Is it indeed supported under mdadm 2.6.7.2
>> and kernel 2.6.26-2?  Assuming so, I would like to know a bit more about the
>> change before issuing the command.  Speficialy, what are the details of the
>> process?  Does the entire (RAID 6) array have to be re-written, such as is
>> the case with adding a drive to the array?  Does the recovery start
>> immediately?  Can it be interrupted and then continue at a later time?
> Yes, you can change chunksize with --grow.
> I think you need mdadm-3.1.2 and kernel 2.6.32 though (version numbers might
> not be accurate, but are close).
>
> Yes, the entire array gets re-written just like adding an extra device.
> The reshape does start immediately.
> If you shutdown or crash, then on restart the reshape will pick up where it
> left off.

I ran mine with mdadm v3.1.2 on 2.6.33.6-147.fc13.x86_64 (Fedora)
Too bad I screwed up the FS by shrinking the array too much beforehand - 
now I have no idea whether it would've worked or not.

