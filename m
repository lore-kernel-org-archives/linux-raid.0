From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID-10 and 4 HDDs - how many HDDs can break without loosing data?
Date: Thu, 10 Aug 2006 12:39:39 +0200
Message-ID: <20060810103939.GA24269@percy.comedia.it>
References: <44DAF321.7090204@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44DAF321.7090204@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 10, 2006 at 10:49:37AM +0200, Tomasz Chmielewski wrote:
>With RAID-0 on top of RAID-1, with 4 drives, I would achieve:
>- 100% chance of recovery if any single, one disk fails,
>- 50% chance of recovery if any two disks fail.
>
>Now with RAID-10 in the Linux kernel, what are my chances of recovering 
>from a single and two disk failure?

>Is it also 100% if one disk fails, and 50% if two disks fail?

if the number of copies is 2 yes

>Or perhaps, with 4 drives, RAID-10 can survive any 2 disks failure?
nope

note that with raid10 the number of copies for each stripe does not need
to be a divisor of the number of drives.
e.g you can have 4 drives and 3 stripe copies.
in this case you are able to survive any 2 disk failure. but the usable
space is DRIVE_SIZE * 1.33

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
